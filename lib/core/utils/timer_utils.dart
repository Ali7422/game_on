import 'dart:async';
import 'package:flutter/material.dart';

class GameTimer extends ChangeNotifier {
  Timer? _timer;
  int _seconds = 0;
  int _initialSeconds = 120;
  bool _isRunning = false;
  bool _isPaused = false;

  int get seconds => _seconds;
  int get initialSeconds => _initialSeconds;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  bool get isFinished => _seconds <= 0;

  String get formattedTime {
    final minutes = _seconds ~/ 60;
    final remainingSeconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double get progress => _seconds / _initialSeconds;

  void setInitialSeconds(int seconds) {
    _initialSeconds = seconds;
    _seconds = seconds;
    notifyListeners();
  }

  void start() {
    if (_isPaused) {
      _isPaused = false;
    } else {
      _seconds = _initialSeconds;
    }
    
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
        notifyListeners();
      } else {
        _onTimerFinished();
      }
    });
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = true;
    notifyListeners();
  }

  void resume() {
    if (_isPaused && _seconds > 0) {
      start();
    }
  }

  void reset() {
    _timer?.cancel();
    _seconds = _initialSeconds;
    _isRunning = false;
    _isPaused = false;
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    notifyListeners();
  }

  void _onTimerFinished() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class TimerWidget extends StatelessWidget {
  final GameTimer timer;
  final Color? color;
  final double? fontSize;
  final bool showProgress;
  final VoidCallback? onTimerFinished;

  const TimerWidget({
    super.key,
    required this.timer,
    this.color,
    this.fontSize,
    this.showProgress = true,
    this.onTimerFinished,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: timer,
      builder: (context, child) {
        if (timer.isFinished && onTimerFinished != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onTimerFinished!();
          });
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timer.formattedTime,
              style: TextStyle(
                fontSize: fontSize ?? 48,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.white,
              ),
            ),
            if (showProgress) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: timer.progress,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? Colors.green,
                  ),
                  minHeight: 4,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class TimerControls extends StatelessWidget {
  final GameTimer timer;
  final Color? playButtonColor;
  final Color? pauseButtonColor;
  final Color? resetButtonColor;
  final double? buttonSize;

  const TimerControls({
    super.key,
    required this.timer,
    this.playButtonColor,
    this.pauseButtonColor,
    this.resetButtonColor,
    this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: timer,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: timer.isRunning ? Icons.pause : Icons.play_arrow,
              color: timer.isRunning ? pauseButtonColor : playButtonColor,
              onPressed: timer.isRunning ? timer.pause : timer.start,
            ),
            _buildControlButton(
              icon: Icons.refresh,
              color: resetButtonColor,
              onPressed: timer.reset,
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color? color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonSize ?? 50,
        height: buttonSize ?? 50,
        decoration: BoxDecoration(
          color: color ?? Colors.blue,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: (color ?? Colors.blue).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: (buttonSize ?? 50) * 0.5,
        ),
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback? onFinished;
  final Color? color;
  final double? fontSize;
  final bool autoStart;

  const CountdownTimer({
    super.key,
    this.initialSeconds = 120,
    this.onFinished,
    this.color,
    this.fontSize,
    this.autoStart = false,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late GameTimer _timer;

  @override
  void initState() {
    super.initState();
    _timer = GameTimer();
    _timer.setInitialSeconds(widget.initialSeconds);
    
    if (widget.autoStart) {
      _timer.start();
    }
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimerWidget(
      timer: _timer,
      color: widget.color,
      fontSize: widget.fontSize,
      onTimerFinished: widget.onFinished,
    );
  }
}
