import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/provider/orb_state.dart';
import 'package:myapp/utils/constants.dart' as constants;

class OrbPainter extends CustomPainter {
  final double elapsedTime;
  final List<OrbState> orbStates;
  final void Function(int orbIndex, double newStartTime) onTrigger;

  const OrbPainter({
    required this.elapsedTime,
    required this.orbStates,
    required this.onTrigger,
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
      final double angularSpeed = constants.baseAngularSpeed / pow(constants.goldenRatio, i / constants.numberOfOrbs);
      final OrbState orbState = orbStates[i];
      final double deltaTime = elapsedTime - orbState.startTime;
      double angle = (pi / 2) + orbState.direction * (deltaTime * angularSpeed);

      if (deltaTime * angularSpeed >= 2 * pi) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onTrigger(i, elapsedTime);
        });
      }

      final Offset position = center + Offset(radius * cos(angle), radius * sin(angle));
      canvas.drawCircle(position, orbRadius, basePaint);

      if (deltaTime < constants.activationDuration) {
        final double fade = 0.3 - (deltaTime / constants.activationDuration);
        final Color activeColor = constants.activeColors[i % constants.activeColors.length].withOpacity(fade); // Updated to use withOpacity
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