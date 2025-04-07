// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screen/home.dart';

void main() {
  runApp(
    // Wrap the entire app in ProviderScope to enable Riverpod.
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticker Demo',
       // Use ThemeData.from to generate a theme from a ColorScheme
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          // other color properties...
        ),
      ),
      darkTheme: ThemeData.from(
        useMaterial3: true,

        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          
          // other color properties...
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
