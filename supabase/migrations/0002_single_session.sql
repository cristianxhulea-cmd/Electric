create table if not exists public.active_sessions (
  user_id uuid primary key references auth.users(id) on delete cascade,
  session_id uuid not null,
  device text not null default '',
  claimed_at timestamptz not null default now()
);

alter table public.active_sessions enable row level security;

drop policy if exists "active_sessions_select_own" on public.active_sessions;
drop policy if exists "active_sessions_insert_own" on public.active_sessions;
drop policy if exists "active_sessions_update_own" on public.active_sessions;

create policy "active_sessions_select_own" on public.active_sessions
  for select to authenticated using (user_id = (select auth.uid()));
create policy "active_sessions_insert_own" on public.active_sessions
  for insert to authenticated with check (user_id = (select auth.uid()) and session_id = ((select auth.jwt()) ->> 'session_id')::uuid);
create policy "active_sessions_update_own" on public.active_sessions
  for update to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()) and session_id = ((select auth.jwt()) ->> 'session_id')::uuid);

create or replace function public.is_active_session()
returns boolean
language sql
stable
set search_path = ''
as $$
  select exists (
    select 1 from public.active_sessions a
    where a.user_id = auth.uid()
      and a.session_id = (auth.jwt() ->> 'session_id')::uuid
  );
$$;

drop policy if exists "projects_select_own" on public.projects;
drop policy if exists "projects_insert_own" on public.projects;
drop policy if exists "projects_update_own" on public.projects;
drop policy if exists "projects_delete_own" on public.projects;

create policy "projects_select_own" on public.projects
  for select to authenticated using (owner = (select auth.uid()) and (select public.is_active_session()));
create policy "projects_insert_own" on public.projects
  for insert to authenticated with check (owner = (select auth.uid()) and (select public.is_active_session()));
create policy "projects_update_own" on public.projects
  for update to authenticated using (owner = (select auth.uid()) and (select public.is_active_session())) with check (owner = (select auth.uid()) and (select public.is_active_session()));
create policy "projects_delete_own" on public.projects
  for delete to authenticated using (owner = (select auth.uid()) and (select public.is_active_session()));
