import '../model/habit_model.dart';

class HabitState {
  final List<Habit> habits;

  HabitState(this.habits);

  double get successRate {
    if (habits.isEmpty) return 0;
    int completed = habits.where((h) => h.isCompleted).length;
    return (completed / habits.length) * 100;
  }

  int get streak {
    return habits.where((h) => h.isCompleted).length;
  }
}