import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../lesson_engine/presentation/lesson_player_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const lessons = [
      ('Food Basics', true),
      ('Daily Phrases', false),
      ('At the Airport', false),
      ('Work Conversations', false),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('מפת לימוד', textDirection: TextDirection.rtl),
        actions: const [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 16),
            child: Center(
              child: Text('🔥 3', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.motivationAccent)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.neutral0,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 3)),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('יחידה 1', textDirection: TextDirection.rtl, style: TextStyle(fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('מילים בסיסיות ושיחות קצרות', textDirection: TextDirection.rtl),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...List.generate(lessons.length, (index) {
            final (title, unlocked) = lessons[index];
            return _MapNode(
              index: index + 1,
              title: title,
              unlocked: unlocked,
              onTap: unlocked
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LessonPlayerPage()),
                      );
                    }
                  : null,
            );
          }),
        ],
      ),
    );
  }
}

class _MapNode extends StatelessWidget {
  const _MapNode({
    required this.index,
    required this.title,
    required this.unlocked,
    required this.onTap,
  });

  final int index;
  final String title;
  final bool unlocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final nodeColor = unlocked ? AppColors.learningPrimary : AppColors.neutral300;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 2,
              color: AppColors.neutral200,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: nodeColor,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: Center(
                child: unlocked
                    ? Text(
                        '$index',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                      )
                    : const Icon(Icons.lock, size: 20, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                color: unlocked ? AppColors.neutral900 : AppColors.neutral500,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
