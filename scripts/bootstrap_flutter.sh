#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK is not installed or not on PATH."
  exit 1
fi

mkdir -p app

if [ ! -f "app/pubspec.yaml" ]; then
  (
    cd app
    flutter create . --platforms=android,ios --project-name lingoil --overwrite
  )
fi

cd app

python3 - <<'PY'
from pathlib import Path

pubspec = Path('pubspec.yaml')
text = pubspec.read_text(encoding='utf-8')

if 'assets/lessons/' not in text:
    lines = text.splitlines()
    result = []
    inserted = False
    i = 0
    while i < len(lines):
        line = lines[i]
        result.append(line)
        if line.strip() == 'flutter:':
            j = i + 1
            while j < len(lines) and (lines[j].startswith('  ') or lines[j].strip() == ''):
                j += 1

            flutter_block = lines[i + 1:j]
            has_assets_key = any(l.strip() == 'assets:' for l in flutter_block)

            if has_assets_key:
                k = i + 1
                while k < j:
                    if lines[k].strip() == 'assets:':
                        result.extend(lines[i + 1:k + 1])
                        result.append('    - assets/lessons/')
                        result.extend(lines[k + 1:j])
                        inserted = True
                        break
                    k += 1
            else:
                result.extend(lines[i + 1:j])
                result.append('  assets:')
                result.append('    - assets/lessons/')
                inserted = True

            i = j - 1

        i += 1

    if inserted:
        pubspec.write_text('\n'.join(result) + '\n', encoding='utf-8')

main_dart = Path('lib/main.dart')
main_dart.write_text(
    """import 'package:flutter/material.dart';

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
""",
    encoding='utf-8',
)
PY

flutter pub add flutter_riverpod go_router intl
flutter pub add drift sqlite3_flutter_libs
flutter pub add sqflite path path_provider
flutter pub add freezed_annotation json_annotation
flutter pub add --dev build_runner freezed json_serializable drift_dev

echo "Flutter shell and core dependencies are ready."
