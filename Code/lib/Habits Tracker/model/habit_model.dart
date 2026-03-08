/// Model representing a single habit / 
class Habit {
  /// Habit name / (مثلاً: "Drink Water")
  final String title;

  /// Extra description or details / تفاصيل
  final String subtitle;

  /// Current progress / 
  final double progress;

  /// Target to reach / 
  final double target;

  /// Whether the habit is fully completed / 
  final bool isCompleted;

  /// Habit emoji icon / 
  final String icon;

  /// Icon background color / 
  final int iconBgColor;

  Habit({
    required this.title,
    this.subtitle = '',
    required this.progress,
    required this.target,
    required this.isCompleted,
    this.icon = '📌',
    this.iconBgColor = 0xFF1A5C3A,
  });

  /// Returns a new Habit with updated fields / 
  Habit copyWith({
    double? progress,
    bool? isCompleted,
    String? subtitle,
  }) {
    return Habit(
      title: title,
      subtitle: subtitle ?? this.subtitle,
      progress: progress ?? this.progress,
      target: target,
      isCompleted: isCompleted ?? this.isCompleted,
      icon: icon,
      iconBgColor: iconBgColor,
    );
  }
}
