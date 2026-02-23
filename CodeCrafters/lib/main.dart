import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Habits Tracker/cubit/habit_cubit.dart';

// import 'Home Dashboard/home_screen.dart';
// import 'Habits Tracker/ui/habits_screen.dart';
// import 'Tasks & Notes/tasks_screen.dart';
// import 'Mood & Energy/mood_screen.dart';
// import 'Pomodoro+/focus_screen.dart';
// import 'Login & Sign Up/login_screen.dart';
// import 'Settings/settings_screen.dart';
// import 'Onboarding_steps/onboarding_screen.dart';

void main() {
  runApp(SmartLifeApp());
}

class SmartLifeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HabitCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Life Organizer',
        initialRoute: '/home',
        routes: {
          // '/home': (context) => HomeScreen(),
          // '/habits': (context) => HabitsScreen(),
          // '/tasks': (context) => TasksScreen(),
          // '/mood': (context) => MoodScreen(),
          // '/focus': (context) => FocusScreen(),
          // '/login': (context) => LoginScreen(),
          // '/settings': (context) => SettingsScreen(),
          // '/onboarding': (context) => OnboardingScreen(),
        },
      ),
    );
  }
}
