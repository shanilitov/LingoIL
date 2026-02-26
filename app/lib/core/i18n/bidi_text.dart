String ltrIsolate(String text) => '\u2066$text\u2069';

String rtlIsolate(String text) => '\u2067$text\u2069';

String mixedHebrewEnglish({
  required String hebrewPrefix,
  required String englishTarget,
}) {
  return '${rtlIsolate(hebrewPrefix)} ${ltrIsolate(englishTarget)}';
}
