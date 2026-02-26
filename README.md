# LingoIL
Duolingo-style app for Hebrew speakers learning English.

## Project Foundation

- Architecture and implementation notes: `docs/mvp-foundation.md`
- Supabase SQL migration: `supabase/migrations/20260226_initial_schema.sql`
- Lesson JSON example: `content/lessons/food_basics_01.json`
- SRS module (TypeScript): `packages/srs/src/sm2.ts`
- RTL/LTR mixed text helper (Dart): `app/lib/core/i18n/bidi_text.dart`
- Offline progress service: `app/lib/features/progress/application/progress_service.dart`
- SQLite sync queue repo: `app/lib/features/progress/data/sqlite_progress_repository.dart`

## MVP Start Sequence

1. Create the Flutter shell in `app/`:
	- `flutter create app --platforms=android,ios`
2. Add local DB + state dependencies:
	- `drift`, `sqlite3_flutter_libs`, `sqflite`, `path_provider`, `riverpod`, `freezed`, `go_router`
3. Connect Supabase and apply migration:
	- `supabase db push`
4. Implement first lesson renderer using `content/lessons/food_basics_01.json`.
5. After each exercise, update SRS state and persist into local SQLite + sync queue.

## Immediate Build Target

- Build one playable lesson loop (Translate + Listen + Build Sentence)
- Persist progress locally offline
- Sync progress when online

## Integrate Lesson Renderer (after bootstrap)

1. In `app/pubspec.yaml`, add asset path:
	- `assets/lessons/`
2. Use `LessonPlayerPage` as initial screen from:
	- `app/lib/features/lesson_engine/presentation/lesson_player_page.dart`
3. Run app:
	- `cd app && flutter run`

## Offline-first Progress Flow

1. Build DB and repository:
	- `db = await openLingoIlDatabase()`
	- `repo = SqliteProgressRepository(db)`
2. Build progress service:
	- `progress = ProgressService(repository: repo)`
3. On exercise result, call `recordReview(...)` for each vocab target.
4. Run `SyncEngine.flushPending()` when connectivity is available.
