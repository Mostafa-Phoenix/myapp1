import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  TickerController(this._createTicker) 
      : _ticker = _createTicker(),
        super(const TickerState(value: 0, isRunning: false));

  final Ticker Function() _createTicker;
  final Ticker _ticker;

  void start() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    state = state.copyWith(value: elapsed.inMilliseconds.toDouble());
  }

  void pause() {
    _ticker.stop();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    pause();
    state = state.copyWith(value: 0);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

final tickerProvider = StateNotifierProvider<TickerController, TickerState>(
  (ref) {
    return TickerController(() => Ticker(ref.read(tickerProvider.notifier)._onTick));
  },
);