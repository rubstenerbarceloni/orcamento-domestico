-- Execute este script no SQL Editor do Supabase

create extension if not exists "uuid-ossp";

create table if not exists public.budget_categories (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  type text not null default 'both',
  updated_at timestamptz not null default now()
);

create table if not exists public.budget_entries (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null check (type in ('income','expense')),
  date date not null,
  description text not null,
  category text not null,
  amount numeric(14,2) not null,
  status text not null default 'previsto',
  account text,
  identifier text,
  notes text,
  isRecurring boolean not null default false,
  frequency text,
  recurringMode text,
  installments integer,
  updated_at timestamptz not null default now()
);

create table if not exists public.budget_settings (
  id uuid primary key references auth.users(id) on delete cascade,
  user_id uuid not null unique references auth.users(id) on delete cascade,
  initial_balance numeric(14,2) not null default 0,
  currency_code text not null default 'BRL',
  theme_name text not null default 'light',
  updated_at timestamptz not null default now()
);

create table if not exists public.budget_excluded_occurrences (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  occurrence_key text not null unique,
  updated_at timestamptz not null default now()
);

alter table public.budget_categories enable row level security;
alter table public.budget_entries enable row level security;
alter table public.budget_settings enable row level security;
alter table public.budget_excluded_occurrences enable row level security;

create policy if not exists "categories_select_own" on public.budget_categories for select using (auth.uid() = user_id);
create policy if not exists "categories_insert_own" on public.budget_categories for insert with check (auth.uid() = user_id);
create policy if not exists "categories_update_own" on public.budget_categories for update using (auth.uid() = user_id);
create policy if not exists "categories_delete_own" on public.budget_categories for delete using (auth.uid() = user_id);

create policy if not exists "entries_select_own" on public.budget_entries for select using (auth.uid() = user_id);
create policy if not exists "entries_insert_own" on public.budget_entries for insert with check (auth.uid() = user_id);
create policy if not exists "entries_update_own" on public.budget_entries for update using (auth.uid() = user_id);
create policy if not exists "entries_delete_own" on public.budget_entries for delete using (auth.uid() = user_id);

create policy if not exists "settings_select_own" on public.budget_settings for select using (auth.uid() = user_id);
create policy if not exists "settings_insert_own" on public.budget_settings for insert with check (auth.uid() = user_id);
create policy if not exists "settings_update_own" on public.budget_settings for update using (auth.uid() = user_id);
create policy if not exists "settings_delete_own" on public.budget_settings for delete using (auth.uid() = user_id);

create policy if not exists "excluded_select_own" on public.budget_excluded_occurrences for select using (auth.uid() = user_id);
create policy if not exists "excluded_insert_own" on public.budget_excluded_occurrences for insert with check (auth.uid() = user_id);
create policy if not exists "excluded_update_own" on public.budget_excluded_occurrences for update using (auth.uid() = user_id);
create policy if not exists "excluded_delete_own" on public.budget_excluded_occurrences for delete using (auth.uid() = user_id);
