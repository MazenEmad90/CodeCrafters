class SessionRecord {
  final String task;
  final int durationSeconds;
  final DateTime completedAt;
  final bool completed; 
  
  SessionRecord({
    required this.task,
    required this.durationSeconds,
    required this.completedAt,
    required this.completed,
  });

  String get durationLabel => '${durationSeconds ~/ 60}m';

  String get timeLabel {
    final h = completedAt.hour;
    final m = completedAt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$hour:$m $period';
  }

  String get dateLabel {
    final now = DateTime.now();
    final todayStart     = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));
    final sessionDay     = DateTime(completedAt.year, completedAt.month, completedAt.day);

    if (sessionDay == todayStart)     return 'Today';
    if (sessionDay == yesterdayStart) return 'Yesterday';

    const monthNames = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${monthNames[completedAt.month]} ${completedAt.day}';
  }
}
