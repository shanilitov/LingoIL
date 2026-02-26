import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/local_lesson_repository.dart';
import '../domain/lesson_models.dart';
import 'exercise_view.dart';
import 'widgets/neo_action_button.dart';

typedef ExerciseEvaluated = void Function({
  required Exercise exercise,
  required bool isCorrect,
});

class LessonPlayerPage extends StatefulWidget {
  const LessonPlayerPage({
    super.key,
    this.lessonAsset = 'assets/lessons/food_basics_01.json',
    this.onExerciseEvaluated,
  });

  final String lessonAsset;
  final ExerciseEvaluated? onExerciseEvaluated;

  @override
  State<LessonPlayerPage> createState() => _LessonPlayerPageState();
}

class _LessonPlayerPageState extends State<LessonPlayerPage> {
  final LocalLessonRepository _repository = LocalLessonRepository();

  Lesson? _lesson;
  int _index = 0;
  int _xp = 0;
  int _hearts = 5;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    final lesson = await _repository.loadLessonByAsset(widget.lessonAsset);
    if (!mounted) return;
    setState(() => _lesson = lesson);
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _lesson;
    if (lesson == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isDone = _index >= lesson.exercises.length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: isDone ? _buildSummary(context, lesson) : _buildExercise(context, lesson),
        ),
      ),
    );
  }

  Widget _buildExercise(BuildContext context, Lesson lesson) {
    final exercise = lesson.exercises[_index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.neutral500),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: (_index + 1) / lesson.exercises.length,
                  minHeight: 14,
                  backgroundColor: AppColors.neutral200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.learningPrimary),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Row(
              children: [
                const Icon(Icons.favorite_rounded, color: AppColors.error, size: 24),
                const SizedBox(width: 4),
                Text(
                  '$_hearts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lesson.titleHe,
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.neutral700,
                  ),
            ),
            _StatPill(label: 'XP', value: '$_xp', icon: Icons.auto_awesome_rounded),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                child: SingleChildScrollView(
                  child: ExerciseView(
                    exercise: exercise,
                    onResult: (isCorrect, xp, heartsPenalty) {
                      widget.onExerciseEvaluated?.call(
                        exercise: exercise,
                        isCorrect: isCorrect,
                      );

                      setState(() {
                        if (isCorrect) _correctCount += 1;
                        _xp += xp;
                        _hearts = (_hearts - heartsPenalty).clamp(0, 5);
                        _index += 1;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context, Lesson lesson) {
    final accuracy = lesson.exercises.isEmpty ? 0.0 : _correctCount / lesson.exercises.length;
    final passed = accuracy >= lesson.minAccuracy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Icon(
          passed ? Icons.celebration_rounded : Icons.auto_awesome_rounded,
          size: 86,
          color: passed ? AppColors.motivationAccent : AppColors.warning,
        ),
        const SizedBox(height: 18),
        Text(
          passed ? 'Lesson Complete!' : 'Almost there!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _SummaryStat(
                title: 'TOTAL XP',
                value: '$_xp',
                icon: Icons.bolt_rounded,
                color: AppColors.motivationAccent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryStat(
                title: 'ACCURACY',
                value: '${(accuracy * 100).toStringAsFixed(0)}%',
                icon: Icons.track_changes_rounded,
                color: AppColors.learningPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _SummaryStat(
          title: 'HEARTS LEFT',
          value: '$_hearts',
          icon: Icons.favorite_rounded,
          color: AppColors.error,
        ),
        const Spacer(),
        NeoActionButton(
          label: 'Continue',
          icon: Icons.arrow_forward_rounded,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        const SizedBox(height: 10),
        NeoActionButton(
          label: 'Retry',
          enabled: true,
          onPressed: () {
            setState(() {
              _index = 0;
              _xp = 0;
              _hearts = 5;
              _correctCount = 0;
            });
          },
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neutral200, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.motivationAccent),
          const SizedBox(width: 6),
          Text('$label: $value', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.7), width: 1.4),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.neutral900,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
