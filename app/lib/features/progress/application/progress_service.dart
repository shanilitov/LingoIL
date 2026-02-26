import 'dart:math';

import '../domain/progress_entities.dart';
import '../domain/srs_scheduler.dart';

abstract class ProgressRepository {
  Future<VocabularyProgress?> getProgress(String userId, String vocabId);

  Future<void> upsertProgress(VocabularyProgress progress);

  Future<void> enqueueSyncEvent(SyncQueueEvent event);
}

class ProgressService {
  ProgressService({
    required ProgressRepository repository,
    SrsScheduler? scheduler,
  })  : _repository = repository,
        _scheduler = scheduler ?? const SrsScheduler();

  final ProgressRepository _repository;
  final SrsScheduler _scheduler;

  Future<VocabularyProgress> recordReview(ReviewEvent event) async {
    final existing = await _repository.getProgress(event.userId, event.vocabId);

    final base = existing ?? VocabularyProgress.initial(userId: event.userId, vocabId: event.vocabId, now: event.reviewedAt);

    final updatedSrs = _scheduler.nextReview(
      state: base.srs,
      rating: event.rating,
      now: event.reviewedAt,
    );

    final isSuccess = event.rating != ReviewRating.wrong;

    final updated = base.copyWith(
      srs: updatedSrs,
      lapses: isSuccess ? base.lapses : base.lapses + 1,
      successStreak: isSuccess ? base.successStreak + 1 : 0,
      totalReviews: base.totalReviews + 1,
    );

    await _repository.upsertProgress(updated);

    await _repository.enqueueSyncEvent(
      SyncQueueEvent(
        idempotencyKey: _idempotencyKey(),
        userId: event.userId,
        eventType: 'review_recorded',
        payload: {
          'vocabId': event.vocabId,
          'rating': event.rating.name,
          'reviewedAt': event.reviewedAt.toUtc().toIso8601String(),
          'repetition': updated.srs.repetition,
          'intervalDays': updated.srs.intervalDays,
          'easeFactor': updated.srs.easeFactor,
          'dueAt': updated.srs.dueAt.toUtc().toIso8601String(),
        },
        createdAt: DateTime.now().toUtc(),
      ),
    );

    return updated;
  }

  String _idempotencyKey() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(1 << 32);
    return '$now-$random';
  }
}
