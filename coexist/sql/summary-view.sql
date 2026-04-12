-- ═══════════════════════════════════════════════════
-- 共处指数 · Summary View
-- Run with service_role key or in Supabase SQL Editor
-- ═══════════════════════════════════════════════════

create or replace view coexist_summary as
select
  -- total completions
  count(*) filter (where result_id is not null) as total_completions,

  -- retake rate
  round(
    count(*) filter (where retake_count > 0)::numeric /
    nullif(count(*), 0) * 100, 1
  ) as retake_rate_pct,

  -- average completion time (seconds)
  round(avg(completion_ms) filter (where completion_ms > 0) / 1000.0, 0) as avg_completion_sec,

  -- average result dwell time (seconds)
  round(avg(result_dwell_ms) filter (where result_dwell_ms > 0) / 1000.0, 0) as avg_result_dwell_sec,

  -- one-line reply count
  count(*) filter (where one_line_submitted = true) as one_line_count,

  -- save card count
  count(*) filter (where saved_card = true) as save_card_count,

  -- support click count
  count(*) filter (where support_clicked = true) as support_click_count,

  -- hidden ending triggers
  count(*) filter (where hidden_ending is not null) as hidden_ending_total

from coexist_runs;

-- Top results query (run separately)
-- select result_id, count(*) as cnt
-- from coexist_runs where result_id is not null
-- group by result_id order by cnt desc limit 10;

-- Hidden ending breakdown
-- select hidden_ending, count(*) as cnt
-- from coexist_runs where hidden_ending is not null
-- group by hidden_ending order by cnt desc;

-- Time of day distribution
-- select time_bucket, count(*) as cnt
-- from coexist_runs
-- group by time_bucket order by cnt desc;

-- Rare result percentage (results with < 3% share)
-- with totals as (
--   select count(*) as total from coexist_runs where result_id is not null
-- )
-- select round(
--   (select count(*) from coexist_runs r
--    where r.result_id in (
--      select result_id from coexist_runs
--      where result_id is not null
--      group by result_id
--      having count(*)::numeric / (select total from totals) < 0.03
--    ))::numeric / nullif((select total from totals), 0) * 100, 1
-- ) as rare_pct;
