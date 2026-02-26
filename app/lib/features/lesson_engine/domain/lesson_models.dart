enum ExerciseType {
  translateHeToEn,
  listenToText,
  buildSentence,
}

ExerciseType exerciseTypeFromString(String value) {
  switch (value) {
    case 'translate_he_to_en':
      return ExerciseType.translateHeToEn;
    case 'listen_to_text':
      return ExerciseType.listenToText;
    case 'build_sentence':
      return ExerciseType.buildSentence;
    default:
      throw FormatException('Unknown exercise type: $value');
  }
}

class Lesson {
  Lesson({
    required this.lessonId,
    required this.skillKey,
    required this.version,
    required this.titleHe,
    required this.estimatedMinutes,
    required this.learningObjectives,
    required this.exercises,
    required this.minAccuracy,
    required this.minExercisesCompleted,
    required this.rewards,
  });

  final String lessonId;
  final String skillKey;
  final int version;
  final String titleHe;
  final int estimatedMinutes;
  final List<String> learningObjectives;
  final List<Exercise> exercises;
  final double minAccuracy;
  final int minExercisesCompleted;
  final LessonRewards rewards;
}

class LessonRewards {
  LessonRewards({
    required this.xpTotal,
    required this.unlockSkillKey,
  });

  final int xpTotal;
  final String unlockSkillKey;
}

class Exercise {
  Exercise({
    required this.id,
    required this.type,
    required this.promptHe,
    required this.xp,
    required this.heartsPenalty,
    required this.targets,
    this.sourceTextHe,
    this.acceptedAnswers = const [],
    this.hints = const [],
    this.audioUrl,
    this.transcriptEn,
    this.sttEnabled,
    this.tokens = const [],
    this.correctOrder = const [],
    this.distractors = const [],
  });

  final String id;
  final ExerciseType type;
  final String promptHe;
  final int xp;
  final int heartsPenalty;
  final List<String> targets;

  final String? sourceTextHe;
  final List<String> acceptedAnswers;
  final List<String> hints;

  final String? audioUrl;
  final String? transcriptEn;
  final bool? sttEnabled;

  final List<String> tokens;
  final List<String> correctOrder;
  final List<String> distractors;
}
