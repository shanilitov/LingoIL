import 'package:flutter/material.dart';

import '../data/local_lesson_repository.dart';
import '../domain/lesson_models.dart';
import 'exercise_view.dart';

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
      appBar: AppBar(
        title: Text(lesson.titleHe, textDirection: TextDirection.rtl),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isDone ? _buildSummary(context, lesson) : _buildExercise(context, lesson),
      ),
    );
  }

  Widget _buildExercise(BuildContext context, Lesson lesson) {
    final exercise = lesson.exercises[_index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: (_index + 1) / lesson.exercises.length),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('XP: $_xp'),
            Text('❤️ $_hearts'),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
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
      ],
    );
  }

  Widget _buildSummary(BuildContext context, Lesson lesson) {
    final accuracy = lesson.exercises.isEmpty ? 0.0 : _correctCount / lesson.exercises.length;
    final passed = accuracy >= lesson.minAccuracy;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(passed ? 'כל הכבוד!' : 'כמעט הצלחת', textDirection: TextDirection.rtl),
          const SizedBox(height: 10),
          Text('Accuracy: ${(accuracy * 100).toStringAsFixed(0)}%'),
          Text('XP Earned: $_xp'),
          Text('Hearts Left: $_hearts'),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              setState(() {
                _index = 0;
                _xp = 0;
                _hearts = 5;
                _correctCount = 0;
              });
            },
            child: const Text('Retry'),
          )
        ],
      ),
    );
  }
}
