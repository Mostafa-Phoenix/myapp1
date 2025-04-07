import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screen/home.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticker Demo',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData.from(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        // other color properties...
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData.from(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: Colors.blue,
        // other color properties...
      ),
    );
  }
}