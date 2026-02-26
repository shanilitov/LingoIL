create extension if not exists pgcrypto;

create table if not exists users (
  id uuid primary key,
  email text unique not null,
  native_lang text not null default 'he',
  target_lang text not null default 'en',
  created_at timestamptz not null default now()
);

create table if not exists lessons (
  id uuid primary key default gen_random_uuid(),
  skill_key text not null,
  level int not null,
  version int not null default 1,
  title_he text not null,
  est_minutes int not null default 5,
  json_schema jsonb not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists vocabulary_items (
  id uuid primary key default gen_random_uuid(),
  lemma_en text not null,
  translation_he text not null,
  pos text,
  ipa text,
  audio_url text,
  example_en text,
  example_he text,
  tags text[] default '{}'
);

create table if not exists vocabulary_progress (
  id bigserial primary key,
  user_id uuid not null references users(id) on delete cascade,
  vocab_id uuid not null references vocabulary_items(id) on delete cascade,
  repetition int not null default 0,
  interval_days int not null default 0,
  ease_factor numeric(4,2) not null default 2.50,
  due_at timestamptz not null default now(),
  last_reviewed_at timestamptz,
  last_quality int check (last_quality between 0 and 5),
  lapses int not null default 0,
  success_streak int not null default 0,
  total_reviews int not null default 0,
  unique(user_id, vocab_id)
);

create index if not exists idx_vocab_progress_due
  on vocabulary_progress(user_id, due_at);

create table if not exists lesson_attempts (
  id bigserial primary key,
  user_id uuid not null references users(id) on delete cascade,
  lesson_id uuid not null references lessons(id),
  score numeric(5,2) not null,
  xp_earned int not null default 0,
  hearts_lost int not null default 0,
  started_at timestamptz not null,
  completed_at timestamptz
);

create table if not exists streaks (
  user_id uuid primary key references users(id) on delete cascade,
  current_streak int not null default 0,
  longest_streak int not null default 0,
  last_activity_date date,
  freeze_tokens int not null default 0,
  updated_at timestamptz not null default now()
);

create table if not exists daily_stats (
  user_id uuid not null references users(id) on delete cascade,
  stat_date date not null,
  xp_gained int not null default 0,
  lessons_completed int not null default 0,
  reviews_completed int not null default 0,
  hearts_remaining int not null default 5,
  primary key (user_id, stat_date)
);

create table if not exists sync_events (
  id bigserial primary key,
  user_id uuid not null references users(id) on delete cascade,
  event_type text not null,
  payload jsonb not null,
  idempotency_key text not null,
  created_at timestamptz not null default now(),
  processed_at timestamptz,
  unique(idempotency_key)
);
