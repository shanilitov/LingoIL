import '../../lesson_engine/domain/lesson_models.dart';
import '../domain/progress_entities.dart';
import '../domain/srs_scheduler.dart';
import 'progress_service.dart';

class LessonProgressBinding {
  LessonProgressBinding({
    required this.userId,
    required this.progressService,
  });

  final String userId;
  final ProgressService progressService;

  Future<void> onExerciseEvaluated({
    required Exercise exercise,
    required bool isCorrect,
  }) async {
    final rating = isCorrect ? ReviewRating.correct : ReviewRating.wrong;
    final now = DateTime.now().toUtc();

    final vocabTargets = exercise.targets
        .where((target) => target.startsWith('vocab:'))
        .map((target) => target.replaceFirst('vocab:', ''))
        .toSet();

    for (final vocabId in vocabTargets) {
      await progressService.recordReview(
        ReviewEvent(
          userId: userId,
          vocabId: vocabId,
          rating: rating,
          reviewedAt: now,
        ),
      );
    }
  }
}
