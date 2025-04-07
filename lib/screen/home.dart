import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/widgets/ticker_controls.dart';
import 'package:myapp/widgets/canvas.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        // Use a Stack to overlay widgets
        children: [
          Center(
            // Your existing Center widget
            child: Center(child: CanvasWidget()),
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Center(child: TickerControls()),
          ),
        ],
      ),
    );
  }
}
