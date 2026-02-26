import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/lesson_models.dart';
import 'lesson_parser.dart';

class LocalLessonRepository {
  LocalLessonRepository({LessonParser? parser}) : _parser = parser ?? const LessonParser();

  final LessonParser _parser;

  Future<Lesson> loadLessonByAsset(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return _parser.parse(json);
  }
}
