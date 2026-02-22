import 'package:flutter_bloc/flutter_bloc.dart';
import 'habit_state.dart';
import '../model/habit_model.dart';

class HabitCubit extends Cubit<HabitState> {
  HabitCubit() : super(HabitState(_initialHabits()));

  static List<Habit> _initialHabits() {
    return [
      Habit(
        title: "Drink Water (1.5L / 2.5L)",
        progress: 1.5,
        target: 2.5,
        isCompleted: false,
      ),
      Habit(
        title: "Mindfulness Meditation (5min / 10min)",
        progress: 5,
        target: 10,
        isCompleted: false,
      ),
      Habit(
        title: "Read 20 Pages",
        progress: 20,
        target: 20,
        isCompleted: true,
      ),
    ];
  }

  void toggleHabit(int index) {
    final updated = List<Habit>.from(state.habits);
    final habit = updated[index];

    updated[index] = habit.copyWith(
      isCompleted: !habit.isCompleted,
    );

    emit(HabitState(updated));
  }

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