# LingoIL MVP Foundation

## Stack Decision
- Mobile: Flutter (Dart)
- Backend: Supabase (PostgreSQL + Auth + Storage + Edge Functions)
- Local DB: SQLite (via Drift)
- Sync Pattern: Local-first with append-only `sync_queue`

## High-level Architecture
```mermaid
flowchart LR
    A[Flutter App] --> B[Domain Layer\nSRS + Lesson Engine + Gamification]
    B --> C[Local SQLite (Drift)]
    B --> D[Sync Engine\nQueue + Retry + Conflict Resolution]
    D <--> E[Supabase API]
    E <--> F[(PostgreSQL)]
    E <--> G[Storage: audio/images]
    E <--> H[Edge Functions\nvalidation + aggregates]
```

## RTL/LTR Rules
- Global app direction follows locale (`he` => RTL, `en` => LTR).
- English learning targets are always rendered in explicit LTR containers.
- Mixed sentence rendering uses Unicode isolates:
  - LTR isolate: `\u2066 ... \u2069`
  - RTL isolate: `\u2067 ... \u2069`
- Input fields are direction-specific:
  - Hebrew answer fields: RTL
  - English answer fields: LTR

## MVP Modules
1. Auth/Profile
2. Lesson Renderer (from JSON)
3. SRS Review Queue (SM-2)
4. Gamification (XP/Hearts/Streak)
5. Sync + Offline cache

## Next Build Step (Immediate)
- Create Flutter app shell and wire these assets:
  - Load lesson JSON from `content/lessons`
  - Call SRS function after each review exercise
  - Persist progress in SQLite and enqueue sync events
