const List<String> localDbMigrations = [
  '''
  create table if not exists vocabulary_progress (
    user_id text not null,
    vocab_id text not null,
    repetition integer not null default 0,
    interval_days integer not null default 0,
    ease_factor real not null default 2.5,
    due_at text not null,
    last_quality integer,
    last_reviewed_at text,
    lapses integer not null default 0,
    success_streak integer not null default 0,
    total_reviews integer not null default 0,
    primary key (user_id, vocab_id)
  );
  ''',
  '''
  create table if not exists sync_queue (
    id integer primary key autoincrement,
    idempotency_key text not null unique,
    user_id text not null,
    event_type text not null,
    payload_json text not null,
    created_at text not null,
    sync_status text not null default 'pending',
    attempt_count integer not null default 0,
    last_error text
  );
  ''',
  '''
  create index if not exists idx_sync_queue_status_created
  on sync_queue(sync_status, created_at);
  ''',
  '''
  create table if not exists streak_state (
    user_id text primary key,
    current_streak integer not null default 0,
    longest_streak integer not null default 0,
    last_activity_date text,
    freeze_tokens integer not null default 0,
    updated_at text not null
  );
  ''',
];
