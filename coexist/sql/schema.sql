-- ═══════════════════════════════════════════════════
-- 共处指数 · Coexist Index — Supabase Schema
-- Edition 01
-- ═══════════════════════════════════════════════════

-- 1. coexist_runs — one row per quiz completion
create table if not exists coexist_runs (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  session_id text not null,
  run_id text not null unique,
  result_id text,
  result_type text,
  completion_ms integer,
  retake_count integer default 0,
  hidden_ending text,
  score_recovery integer,
  score_boundary integer,
  score_sobriety integer,
  score_truth integer,
  score_coexist integer,
  path_depth integer,
  time_bucket text,
  result_dwell_ms integer,
  saved_card boolean default false,
  one_line_submitted boolean default false,
  support_clicked boolean default false
);

create index if not exists idx_runs_session on coexist_runs (session_id);
create index if not exists idx_runs_result on coexist_runs (result_id);
create index if not exists idx_runs_created on coexist_runs (created_at);
create index if not exists idx_runs_time_bucket on coexist_runs (time_bucket);

-- 2. coexist_events — raw event log
create table if not exists coexist_events (
  id bigint generated always as identity primary key,
  created_at timestamptz default now(),
  session_id text not null,
  run_id text,
  event_name text not null,
  payload_json jsonb default '{}'::jsonb
);

create index if not exists idx_events_session on coexist_events (session_id);
create index if not exists idx_events_name on coexist_events (event_name);
create index if not exists idx_events_created on coexist_events (created_at);

-- 3. coexist_one_lines — user-submitted single lines
create table if not exists coexist_one_lines (
  id bigint generated always as identity primary key,
  created_at timestamptz default now(),
  session_id text not null,
  run_id text,
  result_id text,
  content text not null
);

create index if not exists idx_onelines_result on coexist_one_lines (result_id);
create index if not exists idx_onelines_created on coexist_one_lines (created_at);

-- ═══════════════════════════════════════════════════
-- RLS — anon can insert + update, select only on coexist_runs
-- ═══════════════════════════════════════════════════

alter table coexist_runs enable row level security;
alter table coexist_events enable row level security;
alter table coexist_one_lines enable row level security;

-- Insert for anon
create policy "anon_insert_runs" on coexist_runs
  for insert to anon with check (true);

create policy "anon_insert_events" on coexist_events
  for insert to anon with check (true);

create policy "anon_insert_onelines" on coexist_one_lines
  for insert to anon with check (true);

-- Update for anon (needed for trackEvent run updates)
create policy "anon_update_runs" on coexist_runs
  for update to anon using (true) with check (true);

-- Select for anon on coexist_runs (needed for UPDATE to find matching rows)
create policy "anon_select_runs" on coexist_runs
  for select to anon using (true);

-- No select for anon on events or one_lines tables
-- Admin/service_role can read everything via Supabase dashboard or service key
