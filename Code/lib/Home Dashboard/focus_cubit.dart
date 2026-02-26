import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'focus_state.dart';

class FocusCubit extends Cubit<FocusState> {
  Timer? _timer;

  FocusCubit({int initialSeconds = 1500})
      : super(FocusState(seconds: initialSeconds, isRunning: false));

  void start() {
    if (state.isRunning) return;
    emit(state.copyWith(isRunning: true));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // default behavior: count down until zero
      if (state.seconds > 0) {
        emit(state.copyWith(seconds: state.seconds - 1));
      } else {
        pause();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    emit(state.copyWith(isRunning: false));
  }

  void reset([int? seconds]) {
    _timer?.cancel();
    _timer = null;
    emit(FocusState(seconds: seconds ?? 1500, isRunning: false));
  }

  void increment([int by = 60]) {
    emit(state.copyWith(seconds: state.seconds + by));
  }

  void decrement([int by = 60]) {
    final s = (state.seconds - by) < 0 ? 0 : state.seconds - by;
    emit(state.copyWith(seconds: s));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
