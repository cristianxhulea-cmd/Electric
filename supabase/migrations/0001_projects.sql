create table public.projects (
  id text primary key,
  owner uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null default '',
  data jsonb not null,
  updated bigint not null default 0,
  deleted boolean not null default false,
  created_at timestamptz not null default now()
);

create index projects_owner_idx on public.projects(owner);

alter table public.projects enable row level security;

create policy "projects_select_own" on public.projects
  for select using (owner = auth.uid());
create policy "projects_insert_own" on public.projects
  for insert with check (owner = auth.uid());
create policy "projects_update_own" on public.projects
  for update using (owner = auth.uid()) with check (owner = auth.uid());
create policy "projects_delete_own" on public.projects
  for delete using (owner = auth.uid());
