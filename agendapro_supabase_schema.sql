-- AgendaPro: esquema inicial Supabase/PostgreSQL
-- Execute no SQL Editor do seu próprio projeto Supabase.
-- As políticas RLS limitam cada registro ao usuário autenticado proprietário.

create extension if not exists pgcrypto;

create table if not exists public.professional_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  professional_name text not null default '',
  specialty text not null default '',
  phone text not null default '',
  instagram text not null default '',
  bio text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  phone text not null default '',
  email text not null default '',
  created_at timestamptz not null default now(),
  unique (user_id, id)
);

create table if not exists public.services (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  price numeric(10,2) not null default 0 check (price >= 0),
  duration_minutes integer not null default 60 check (duration_minutes > 0),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (user_id, id)
);

create table if not exists public.appointments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  client_id uuid,
  service_id uuid,
  appointment_date date not null,
  appointment_time time not null,
  notes text not null default '',
  status text not null default 'agendado' check (status in ('agendado','concluído','cancelado','não compareceu')),
  created_at timestamptz not null default now(),
  constraint appointment_client_belongs_to_user foreign key (user_id, client_id) references public.clients(user_id, id) on delete set null (client_id),
  constraint appointment_service_belongs_to_user foreign key (user_id, service_id) references public.services(user_id, id) on delete set null (service_id)
);

create table if not exists public.financial_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  description text not null,
  amount numeric(10,2) not null check (amount >= 0),
  entry_date date not null default current_date,
  status text not null default 'pendente' check (status in ('recebido','pendente')),
  created_at timestamptz not null default now()
);

create index if not exists clients_user_id_idx on public.clients(user_id);
create index if not exists services_user_id_idx on public.services(user_id);
create index if not exists appointments_user_date_idx on public.appointments(user_id, appointment_date);
create index if not exists financial_entries_user_date_idx on public.financial_entries(user_id, entry_date);

alter table public.professional_profiles enable row level security;
alter table public.clients enable row level security;
alter table public.services enable row level security;
alter table public.appointments enable row level security;
alter table public.financial_entries enable row level security;

drop policy if exists "profiles own rows" on public.professional_profiles;
create policy "profiles own rows" on public.professional_profiles for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "clients own rows" on public.clients;
create policy "clients own rows" on public.clients for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "services own rows" on public.services;
create policy "services own rows" on public.services for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "appointments own rows" on public.appointments;
create policy "appointments own rows" on public.appointments for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "financial entries own rows" on public.financial_entries;
create policy "financial entries own rows" on public.financial_entries for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- IMPORTANTE: as tabelas possuem RLS, mas o HTML entregue ainda não implementa
-- as operações CRUD no Supabase. Não use com dados reais até integrar e testar
-- leitura/escrita de cada tabela, validação dos relacionamentos e recuperação de senha.
