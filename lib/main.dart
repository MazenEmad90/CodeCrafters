import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Onboarding_steps/onboarding_screen.dart';
import 'Login & Sign Up/sign_up.dart';
import './Home Dashboard/home_screen.dart';
// Cubit
import 'Habits Tracker/cubit/habit_cubit.dart';
// Screen
import 'Habits Tracker/ui/home_screen.dart';

void main() {
  runApp(SmartLifeApp());
}

class SmartLifeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HabitCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Life Organizer',
        home: DashboardScreen(), // استخدم home مباشرة
      ),
    );
  }
}
