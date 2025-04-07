import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/audio/orb_audio_player.dart'; // <--- Update with correct path

/// Represents an orb’s current state.
class OrbState {
  final int orbIndex;
  final int direction; // 1 for clockwise, -1 for anticlockwise
  final double startTime; // Time (in seconds) when the current revolution started

  const OrbState({
    required this.orbIndex,
    this.direction = 1,
    this.startTime = 0,
  });

  OrbState copyWith({int? direction, double? startTime}) {
    return OrbState(
      orbIndex: orbIndex,
      direction: direction ?? this.direction,
      startTime: startTime ?? this.startTime,
    );
  }
}

const int numberOfOrbs = 21;

class OrbStatesNotifier extends StateNotifier<List<OrbState>> {
  late final Future<OrbAudioPlayerManager> _audioManagerFuture;
  OrbAudioPlayerManager? _audioManager;

  OrbStatesNotifier()
      : super(List.generate(numberOfOrbs, (index) => OrbState(orbIndex: index))) {
    _initializeAudioManager();
  }

  void _initializeAudioManager() {
    _audioManagerFuture = OrbAudioPlayerManager.create(numberOfOrbs)
      ..then((manager) => _audioManager = manager);
  }

  Future<void> trigger(int orbIndex, double currentTime) async {
    state = [
      for (final orb in state)
        if (orb.orbIndex == orbIndex)
          orb.copyWith(direction: -orb.direction, startTime: currentTime)
        else
          orb,
    ];

    try {
      final manager = await _audioManagerFuture;
      await manager.playOrbSound(orbIndex);
    } catch (e, stack) {
      debugPrint('Error triggering orb $orbIndex: $e\n$stack');
    }
  }

  @override
  void dispose() {
    _audioManager?.dispose();
    super.dispose();
  }

  void resetAll() {
    state = List.generate(numberOfOrbs, (index) => OrbState(orbIndex: index));
    debugPrint('OrbStatesNotifier: All orb states have been reset.');
  }
}

final orbStatesProvider =
    StateNotifierProvider<OrbStatesNotifier, List<OrbState>>(
  (ref) => OrbStatesNotifier(),
);