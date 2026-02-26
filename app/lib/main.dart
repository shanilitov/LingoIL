import 'package:flutter/material.dart';

import 'features/lesson_engine/presentation/lesson_player_page.dart';

void main() {
  runApp(const LingoIlApp());
}

class LingoIlApp extends StatelessWidget {
  const LingoIlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LessonPlayerPage(),
    );
  }
}
