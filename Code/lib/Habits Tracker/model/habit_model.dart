class Habit {
  final String title;
  final double progress;
  final double target;
  final bool isCompleted;

  Habit({
    required this.title,
    required this.progress,
    required this.target,
    required this.isCompleted,
  });

  Habit copyWith({
    double? progress,
    bool? isCompleted,
  }) {
    return Habit(
      title: title,
      progress: progress ?? this.progress,
      target: target,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
