import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/provider/orb_state.dart';
import 'package:myapp/provider/ticker.dart'; // Assuming your ticker provider is defined here

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
            final canvasSize =
                min(constraints.maxWidth, constraints.maxHeight) *
                _canvasSizeFactor;
            return SizedBox.square(
              dimension: canvasSize,
              child: CustomPaint(
                painter: OrbPainter(
                  elapsedTime: elapsedTime,
                  orbStates: orbStates,
                  onTrigger: (orbIndex, newStartTime) {
                    // Update the orb state when a revolution is complete.
                    ref
                        .read(orbStatesProvider.notifier)
                        .trigger(orbIndex, newStartTime);
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

/// The custom painter for drawing orbs and the center crosshair.
class OrbPainter extends CustomPainter {
  final double elapsedTime;
  final List<OrbState> orbStates;
  final void Function(int orbIndex, double newStartTime) onTrigger;

  // Constants for golden ratio/angle and speed.
  static const double goldenRatio = 1.618;
  static const double goldenAngle = 2.399963229728653; // ≈137.5° in radians
  static const double baseAngularSpeed = 50.0;
  // Starting distance from center for the innermost orb.
  static const double initialOffset = 10;

  const OrbPainter({
    required this.elapsedTime,
    required this.orbStates,
    required this.onTrigger,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);


    // Base white hollow paint (stroke only)
    final Paint basePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    // Define a fixed orb radius.
    const double orbRadius = 5.0;

    // Calculate maximum radius and spacing.
    final double maxRadius = size.shortestSide / 2 * 0.9;
    final double deltaRadius =
        (numberOfOrbs > 1)
            ? (maxRadius - initialOffset) / (numberOfOrbs - 1)
            : 0;

    // Duration during which the orb is considered "active" (in seconds).
    const double activationDuration = 2;

    // Define a list of active colors to choose from.
    final List<Color> activeColors = [
      Colors.red, // Classic red
      Colors.redAccent, // Electric red
      Colors.deepOrange, // Intense deep orange
      Colors.orange, // Original orange
      Colors.orangeAccent, // Vibrant orange
      Colors.amber, // Warm amber
      Colors.yellow, // Bright yellow
      Colors.lime, // Zesty lime
      Colors.lightGreen, // Fresh light green
      Colors.green, // Classic green
      Colors.teal, // Cool teal
      Colors.cyan, // Vivid cyan
      Colors.lightBlue, // Gentle light blue
      Colors.blue, // Original blue
      Colors.blueGrey, // Moody blue-grey
      Colors.indigo, // Deep indigo
      Colors.deepPurple, // Profound deep purple
      Colors.purple, // Rich purple
      Colors.pink, // Soft pink
      Colors.brown, // Earthy brown
      Colors.grey, // Neutral grey
    ];

    for (int i = 0; i < numberOfOrbs; i++) {
      // Calculate the radius for this orb.
      final double radius = initialOffset + i * deltaRadius;
      // Compute angular speed scaled by the golden ratio.
      final double angularSpeed =
          baseAngularSpeed / pow(goldenRatio, i / numberOfOrbs);
      // Get the current orb state.
      final OrbState orbState = orbStates[i];
      // Compute time elapsed since this orb last triggered.
      final double deltaTime = elapsedTime - orbState.startTime;
      // All orbs start at an initial angle of π/2 (pointing downward).
      double angle = (pi / 2) + orbState.direction * (deltaTime * angularSpeed);

      // When a full revolution (2π) is completed, schedule a trigger.
      if (deltaTime * angularSpeed >= 2 * pi) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onTrigger(i, elapsedTime);
        });
      }

      // Calculate the orb's position in Cartesian coordinates.
      final Offset position =
          center + Offset(radius * cos(angle), radius * sin(angle));

      // Draw the base orb as a white hollow circle.
      canvas.drawCircle(position, orbRadius, basePaint);

      // If the orb has been triggered recently, draw the fill.
      if (deltaTime < activationDuration) {
        // Compute the fade factor (from 1.0 to 0.0 over the activation period).
        final double fade = 0.3 - (deltaTime / activationDuration);
        // Choose an active color from the list (cycled by orb index) with faded opacity.
        final Color activeColor = activeColors[i % activeColors.length]
            .withOpacity(fade);
        final Paint activePaint =
            Paint()
              ..color = activeColor
              ..style = PaintingStyle.fill;
        canvas.drawCircle(position, orbRadius, activePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant OrbPainter oldDelegate) =>
      oldDelegate.elapsedTime != elapsedTime ||
      oldDelegate.orbStates != orbStates;
}
