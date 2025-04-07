import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/provider/orb_state.dart';
import 'package:myapp/utils/constants.dart' as constants;


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


class OrbPainter extends CustomPainter {
  final double elapsedTime;
  final List<OrbState> orbStates;
  final void Function(int orbIndex, double newStartTime) onTrigger;
  final double alignmentDuration;

  const OrbPainter({
    required this.elapsedTime,
    required this.orbStates,
    required this.onTrigger,
    required this.alignmentDuration,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final Paint basePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double orbRadius = 5.0;
    final double maxRadius = size.shortestSide / 2 * 0.9;
    final double deltaRadius = (constants.numberOfOrbs > 1) ? (maxRadius - constants.initialOffset) / (constants.numberOfOrbs - 1) : 0;

    for (int i = 0; i < constants.numberOfOrbs; i++) {
      final double radius = constants.initialOffset + i * deltaRadius;
      final double angularSpeed = constants.baseAngularSpeed / pow(constants.goldenRatio, i / constants.numberOfOrbs.toDouble());
      final OrbState orbState = orbStates[i];
      final double deltaTime = elapsedTime - orbState.startTime;
      double angle = (pi / 2) + orbState.direction * (deltaTime * angularSpeed / alignmentDuration * 2 * pi);

      if (deltaTime * angularSpeed >= 2 * pi) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onTrigger(i, elapsedTime);
        });
      }

      final Offset position = center + Offset(radius * cos(angle), radius * sin(angle));
      canvas.drawCircle(position, orbRadius, basePaint);

      if (deltaTime < constants.activationDuration) {
        final double fade = 0.3 - (deltaTime / constants.activationDuration);
        final Color activeColor = constants.activeColors[i % constants.activeColors.length].withOpacity(fade);
        final Paint activePaint = Paint()
          ..color = activeColor
          ..style = PaintingStyle.fill;
        canvas.drawCircle(position, orbRadius, activePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant OrbPainter oldDelegate) =>
      oldDelegate.elapsedTime != elapsedTime || oldDelegate.orbStates != orbStates;
}