import '../domain/lesson_models.dart';

class LessonParser {
  const LessonParser();

  Lesson parse(Map<String, dynamic> json) {
    final completionRules = (json['completionRules'] as Map<String, dynamic>? ?? {});
    final rewards = (json['rewards'] as Map<String, dynamic>? ?? {});

    return Lesson(
      lessonId: json['lessonId'] as String,
      skillKey: json['skillKey'] as String,
      version: (json['version'] as num).toInt(),
      titleHe: json['titleHe'] as String,
      estimatedMinutes: (json['estimatedMinutes'] as num).toInt(),
      learningObjectives: _stringList(json['learningObjectives']),
      exercises: _parseExercises(json['exercises'] as List<dynamic>? ?? const []),
      minAccuracy: (completionRules['minAccuracy'] as num?)?.toDouble() ?? 0.7,
      minExercisesCompleted: (completionRules['minExercisesCompleted'] as num?)?.toInt() ?? 1,
      rewards: LessonRewards(
        xpTotal: (rewards['xpTotal'] as num?)?.toInt() ?? 0,
        unlockSkillKey: (rewards['unlockSkillKey'] as String?) ?? '',
      ),
    );
  }

  List<Exercise> _parseExercises(List<dynamic> raw) {
    return raw
        .cast<Map<String, dynamic>>()
        .map(
          (item) => Exercise(
            id: item['id'] as String,
            type: exerciseTypeFromString(item['type'] as String),
            promptHe: item['promptHe'] as String,
            xp: (item['xp'] as num?)?.toInt() ?? 0,
            heartsPenalty: (item['heartsPenalty'] as num?)?.toInt() ?? 1,
            targets: _stringList(item['targets']),
            sourceTextHe: item['sourceTextHe'] as String?,
            acceptedAnswers: _stringList(item['acceptedAnswers']),
            hints: _stringList(item['hints']),
            audioUrl: item['audioUrl'] as String?,
            transcriptEn: item['transcriptEn'] as String?,
            sttEnabled: item['sttEnabled'] as bool?,
            tokens: _stringList(item['tokens']),
            correctOrder: _stringList(item['correctOrder']),
            distractors: _stringList(item['distractors']),
          ),
        )
        .toList(growable: false);
  }

  List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((entry) => entry.toString()).toList(growable: false);
  }
}
