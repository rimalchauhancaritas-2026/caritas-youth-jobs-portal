-- Caritas Youth Jobs Portal v1.2 — run this in Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.admin_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
create table if not exists public.jobs (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 180),
  organization text not null check (char_length(organization) between 1 and 180),
  category text not null check (category in ('Government','Private','Newspaper','Internship','NGO / Development')),
  city text not null check (city in ('Islamabad','Rawalpindi')),
  area text,
  qualification text not null,
  experience text,
  salary text,
  deadline date,
  source text,
  source_url text,
  apply_url text,
  description text,
  status text not null default 'draft' check (status in ('draft','published','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists jobs_public_listing_idx on public.jobs(status, created_at desc);
create or replace function public.is_portal_admin()
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.admin_profiles p where p.user_id = (select auth.uid()));
$$;
revoke all on function public.is_portal_admin() from public;
grant execute on function public.is_portal_admin() to anon, authenticated;
alter table public.jobs enable row level security;
alter table public.admin_profiles enable row level security;
drop policy if exists "Anyone can read published jobs" on public.jobs;
create policy "Anyone can read published jobs" on public.jobs for select to anon, authenticated using (status = 'published' or public.is_portal_admin());
drop policy if exists "Admins can insert jobs" on public.jobs;
create policy "Admins can insert jobs" on public.jobs for insert to authenticated with check (public.is_portal_admin());
drop policy if exists "Admins can update jobs" on public.jobs;
create policy "Admins can update jobs" on public.jobs for update to authenticated using (public.is_portal_admin()) with check (public.is_portal_admin());
drop policy if exists "Admins can delete jobs" on public.jobs;
create policy "Admins can delete jobs" on public.jobs for delete to authenticated using (public.is_portal_admin());
drop policy if exists "Admins can read admin profiles" on public.admin_profiles;
create policy "Admins can read admin profiles" on public.admin_profiles for select to authenticated using (public.is_portal_admin() or user_id = (select auth.uid()));
-- Intentionally no public insert/update policy on admin_profiles. Never let users self-assign admin rights.
