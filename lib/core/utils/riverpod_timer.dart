import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerNotifier extends StateNotifier<int> {
  final int initialSeconds;
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;

  TimerNotifier(this.initialSeconds) : super(initialSeconds);

  void startTimer() {
    resetTimer();
    _isRunning = true;
    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--;
      } else {
        stopTimer();
      }
    });
  }

  void pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      _isPaused = true;
    }
  }

  void resumeTimer() {
    if (_isPaused) {
      _isPaused = false;
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state > 0) {
          state--;
        } else {
          stopTimer();
        }
      });
    }
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    state = initialSeconds;
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
  }

  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  String get formattedTime {
    final minutes = state ~/ 60;
    final seconds = state % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class WhoAmITimerNotifier extends TimerNotifier {
  WhoAmITimerNotifier() : super(60);
}

class RiskTimerNotifier extends TimerNotifier {
  RiskTimerNotifier() : super(120);
}

final whoAmITimerProvider =
StateNotifierProvider<WhoAmITimerNotifier, int>((ref) => WhoAmITimerNotifier());

final riskTimerProvider =
StateNotifierProvider<RiskTimerNotifier, int>((ref) => RiskTimerNotifier());
