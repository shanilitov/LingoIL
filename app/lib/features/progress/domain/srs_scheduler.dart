enum ReviewRating {
  wrong,
  hard,
  correct,
}

class SrsState {
  const SrsState({
    required this.repetition,
    required this.intervalDays,
    required this.easeFactor,
    required this.dueAt,
    this.lastQuality,
    this.lastReviewedAt,
  });

  final int repetition;
  final int intervalDays;
  final double easeFactor;
  final DateTime dueAt;
  final int? lastQuality;
  final DateTime? lastReviewedAt;

  SrsState copyWith({
    int? repetition,
    int? intervalDays,
    double? easeFactor,
    DateTime? dueAt,
    int? lastQuality,
    DateTime? lastReviewedAt,
  }) {
    return SrsState(
      repetition: repetition ?? this.repetition,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      dueAt: dueAt ?? this.dueAt,
      lastQuality: lastQuality ?? this.lastQuality,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }

  static SrsState initial(DateTime now) {
    return SrsState(
      repetition: 0,
      intervalDays: 0,
      easeFactor: 2.5,
      dueAt: now,
    );
  }
}

class SrsScheduler {
  const SrsScheduler();

  int qualityFromRating(ReviewRating rating) {
    switch (rating) {
      case ReviewRating.wrong:
        return 1;
      case ReviewRating.hard:
        return 3;
      case ReviewRating.correct:
        return 5;
    }
  }

  SrsState nextReview({
    required SrsState state,
    required ReviewRating rating,
    required DateTime now,
  }) {
    final quality = qualityFromRating(rating);

    var repetition = state.repetition;
    var intervalDays = state.intervalDays;
    var easeFactor = state.easeFactor;

    easeFactor = (easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))).clamp(1.3, 3.5);

    if (quality < 3) {
      repetition = 0;
      intervalDays = 1;
    } else {
      repetition += 1;
      if (repetition == 1) {
        intervalDays = 1;
      } else if (repetition == 2) {
        intervalDays = 3;
      } else {
        intervalDays = (intervalDays * easeFactor).round().clamp(1, 3650);
      }
    }

    final dueAt = now.add(Duration(days: intervalDays));

    return state.copyWith(
      repetition: repetition,
      intervalDays: intervalDays,
      easeFactor: easeFactor,
      dueAt: dueAt,
      lastQuality: quality,
      lastReviewedAt: now,
    );
  }
}
