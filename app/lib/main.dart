import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/dashboard_page.dart';

void main() {
  runApp(const LingoIlApp());
}

class LingoIlApp extends StatelessWidget {
  const LingoIlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const DashboardPage(),
    );
  }
}
