import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/strings.dart';
import 'core/theme.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';

class HydroFitApp extends StatelessWidget {
  const HydroFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const HomeScreen(),
    );
  }
}

