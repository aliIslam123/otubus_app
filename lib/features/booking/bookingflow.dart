import 'package:flutter/material.dart';
import 'package:otubus_app/core/theme/app_theme.dart';
import 'package:otubus_app/features/booking/screens/search_results_screen.dart';

void main() {
  runApp(const OtuBusApp());
}

class OtuBusApp extends StatelessWidget {
  const OtuBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTUBUS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Listens to device settings by default
      home: const SearchResultsScreen(),
    );
  }
}
