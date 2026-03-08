import '../model/habit_model.dart';

/// State class for HabitCubit /
/// Contains all data the UI needs / 
class HabitState {
  /// List of daily habits / 
  final List<Habit> habits;

  HabitState(this.habits);

  /// Success rate = completed habits / total habits × 100
  double get successRate {
    if (habits.isEmpty) return 0;
    int completed = habits.where((h) => h.isCompleted).length;
    return (completed / habits.length) * 100;
  }

  /// Streak = number of completed habits today
  
  /// (In a real app this would be calculated from consecutive days)
 
  int get streak {
    return habits.where((h) => h.isCompleted).length;
  }
}
