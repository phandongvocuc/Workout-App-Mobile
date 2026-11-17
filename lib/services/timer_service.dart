import 'dart:async';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

enum TimerState { idle, running, paused, completed }

class TimerService extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  Timer? _timer;
  TimerState _state = TimerState.idle;
  int _totalSeconds = 30;
  int _remainingSeconds = 30;
  String _exerciseName = '';

  TimerState get state => _state;
  int get totalSeconds => _totalSeconds;
  int get remainingSeconds => _remainingSeconds;
  String get exerciseName => _exerciseName;
  bool get isRunning => _state == TimerState.running;
  bool get isPaused => _state == TimerState.paused;
  bool get isCompleted => _state == TimerState.completed;

  double get progress =>
      _totalSeconds > 0 ? (_totalSeconds - _remainingSeconds) / _totalSeconds : 0.0;

  String get formattedRemaining {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void setup(String exerciseName, int seconds) {
    if (_state == TimerState.running) return;
    _exerciseName = exerciseName;
    _totalSeconds = seconds;
    _remainingSeconds = seconds;
    _state = TimerState.idle;
    notifyListeners();
  }

  void start(String exerciseName, int seconds) {
    _timer?.cancel();
    _exerciseName = exerciseName;
    _totalSeconds = seconds;
    _remainingSeconds = seconds;
    _state = TimerState.running;
    notifyListeners();

    // Schedule fallback notification in case user backgrounds the app
    _notificationService.scheduleTimerFallback(
      exerciseName: _exerciseName,
      duration: Duration(seconds: seconds),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _remainingSeconds = 0;
        _state = TimerState.completed;
        timer.cancel();
        _timer = null;

        // Cancel fallback notification and trigger completion immediately
        _notificationService.cancelTimerFallback();
        _notificationService.showTimerCompleteInstant(_exerciseName);
        notifyListeners();
      }
    });
  }

  void pause() {
    if (_state != TimerState.running) return;
    _timer?.cancel();
    _timer = null;
    _state = TimerState.paused;
    _notificationService.cancelTimerFallback();
    notifyListeners();
  }

  void resume() {
    if (_state != TimerState.paused || _remainingSeconds <= 0) return;
    _state = TimerState.running;
    notifyListeners();

    // Re-schedule fallback for remaining duration
    _notificationService.scheduleTimerFallback(
      exerciseName: _exerciseName,
      duration: Duration(seconds: _remainingSeconds),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _remainingSeconds = 0;
        _state = TimerState.completed;
        timer.cancel();
        _timer = null;

        _notificationService.cancelTimerFallback();
        _notificationService.showTimerCompleteInstant(_exerciseName);
        notifyListeners();
      }
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _notificationService.cancelTimerFallback();
    _remainingSeconds = _totalSeconds;
    _state = TimerState.idle;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    _notificationService.cancelTimerFallback();
    _remainingSeconds = _totalSeconds;
    _state = TimerState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notificationService.cancelTimerFallback();
    super.dispose();
  }
}

