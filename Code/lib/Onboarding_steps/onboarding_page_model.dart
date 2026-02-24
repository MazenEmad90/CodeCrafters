import 'dart:ui';

class OnboardingPageModel {
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final String imagePath; // ← أضف ده

  OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.imagePath, // ← أضف ده
  });
}
