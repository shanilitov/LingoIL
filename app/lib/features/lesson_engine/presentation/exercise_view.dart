import 'package:flutter/material.dart';

import '../../../core/i18n/bidi_text.dart';
import '../domain/lesson_models.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({
    super.key,
    required this.exercise,
    required this.onResult,
  });

  final Exercise exercise;
  final void Function(bool isCorrect, int xp, int heartsPenalty) onResult;

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _selectedTokens = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          exercise.promptHe,
          textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (exercise.sourceTextHe != null)
          Text(
            exercise.sourceTextHe!,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        if (exercise.type == ExerciseType.listenToText && exercise.audioUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('🔊 ${exercise.audioUrl!}', style: Theme.of(context).textTheme.bodySmall),
          ),
        const SizedBox(height: 16),
        _buildInput(exercise),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => _submit(exercise),
          child: const Text('Check'),
        ),
      ],
    );
  }

  Widget _buildInput(Exercise exercise) {
    if (exercise.type == ExerciseType.buildSentence) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: exercise.tokens
                .map(
                  (token) => ChoiceChip(
                    label: Text(ltrIsolate(token), textDirection: TextDirection.ltr),
                    selected: _selectedTokens.contains(token),
                    onSelected: (_) {
                      setState(() {
                        if (_selectedTokens.contains(token)) {
                          _selectedTokens.remove(token);
                        } else {
                          _selectedTokens.add(token);
                        }
                      });
                    },
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 10),
          Text(
            ltrIsolate(_selectedTokens.join(' ')),
            textDirection: TextDirection.ltr,
          ),
        ],
      );
    }

    return TextField(
      controller: _controller,
      textDirection: TextDirection.ltr,
      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Type answer in English'),
    );
  }

  void _submit(Exercise exercise) {
    final correct = switch (exercise.type) {
      ExerciseType.buildSentence => _selectedTokens.join(' ') == exercise.correctOrder.join(' '),
      _ => exercise.acceptedAnswers.any((answer) => _normalize(answer) == _normalize(_controller.text)),
    };

    widget.onResult(
      correct,
      correct ? exercise.xp : 0,
      correct ? 0 : exercise.heartsPenalty,
    );
  }

  String _normalize(String value) => value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}
