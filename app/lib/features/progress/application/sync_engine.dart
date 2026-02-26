import '../data/sqlite_progress_repository.dart';

abstract class SyncApi {
  Future<void> pushEvent({
    required String idempotencyKey,
    required String eventType,
    required Map<String, Object?> payload,
    required String userId,
  });
}

class SyncEngine {
  SyncEngine({
    required SqliteProgressRepository repository,
    required SyncApi api,
  })  : _repository = repository,
        _api = api;

  final SqliteProgressRepository _repository;
  final SyncApi _api;

  Future<void> flushPending({int batchSize = 50}) async {
    final pending = await _repository.getPendingEvents(limit: batchSize);

    for (final event in pending) {
      try {
        await _api.pushEvent(
          idempotencyKey: event.idempotencyKey,
          eventType: event.eventType,
          payload: event.payload,
          userId: event.userId,
        );
        await _repository.markEventSynced(event.idempotencyKey);
      } catch (error) {
        await _repository.markEventFailed(event.idempotencyKey, error.toString());
      }
    }
  }
}
