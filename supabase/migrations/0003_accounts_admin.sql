create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text not null default '',
  role text not null default 'user' check (role in ('user', 'admin')),
  status text not null default 'trial' check (status in ('trial', 'active', 'suspended')),
  valid_until timestamptz not null default (now() + interval '14 days'),
  created_at timestamptz not null default now(),
  last_seen timestamptz
);
alter table public.profiles enable row level security;

create table if not exists public.admin_log (
  id bigint generated always as identity primary key,
  at timestamptz not null default now(),
  admin_id uuid,
  target_id uuid,
  target_email text not null default '',
  action text not null,
  detail jsonb not null default '{}'::jsonb
);
alter table public.admin_log enable row level security;

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.profiles p where p.user_id = auth.uid() and p.role = 'admin');
$$;

create or replace function public.is_licensed()
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.profiles p
    where p.user_id = auth.uid()
      and (p.role = 'admin' or (p.status in ('trial', 'active') and p.valid_until > now()))
  );
$$;

drop policy if exists "profiles_select" on public.profiles;
create policy "profiles_select" on public.profiles
  for select to authenticated using (user_id = (select auth.uid()) or (select public.is_admin()));

drop policy if exists "admin_log_select" on public.admin_log;
create policy "admin_log_select" on public.admin_log
  for select to authenticated using ((select public.is_admin()));

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (user_id, email) values (new.id, coalesce(new.email, ''))
  on conflict (user_id) do nothing;
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

insert into public.profiles (user_id, email, status, valid_until)
select id, coalesce(email, ''), 'active', now() + interval '30 days' from auth.users
on conflict (user_id) do nothing;

create or replace function public.touch_profile()
returns void language sql security definer set search_path = '' as $$
  update public.profiles set last_seen = now() where user_id = auth.uid();
$$;

create or replace function public.admin_list_users()
returns table (
  user_id uuid, email text, role text, status text, valid_until timestamptz,
  created_at timestamptz, last_seen timestamptz, last_sign_in timestamptz, device text, projects bigint
)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.is_admin() then raise exception 'forbidden' using errcode = '42501'; end if;
  return query
    select p.user_id, p.email, p.role, p.status, p.valid_until, p.created_at, p.last_seen,
           u.last_sign_in_at, s.device,
           (select count(*) from public.projects x where x.owner = p.user_id and not x.deleted and x.id not like 'cfg-%')
    from public.profiles p
    left join auth.users u on u.id = p.user_id
    left join public.active_sessions s on s.user_id = p.user_id
    order by p.created_at desc;
end $$;

create or replace function public.admin_update_user(target uuid, new_status text default null, add_days int default null, kick boolean default false)
returns void language plpgsql security definer set search_path = '' as $$
declare em text;
begin
  if not public.is_admin() then raise exception 'forbidden' using errcode = '42501'; end if;
  if target = auth.uid() and (new_status = 'suspended' or kick) then raise exception 'self' using errcode = '22023'; end if;
  select p.email into em from public.profiles p where p.user_id = target;
  if em is null then raise exception 'not found' using errcode = 'P0002'; end if;
  if new_status is not null then
    if new_status not in ('trial', 'active', 'suspended') then raise exception 'status' using errcode = '22023'; end if;
    update public.profiles set status = new_status where user_id = target;
  end if;
  if add_days is not null then
    update public.profiles set valid_until = greatest(valid_until, now()) + make_interval(days => add_days) where user_id = target;
  end if;
  if kick or new_status = 'suspended' then
    delete from public.active_sessions where user_id = target;
    begin
      delete from auth.sessions where user_id = target;
    exception when others then null;
    end;
  end if;
  insert into public.admin_log (admin_id, target_id, target_email, action, detail)
  values (auth.uid(), target, em,
          case when new_status is not null then 'status:' || new_status when add_days is not null then 'extend' else 'kick' end,
          jsonb_build_object('add_days', add_days, 'kick', kick));
end $$;

create or replace function public.admin_delete_user(target uuid)
returns void language plpgsql security definer set search_path = '' as $$
declare em text;
begin
  if not public.is_admin() then raise exception 'forbidden' using errcode = '42501'; end if;
  if target = auth.uid() then raise exception 'self' using errcode = '22023'; end if;
  select p.email into em from public.profiles p where p.user_id = target;
  insert into public.admin_log (admin_id, target_id, target_email, action) values (auth.uid(), target, coalesce(em, ''), 'delete');
  delete from auth.users where id = target;
end $$;

revoke execute on function public.touch_profile() from public, anon;
revoke execute on function public.admin_list_users() from public, anon;
revoke execute on function public.admin_update_user(uuid, text, int, boolean) from public, anon;
revoke execute on function public.admin_delete_user(uuid) from public, anon;
grant execute on function public.touch_profile() to authenticated;
grant execute on function public.admin_list_users() to authenticated;
grant execute on function public.admin_update_user(uuid, text, int, boolean) to authenticated;
grant execute on function public.admin_delete_user(uuid) to authenticated;

drop policy if exists "projects_select_own" on public.projects;
drop policy if exists "projects_insert_own" on public.projects;
drop policy if exists "projects_update_own" on public.projects;
drop policy if exists "projects_delete_own" on public.projects;

create policy "projects_select_own" on public.projects
  for select to authenticated using (owner = (select auth.uid()) and (select public.is_active_session()) and (select public.is_licensed()));
create policy "projects_insert_own" on public.projects
  for insert to authenticated with check (owner = (select auth.uid()) and (select public.is_active_session()) and (select public.is_licensed()));
create policy "projects_update_own" on public.projects
  for update to authenticated using (owner = (select auth.uid()) and (select public.is_active_session()) and (select public.is_licensed()))
  with check (owner = (select auth.uid()) and (select public.is_active_session()) and (select public.is_licensed()));
create policy "projects_delete_own" on public.projects
  for delete to authenticated using (owner = (select auth.uid()) and (select public.is_active_session()) and (select public.is_licensed()));
