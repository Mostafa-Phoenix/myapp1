import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class OrbAudioPlayerManager {
  final List<AudioPlayer> _audioPlayers;

  OrbAudioPlayerManager._(this._audioPlayers);

  static Future<OrbAudioPlayerManager> create(int numberOfOrbs) async {
    final players = <AudioPlayer>[];

    for (int i = 0; i < numberOfOrbs; i++) {
      try {
        final player = AudioPlayer();
        
        // Configure for low latency
        await player.setPlayerMode(PlayerMode.lowLatency);
        await player.setReleaseMode(ReleaseMode.stop); // Stop when finished

        // Preload audio as bytes for fastest access
        final byteData = await rootBundle.load('audio/$i.wav');
        final bytes = byteData.buffer.asUint8List();
        await player.setSource(BytesSource(bytes));

        players.add(player);
      } catch (e, stack) {
        debugPrint('Error initializing orb $i: $e\n$stack');
      }
    }

    return OrbAudioPlayerManager._(players);
  }

  Future<void> playOrbSound(int orbIndex) async {
    if (orbIndex < 0 || orbIndex >= _audioPlayers.length) return;

    final player = _audioPlayers[orbIndex];
    try {
      // Immediately restart playback without stopping first
      await player.resume(); // Or player.play() depending on behavior
    } catch (e, stack) {
      debugPrint('Error playing orb $orbIndex: $e\n$stack');
    }
  }

  Future<void> dispose() async {
    for (final player in _audioPlayers) {
      await player.dispose();
    }
  }
}