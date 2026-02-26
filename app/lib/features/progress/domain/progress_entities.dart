import 'srs_scheduler.dart';

class VocabularyProgress {
  const VocabularyProgress({
    required this.userId,
    required this.vocabId,
    required this.srs,
    required this.lapses,
    required this.successStreak,
    required this.totalReviews,
  });

  final String userId;
  final String vocabId;
  final SrsState srs;
  final int lapses;
  final int successStreak;
  final int totalReviews;

  VocabularyProgress copyWith({
    String? userId,
    String? vocabId,
    SrsState? srs,
    int? lapses,
    int? successStreak,
    int? totalReviews,
  }) {
    return VocabularyProgress(
      userId: userId ?? this.userId,
      vocabId: vocabId ?? this.vocabId,
      srs: srs ?? this.srs,
      lapses: lapses ?? this.lapses,
      successStreak: successStreak ?? this.successStreak,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  static VocabularyProgress initial({
    required String userId,
    required String vocabId,
    required DateTime now,
  }) {
    return VocabularyProgress(
      userId: userId,
      vocabId: vocabId,
      srs: SrsState.initial(now),
      lapses: 0,
      successStreak: 0,
      totalReviews: 0,
    );
  }
}

class ReviewEvent {
  const ReviewEvent({
    required this.userId,
    required this.vocabId,
    required this.rating,
    required this.reviewedAt,
  });

  final String userId;
  final String vocabId;
  final ReviewRating rating;
  final DateTime reviewedAt;
}

class SyncQueueEvent {
  const SyncQueueEvent({
    required this.idempotencyKey,
    required this.userId,
    required this.eventType,
    required this.payload,
    required this.createdAt,
  });

  final String idempotencyKey;
  final String userId;
  final String eventType;
  final Map<String, Object?> payload;
  final DateTime createdAt;
}
