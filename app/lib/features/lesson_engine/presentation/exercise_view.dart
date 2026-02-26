import 'package:flutter/material.dart';

import '../../../core/i18n/bidi_text.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/lesson_models.dart';
import 'widgets/neo_action_button.dart';

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
  final Map<String, String> _matches = {};
  final Set<String> _lockedRightTokens = {};
  String? _selectedOption;
  String? _activeLeftToken;
  bool _submitted = false;
  bool? _isCorrect;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExerciseView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _controller.clear();
      _selectedTokens.clear();
      _matches.clear();
      _lockedRightTokens.clear();
      _selectedOption = null;
      _activeLeftToken = null;
      _submitted = false;
      _isCorrect = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFC084FC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              'NEW WORD',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFFC084FC),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          exercise.promptHe,
          textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        _buildPromptCard(exercise),
        const SizedBox(height: 12),
        _buildInput(exercise),
        if (exercise.hints.isNotEmpty) ...[
          const SizedBox(height: 14),
          _buildHints(exercise),
        ],
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _submitted
              ? _ResultPanel(
                  isCorrect: _isCorrect ?? false,
                  key: ValueKey(_isCorrect),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        NeoActionButton(
          label: _submitted ? 'Continue' : 'Check',
          icon: _submitted ? Icons.arrow_forward_rounded : Icons.check_rounded,
          enabled: _canSubmit(exercise) || _submitted,
          onPressed: () => _submit(exercise),
        ),
      ],
    );
  }

  Widget _buildPromptCard(Exercise exercise) {
    if (exercise.sourceTextHe == null && exercise.audioUrl == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('🧑‍🏫', style: TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (exercise.sourceTextHe != null)
                  Text(
                    exercise.sourceTextHe!,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: AppColors.neutral900,
                    ),
                  ),
                if (exercise.type == ExerciseType.completeChat && exercise.chatPrompt != null)
                  Text(
                    exercise.chatPrompt!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.neutral700,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                if (exercise.type == ExerciseType.listenToText && exercise.audioUrl != null)
                  Text(
                    'Tap to hear',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.info,
                    ),
                  ),
              ],
            ),
          ),
          if (exercise.type == ExerciseType.listenToText)
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.info,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.volume_up_rounded, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildInput(Exercise exercise) {
    return switch (exercise.type) {
      ExerciseType.buildSentence => _buildSentenceInput(exercise),
      ExerciseType.completeChat => _buildChatInput(exercise),
      ExerciseType.matchPairs => _buildPairsInput(exercise),
      _ => _buildTextInput(),
    };
  }

  Widget _buildSentenceInput(Exercise exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.neutral0,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTokens.isEmpty
                ? [
                    Text(
                      'Tap words to build the sentence',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
                    ),
                  ]
                : _selectedTokens
                    .map(
                      (token) => InputChip(
                        label: Text(ltrIsolate(token), textDirection: TextDirection.ltr),
                        onDeleted: () {
                          setState(() {
                            _selectedTokens.remove(token);
                          });
                        },
                        backgroundColor: AppColors.neutral100,
                      ),
                    )
                    .toList(growable: false),
          ),
        ),
        const SizedBox(height: 12),
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
      ],
    );
  }

  Widget _buildChatInput(Exercise exercise) {
    final options = exercise.options.isNotEmpty ? exercise.options : exercise.acceptedAnswers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (exercise.chatReply != null)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.neutral0,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Text(
                exercise.chatReply!,
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                setState(() {
                  _selectedOption = option;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedOption == option
                      ? AppColors.learningPrimary.withValues(alpha: 0.18)
                      : AppColors.neutral0,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _selectedOption == option ? AppColors.learningPrimary : AppColors.neutral200,
                    width: _selectedOption == option ? 1.6 : 1.2,
                  ),
                ),
                child: Text(
                  option,
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPairsInput(Exercise exercise) {
    final allTokens = <String>{...exercise.leftItems, ...exercise.rightItems};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tap the matching pairs',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: allTokens
              .map(
                (token) => _PairTile(
                  token: token,
                  isSelected: _activeLeftToken == token,
                  isMatched: _matches.containsKey(token) || _lockedRightTokens.contains(token),
                  onTap: () => _onPairTileTapped(exercise, token),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }

  Widget _buildTextInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (_) => setState(() {}),
        textDirection: TextDirection.ltr,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Type answer in English',
          prefixIcon: Icon(Icons.edit_rounded),
        ),
      ),
    );
  }

  void _onPairTileTapped(Exercise exercise, String token) {
    final isLeftToken = exercise.leftItems.contains(token);
    final isRightToken = exercise.rightItems.contains(token);
    if (!isLeftToken && !isRightToken) return;

    setState(() {
      if (isLeftToken) {
        if (_matches.containsKey(token)) {
          final previousRight = _matches.remove(token);
          if (previousRight != null) {
            _lockedRightTokens.remove(previousRight);
          }
        }
        _activeLeftToken = token;
      } else if (isRightToken && _activeLeftToken != null) {
        if (_lockedRightTokens.contains(token)) return;

        final currentLeft = _activeLeftToken!;
        final previousRight = _matches[currentLeft];
        if (previousRight != null) {
          _lockedRightTokens.remove(previousRight);
        }

        _matches[currentLeft] = token;
        _lockedRightTokens.add(token);
        _activeLeftToken = null;
      }
    });
  }

  Widget _buildHints(Exercise exercise) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: exercise.hints
          .map(
            (hint) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.neutral0,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Text(hint, style: Theme.of(context).textTheme.bodySmall),
            ),
          )
          .toList(growable: false),
    );
  }

  Future<void> _submit(Exercise exercise) async {
    if (_submitted) {
      widget.onResult(
        _isCorrect ?? false,
        (_isCorrect ?? false) ? exercise.xp : 0,
        (_isCorrect ?? false) ? 0 : exercise.heartsPenalty,
      );
      return;
    }

    final correct = switch (exercise.type) {
      ExerciseType.buildSentence => _selectedTokens.join(' ') == exercise.correctOrder.join(' '),
      ExerciseType.completeChat => _normalize(_selectedOption ?? '') == _normalize(exercise.correctOption ?? ''),
      ExerciseType.matchPairs => _pairsAreCorrect(exercise),
      _ => exercise.acceptedAnswers.any((answer) => _normalize(answer) == _normalize(_controller.text)),
    };

    if (!correct && exercise.heartsPenalty > 0 && mounted) {
      await _showHeartWarningDialog(exercise.heartsPenalty);
    }

    if (!mounted) return;
    setState(() {
      _submitted = true;
      _isCorrect = correct;
    });
  }

  bool _canSubmit(Exercise exercise) {
    return switch (exercise.type) {
      ExerciseType.buildSentence => _selectedTokens.isNotEmpty,
      ExerciseType.completeChat => (_selectedOption ?? '').trim().isNotEmpty,
      ExerciseType.matchPairs => _matches.length == exercise.leftItems.length && exercise.leftItems.isNotEmpty,
      _ => _controller.text.trim().isNotEmpty,
    };
  }

  bool _pairsAreCorrect(Exercise exercise) {
    if (_matches.length != exercise.leftItems.length || exercise.leftItems.isEmpty) {
      return false;
    }

    for (final left in exercise.leftItems) {
      final expected = exercise.pairs[left];
      final actual = _matches[left];
      if (_normalize(expected ?? '') != _normalize(actual ?? '')) {
        return false;
      }
    }

    return true;
  }

  Future<void> _showHeartWarningDialog(int heartsPenalty) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('❤️ ❤️ ❤️ ❤️ ❤️', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 14),
                Text(
                  'Each mistake costs $heartsPenalty heart${heartsPenalty > 1 ? 's' : ''}!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  'Stay sharp and focused to keep your hearts.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.info,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: const Text('KEEP GOING'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _normalize(String value) => value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}

class _PairTile extends StatelessWidget {
  const _PairTile({
    required this.token,
    required this.isSelected,
    required this.isMatched,
    required this.onTap,
  });

  final String token;
  final bool isSelected;
  final bool isMatched;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tileColor = isMatched
        ? AppColors.learningPrimary.withValues(alpha: 0.18)
        : isSelected
            ? AppColors.info.withValues(alpha: 0.14)
            : AppColors.neutral0;

    final borderColor = isMatched
        ? AppColors.learningPrimary
        : isSelected
            ? AppColors.info
            : AppColors.neutral200;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 132,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.4),
        ),
        child: Center(
          child: Text(
            token,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.isCorrect,
    super.key,
  });

  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isCorrect ? AppColors.correctSurface : AppColors.wrongSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCorrect ? AppColors.success : AppColors.error,
          width: 1.6,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isCorrect ? AppColors.success : AppColors.error,
            size: 26,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isCorrect ? 'Correct! מעולה' : 'טעות קטנה עולה לב. ממשיכים חזק! ',
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
