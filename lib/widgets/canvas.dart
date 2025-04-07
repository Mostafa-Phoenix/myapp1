import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/provider/orb_state.dart';
import 'package:myapp/provider/ticker.dart';
import 'package:myapp/widgets/orb_painter.dart';

/// A canvas widget that renders the orb simulation.
class CanvasWidget extends ConsumerWidget {
  const CanvasWidget({super.key});
  static const _canvasSizeFactor = 0.8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Convert ticker value from milliseconds to seconds.
    final elapsedTime = ref.watch(tickerProvider).value / 1000.0;
    final orbStates = ref.watch(orbStatesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Orb Simulation")),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canvasSize = min(constraints.maxWidth, constraints.maxHeight) * _canvasSizeFactor;
            return SizedBox.square(
              dimension: canvasSize,
              child: CustomPaint(
                painter: OrbPainter(
                  elapsedTime: elapsedTime,
                  orbStates: orbStates,
                  onTrigger: (orbIndex, newStartTime) {
                    // Update the orb state when a revolution is complete.
                    ref.read(orbStatesProvider.notifier).trigger(orbIndex, newStartTime);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}