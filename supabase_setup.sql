create table if not exists public.mystudy (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  kind text not null check (kind in ('question','note','state')),
  id text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, kind, id)
);
alter table public.mystudy enable row level security;
create policy "own rows select" on public.mystudy for select to authenticated using (user_id = auth.uid());
create policy "own rows insert" on public.mystudy for insert to authenticated with check (user_id = auth.uid());
create policy "own rows update" on public.mystudy for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own rows delete" on public.mystudy for delete to authenticated using (user_id = auth.uid());
