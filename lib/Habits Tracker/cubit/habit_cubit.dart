import 'package:flutter_bloc/flutter_bloc.dart';
import 'habit_state.dart';
import '../model/habit_model.dart';

/// Cubit responsible for managing habits /
/// Handles toggling completion and updating progress

class HabitCubit extends Cubit<HabitState> {
  /// Starts with a default state containing initial habits
 
  HabitCubit() : super(HabitState(_initialHabits()));

  /// Default habits shown when the app first opens
  static List<Habit> _initialHabits() {
    return [
      Habit(
        title: "Drink Water",
        subtitle: "1.5L of 2.5L completed",
        progress: 1.5,
        target: 2.5,
        isCompleted: false,
        icon: '💧',
        iconBgColor: 0xFF1A3A6B,
      ),
      Habit(
        title: "Mindfulness Meditation",
        subtitle: "10 mins target",
        progress: 5,
        target: 10,
        isCompleted: false,
        icon: '🧘',
        iconBgColor: 0xFF3A1A6B,
      ),
      Habit(
        title: "Read 20 Pages",
        subtitle: "Goal Achieved!",
        progress: 20,
        target: 20,
        isCompleted: true,
        icon: '📖',
        iconBgColor: 0xFF1A5C3A,
      ),
    ];
  }

  /// Toggles the completion status of a habit (done ↔ not done)

  void toggleHabit(int index) {
    final updated = List<Habit>.from(state.habits);
    final habit = updated[index];

    updated[index] = habit.copyWith(isCompleted: !habit.isCompleted);
    emit(HabitState(updated));
  }

  /// Updates progress for a specific habit
  /// If progress reaches the target, it's automatically marked as completed
  void updateProgress(int index, double value) {
    final updated = List<Habit>.from(state.habits);
    final habit = updated[index];

    updated[index] = habit.copyWith(
      progress: value,
      isCompleted: value >= habit.target,
    );

    emit(HabitState(updated));
  }
}
