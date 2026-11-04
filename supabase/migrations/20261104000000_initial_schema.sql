-- =====================================================================
-- Calorie Tracking App — cloud backup schema (Slice 2, Dependency 0)
-- Source: Architecture & Schema v1.0.2 §1.4 (entities), §1.6 (sync
-- membership), §2.5.3 (Postgres type mapping + minimal per-user RLS).
-- Mirrors the on-device drift tables (lib/data/tables.dart) 1:1.
--
-- Run once: paste into Supabase Dashboard → SQL Editor → Run.
-- Not included (by design): lookup_cache_entries (local-only),
-- outbox_entries (device-side queue only).
-- =====================================================================

-- ---------- User (root; no user_id — id IS the Supabase auth uid) ----
create table public.users (
  id          uuid primary key,
  created_at  timestamptz not null,
  updated_at  timestamptz not null,
  deleted_at  timestamptz,
  version     integer not null default 1
);

-- ---------- Per-user targets (1:1; nullable = not tracked) ------------
create table public.per_user_targets (
  id                  uuid primary key,
  user_id             uuid not null,
  created_at          timestamptz not null,
  updated_at          timestamptz not null,
  deleted_at          timestamptz,
  version             integer not null default 1,
  calorie_target      integer,
  protein_target      double precision,
  fiber_target        double precision,
  fruit_cups_target   double precision,
  veggie_cups_target  double precision,
  added_sugar_limit   double precision,
  carbs_limit_g       double precision,
  fats_limit_g        double precision,
  water_target        double precision,
  weight_target       double precision
);

-- ---------- Food entry ------------------------------------------------
create table public.food_entries (
  id               uuid primary key,
  user_id          uuid not null,
  created_at       timestamptz not null,
  updated_at       timestamptz not null,
  deleted_at       timestamptz,
  version          integer not null default 1,
  entry_timestamp  timestamptz not null,
  name             text not null,
  meal_type        text not null check (meal_type in ('breakfast','lunch','snack','dinner')),
  is_verified      boolean not null default true,
  quantity         double precision not null,
  unit             text not null check (unit in ('cups','g','oz','item')),
  calories         double precision not null default 0,
  protein_g        double precision not null default 0,
  carbs_g          double precision not null default 0,
  fats_g           double precision not null default 0,
  fiber_g          double precision not null default 0,
  added_sugar_g    double precision not null default 0,
  fruit_cups       double precision not null default 0,
  veggie_cups      double precision not null default 0
);

-- ---------- Saved item ------------------------------------------------
create table public.saved_items (
  id             uuid primary key,
  user_id        uuid not null,
  created_at     timestamptz not null,
  updated_at     timestamptz not null,
  deleted_at     timestamptz,
  version        integer not null default 1,
  name           text not null,
  quantity       double precision not null,
  unit           text not null check (unit in ('cups','g','oz','item')),
  calories       double precision not null default 0,
  protein_g      double precision not null default 0,
  carbs_g        double precision not null default 0,
  fats_g         double precision not null default 0,
  fiber_g        double precision not null default 0,
  added_sugar_g  double precision not null default 0,
  fruit_cups     double precision not null default 0,
  veggie_cups    double precision not null default 0
);

-- ---------- Water entry (used from Slice 3) ---------------------------
create table public.water_entries (
  id               uuid primary key,
  user_id          uuid not null,
  created_at       timestamptz not null,
  updated_at       timestamptz not null,
  deleted_at       timestamptz,
  version          integer not null default 1,
  entry_timestamp  timestamptz not null,
  amount           double precision not null
);

-- ---------- Weight entry (used from Slice 4) --------------------------
create table public.weight_entries (
  id               uuid primary key,
  user_id          uuid not null,
  created_at       timestamptz not null,
  updated_at       timestamptz not null,
  deleted_at       timestamptz,
  version          integer not null default 1,
  entry_timestamp  timestamptz not null,
  weight           double precision not null
);

-- ---------- Tracked supplement list (used from Slice 3) ---------------
create table public.tracked_supplements (
  id                  uuid primary key,
  user_id             uuid not null,
  created_at          timestamptz not null,
  updated_at          timestamptz not null,
  deleted_at          timestamptz,
  version             integer not null default 1,
  name                text not null,
  type                text not null check (type in ('dailyTarget','asNeeded')),
  daily_target_count  integer
);

-- ---------- Supplement entry (used from Slice 3) ----------------------
create table public.supplement_entries (
  id               uuid primary key,
  user_id          uuid not null,
  created_at       timestamptz not null,
  updated_at       timestamptz not null,
  deleted_at       timestamptz,
  version          integer not null default 1,
  entry_timestamp  timestamptz not null,
  supplement_id    uuid not null references public.tracked_supplements (id)
);

-- =====================================================================
-- Minimal per-user RLS (Arch §2.5.3, FSD Slice 2 §5.3 / G11)
-- Each row readable/writable only by its own user. Anonymous sign-ins
-- run as the `authenticated` role, so policies target that role.
-- No DELETE grant: v1 uses soft delete (an update), never hard delete.
-- =====================================================================

alter table public.users               enable row level security;
alter table public.per_user_targets    enable row level security;
alter table public.food_entries        enable row level security;
alter table public.saved_items         enable row level security;
alter table public.water_entries       enable row level security;
alter table public.weight_entries      enable row level security;
alter table public.tracked_supplements enable row level security;
alter table public.supplement_entries  enable row level security;

create policy "own row" on public.users
  for all to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));

create policy "own rows" on public.per_user_targets
  for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

create policy "own rows" on public.food_entries
  for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

create policy "own rows" on public.saved_items
  for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

create policy "own rows" on public.water_entries
  for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

create policy "own rows" on public.weight_entries
  for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

create policy "own rows" on public.tracked_supplements
  for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

create policy "own rows" on public.supplement_entries
  for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- Least-privilege grants: read + upsert only, signed-in users only.
revoke all on public.users, public.per_user_targets, public.food_entries,
  public.saved_items, public.water_entries, public.weight_entries,
  public.tracked_supplements, public.supplement_entries from anon;

grant select, insert, update on public.users, public.per_user_targets,
  public.food_entries, public.saved_items, public.water_entries,
  public.weight_entries, public.tracked_supplements,
  public.supplement_entries to authenticated;
