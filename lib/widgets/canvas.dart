import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/provider/orb_state.dart';
import 'package:myapp/provider/ticker.dart';
import 'package:myapp/widgets/orb_painter.dart';
import 'package:myapp/utils/constants.dart' as constants;

class CanvasWidget extends ConsumerWidget {
  const CanvasWidget({super.key});
  static const _canvasSizeFactor = 0.8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Convert ticker value from milliseconds to seconds.
    final elapsedTime = ref.watch(tickerProvider).value / 1000.0;
    final orbStates = ref.watch(orbStatesProvider);

    // Calculate alignment duration
    final alignmentDuration = calculateAlignmentDuration(
      constants.numberOfOrbs,
      constants.baseAngularSpeed,
      constants.goldenRatio,
    );

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
                  onTrigger: (int orbIndex, double newStartTime) {
                    // Update the orb state when a revolution is complete.
                    ref.read(orbStatesProvider.notifier).trigger(orbIndex, newStartTime);
                  },
                  alignmentDuration: alignmentDuration, // Pass alignmentDuration here
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

double calculateAlignmentDuration(int numberOfOrbs, double baseAngularSpeed, double goldenRatio) {
  List<double> periods = [];
  
  for (int i = 0; i < numberOfOrbs; i++) {
    double angularSpeed = baseAngularSpeed / pow(goldenRatio, i / numberOfOrbs.toDouble());
    double period = 2 * pi / angularSpeed;
    periods.add(period);
  }

  double lcmPeriods = periods.reduce((a, b) => lcm(a, b));
  return lcmPeriods;
}

double gcd(double a, double b) {
  while (b != 0) {
    double t = b;
    b = a % b;
    a = t;
  }
  return a;
}

double lcm(double a, double b) {
  return (a * b) / gcd(a, b);
}