import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const FashionStoreMobileApp());
}

class FashionStoreMobileApp extends StatelessWidget {
  const FashionStoreMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryViolet = Color(0xFF8B5CF6);
    const secondaryBlue = Color(0xFF38BDF8);
    const lightBg = Color(0xFFF8FAFC);
    const cardSurface = Colors.white;

    return MaterialApp(
      title: 'FashionStore Mobile - Vestidor AR 3D & IA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: lightBg,
        primaryColor: primaryViolet,
        colorScheme: const ColorScheme.light(
          primary: primaryViolet,
          secondary: secondaryBlue,
          surface: cardSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: false,
          iconTheme: IconThemeData(color: Color(0xFF1E293B)),
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        cardTheme: CardThemeData(
          color: cardSurface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryViolet,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryViolet, width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF64748B)),
          prefixIconColor: primaryViolet,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          displayMedium: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          displaySmall: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          headlineLarge: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          headlineMedium: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          headlineSmall: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          titleLarge: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          titleMedium: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          titleSmall: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          bodyLarge: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          bodyMedium: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          bodySmall: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          labelLarge: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          labelMedium: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
          labelSmall: TextStyle(fontFamilyFallback: ['Segoe UI', 'Roboto', 'Arial', 'sans-serif']),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
