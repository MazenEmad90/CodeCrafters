import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_cubit.dart';
import 'onboarding_page_model.dart';
import '../Home Dashboard/home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: 'Achieve Your',
      description:
          'Organize your day, set priorities, and track your progress with our intuitive task manager.',
      color: const Color.fromARGB(255, 14, 34, 14),
      subtitle: 'Goals',
      imagePath: 'assets/onboarding1.jpg',
    ),
    OnboardingPageModel(
      title: 'Build Better',
      description:
          'Stay consistent with daily habit tracking and visualize your streaks.',
      color: const Color.fromARGB(255, 14, 34, 14),
      subtitle: 'Habits',
      imagePath: 'assets/onboarding2.jpg',
    ),
    OnboardingPageModel(
      title: 'Track Your Well-being',
      description:
          'Understand your mood and energy patterns to stay productive.',
      color: const Color.fromARGB(255, 14, 34, 14),
      subtitle: '',
      imagePath: 'assets/onboarding3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocBuilder<OnboardingCubit, int>(
        builder: (context, index) {
          final cubit = context.read<OnboardingCubit>();
          final isLast = index == pages.length - 1;

          return Scaffold(
            backgroundColor: pages[index].color,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: index > 0
                  ? IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => cubit.emit(index - 1),
                    )
                  : null,
              actions: [
                TextButton(
                  onPressed: () => cubit.skip(),
                  child: Text('Skip',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15,
                          fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      pages[index].imagePath,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 80)),
                      Text(
                        pages[index].title,
                        style: TextStyle(
                            fontSize: 28,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 8),
                      Text(
                        pages[index].subtitle,
                        style: TextStyle(
                            fontSize: 35,
                            color: const Color.fromARGB(255, 28, 115, 12),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    pages[index].description,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 200)),
                      for (int i = 0; i < pages.length; i++)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: index == i ? 12 : 8,
                          height: index == i ? 12 : 8,
                          decoration: BoxDecoration(
                            color: index == i ? Colors.white : Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 40),
ElevatedButton(
  onPressed: () async {
    if (isLast) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seenOnboarding', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      cubit.nextPage();
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green, // لون الخلفية
    foregroundColor: const Color.fromARGB(255, 0, 0, 0), // لون النص
    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14), // حجم الزرار
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // زوايا مستديرة
    ),
    elevation: 10, // بدون ظل
  ),
  child: Text(
    isLast ? 'Get Started' : 'Next',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
