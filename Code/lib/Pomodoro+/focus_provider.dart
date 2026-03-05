import 'dart:async';
import 'package:flutter/material.dart';
import '../models/session_record.dart';

enum TimerState { idle, running, paused, finished }

enum SessionFilter { today, week, all }

class FocusProvider extends ChangeNotifier {

  TimerState _timerState = TimerState.idle;
  TimerState get timerState => _timerState;

  int _focusDuration = 25 * 60; 
  int get focusDuration => _focusDuration;

  int _remaining = 25 * 60;
  int get remaining => _remaining;

  double get progress => 1 - (_remaining / _focusDuration);

  String get timeDisplay {
    final minutes = _remaining ~/ 60;
    final seconds = _remaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get timerStatusLabel {
    switch (_timerState) {
      case TimerState.running:  return 'focusing';
      case TimerState.paused:   return 'paused';
      case TimerState.finished: return 'done! 🎉';
      case TimerState.idle:     return 'ready';
    }
  }

  int _pomodoroCount = 0;
  int get pomodoroCount => _pomodoroCount;

  String _currentTask = 'UI Design Principles';
  String get currentTask => _currentTask;

  Timer? _countdownTimer;

  void startTimer() {
    if (_timerState != TimerState.idle && _timerState != TimerState.paused) return;

    _timerState = TimerState.running;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), _onTick);
    notifyListeners();
  }

  void pauseTimer() {
    if (_timerState != TimerState.running) return;

    _timerState = TimerState.paused;
    _countdownTimer?.cancel();
    notifyListeners();
  }

  void resetTimer() {
    _countdownTimer?.cancel();
    _timerState = TimerState.idle;
    _remaining = _focusDuration;
    notifyListeners();
  }

  void _onTick(Timer t) {
    if (_remaining > 0) {
      _remaining--;
      notifyListeners();
    } else {
      _countdownTimer?.cancel();
      _timerState = TimerState.finished;
      _pomodoroCount++;

      _sessions.insert(0, SessionRecord(
        task: _currentTask,
        durationSeconds: _focusDuration,
        completedAt: DateTime.now(),
        completed: true,
      ));

      notifyListeners();
    }
  }

  void changeTask(String newTask) {
    _currentTask = newTask;
    notifyListeners();
  }


  bool _appBlockerEnabled = true;
  bool get appBlockerEnabled => _appBlockerEnabled;

  void toggleAppBlocker() {
    _appBlockerEnabled = !_appBlockerEnabled;
    notifyListeners();
  }

  bool _musicPlaying = false;
  bool get musicPlaying => _musicPlaying;

  int _musicPosition = 134; 
  int get musicPosition => _musicPosition;

  final int musicDuration = 225; 
  final String musicTitle = 'Deep Work Lo-Fi';

  double get musicProgress => _musicPosition / musicDuration;

  String get musicPositionLabel => _formatTime(_musicPosition);
  String get musicDurationLabel  => _formatTime(musicDuration);

  Timer? _musicTimer;

  void toggleMusic() {
    _musicPlaying = !_musicPlaying;

    if (_musicPlaying) {
      _musicTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_musicPosition < musicDuration) {
          _musicPosition++;
        } else {
          _musicPosition = 0; 
        }
        notifyListeners();
      });
    } else {
      _musicTimer?.cancel();
    }

    notifyListeners();
  }

  void skipMusic() {
    _musicPosition = 0;
    notifyListeners();
  }


  final List<SessionRecord> _sessions = [
    SessionRecord(task: 'UI Design Principles', durationSeconds: 25 * 60, completedAt: DateTime.now().subtract(const Duration(hours: 1)),             completed: true),
    SessionRecord(task: 'UI Design Principles', durationSeconds: 25 * 60, completedAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)), completed: true),
    SessionRecord(task: 'Flutter Animations',   durationSeconds: 25 * 60, completedAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 30)), completed: true),
    SessionRecord(task: 'Flutter Animations',   durationSeconds: 12 * 60, completedAt: DateTime.now().subtract(const Duration(hours: 5)),              completed: false),
  ];

  List<SessionRecord> get sessions => List.unmodifiable(_sessions);

  List<SessionRecord> filteredSessions(SessionFilter filter) {
    final now = DateTime.now();
    return _sessions.where((s) {
      switch (filter) {
        case SessionFilter.today:
          return s.completedAt.year  == now.year &&
                 s.completedAt.month == now.month &&
                 s.completedAt.day   == now.day;
        case SessionFilter.week:
          return now.difference(s.completedAt).inDays < 7;
        case SessionFilter.all:
          return true;
      }
    }).toList();
  }


  int get streakDays {
    final now = DateTime.now();
    int streak = 0;
    for (int i = 0; i < 30; i++) {
      final day = DateTime(now.year, now.month, now.day - i);
      final hasSession = _sessions.any(
        (s) => s.completed &&
               s.completedAt.year  == day.year &&
               s.completedAt.month == day.month &&
               s.completedAt.day   == day.day,
      );
      if (hasSession) {
        streak++;
      } else if (i > 0) {
        break; 
      }
    }
    return streak;
  }


  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _musicTimer?.cancel();
    super.dispose();
  }
}
