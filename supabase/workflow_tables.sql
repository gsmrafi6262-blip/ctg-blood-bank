-- CTG Blood Bank clinical workflow tables (tracking only; no clinical decisions are automated)
create extension if not exists pgcrypto;
create table if not exists public.donation_events(
 id uuid primary key default gen_random_uuid(), donor_id uuid references public.donors(id) on delete set null,
 donation_date timestamptz not null default now(), volume_ml integer check(volume_ml between 1 and 1000),
 staff_user_id uuid references auth.users(id), notes text, created_at timestamptz default now());
create table if not exists public.screening_records(
 id uuid primary key default gen_random_uuid(), donor_id uuid references public.donors(id) on delete cascade,
 performed_by uuid references auth.users(id), screening_date timestamptz default now(),
 outcome text not null check(outcome in ('pending','eligible_for_review','deferred','referred')),
 notes text, created_at timestamptz default now());
create table if not exists public.lab_test_records(
 id uuid primary key default gen_random_uuid(), donation_id uuid references public.donation_events(id) on delete cascade,
 test_name text not null, performed_by uuid references auth.users(id), result_status text not null default 'pending',
 result_summary text, reviewed_by uuid references auth.users(id), reviewed_at timestamptz, created_at timestamptz default now());
create table if not exists public.processing_records(
 id uuid primary key default gen_random_uuid(), donation_id uuid references public.donation_events(id) on delete cascade,
 component text not null, processed_by uuid references auth.users(id), status text not null default 'pending',
 notes text, created_at timestamptz default now());
create table if not exists public.compatibility_tests(
 id uuid primary primary key default gen_random_uuid(), request_id uuid references public.blood_requests(id) on delete cascade,
 blood_unit_id uuid references public.blood_units(id), performed_by uuid references auth.users(id),
 result_status text not null default 'pending', reviewed_by uuid references auth.users(id), notes text, created_at timestamptz default now());
create table if not exists public.blood_issues(
 id uuid primary key default gen_random_uuid(), request_id uuid references public.blood_requests(id), blood_unit_id uuid references public.blood_units(id),
 issued_by uuid references auth.users(id), authorized_by uuid references auth.users(id), issued_at timestamptz default now(), notes text);
create table if not exists public.transfusion_records(
 id uuid primary key default gen_random_uuid(), request_id uuid references public.blood_requests(id), blood_issue_id uuid references public.blood_issues(id),
 recorded_by uuid references auth.users(id), transfusion_start timestamptz, transfusion_end timestamptz,
 observation_notes text, reaction_reported boolean default false, created_at timestamptz default now());
do $$declare t text; begin foreach t in array['donation_events','screening_records','lab_test_records','processing_records','compatibility_tests','blood_issues','transfusion_records'] loop execute format('alter table public.%I enable row level security',t); execute format('drop policy if exists staff_only_select on public.%I',t); execute format('create policy staff_only_select on public.%I for select to authenticated using (public.app_role() in (''staff'',''admin''))',t); execute format('drop policy if exists staff_only_manage on public.%I',t); execute format('create policy staff_only_manage on public.%I for all to authenticated using (public.app_role() in (''staff'',''admin'')) with check (public.app_role() in (''staff'',''admin''))',t); end loop; end$$;
grant select,insert,update,delete on public.donation_events,public.screening_records,public.lab_test_records,public.processing_records,public.compatibility_tests,public.blood_issues,public.transfusion_records to authenticated;
