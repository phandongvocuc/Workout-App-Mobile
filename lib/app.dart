import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/strings.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';

class HydroFitApp extends StatelessWidget {
  const HydroFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    Widget home;
    if (!authProvider.isAuthenticated) {
      home = const LoginScreen();
    } else if (authProvider.isAdmin) {
      home = const AdminDashboardScreen();
    } else {
      home = const HomeScreen();
    }

    return MaterialApp(
      title: AppStrings.businessName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: home,
    );
  }
}
