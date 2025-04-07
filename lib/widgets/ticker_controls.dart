import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/provider/ticker.dart';
import 'package:myapp/provider/orb_state.dart';

class TickerControls extends ConsumerWidget {
  const TickerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickerState = ref.watch(tickerProvider);
    final controller = ref.read(tickerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlButton(
          icon: Icons.play_arrow,
          message: 'Start',
          onPressed: tickerState.isRunning ? null : controller.start,
        ),
        ControlButton(
          icon: Icons.pause,
          message: 'Pause',
          onPressed: tickerState.isRunning ? controller.pause : null,
        ),
        ControlButton(
          icon: Icons.refresh,
          message: 'Reset',
          onPressed: tickerState.value != 0
              ? () {
                  controller.reset();
                  ref.read(orbStatesProvider.notifier).resetAll();
                }
              : null,
        ),
      ],
    );
  }
}

class ControlButton extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onPressed;

  const ControlButton({
    Key? key,
    required this.icon,
    required this.message,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: message,
        child: IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          visualDensity: VisualDensity.compact,
          color: onPressed != null ? null : Colors.grey,
        ),
      ),
    );
  }
}