import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// -------------------- Ticker --------------------

class TickerState {
  final double value; // milliseconds
  final bool isRunning;

  const TickerState({required this.value, required this.isRunning});

  TickerState copyWith({double? value, bool? isRunning}) {
    return TickerState(
      value: value ?? this.value,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class TickerController extends StateNotifier<TickerState> {
  TickerController() : super(const TickerState(value: 0, isRunning: false));
  Timer? _timer;

  void start() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true);
    // Increase by 1 millisecond per tick.
    _timer = Timer.periodic(const Duration(milliseconds: 32), (_) {
      state = state.copyWith(value: state.value + 1);
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    pause();
    state = state.copyWith(value: 0);
  }
}

final tickerProvider = StateNotifierProvider<TickerController, TickerState>(
  (ref) => TickerController(),
);
