import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        home: HomeScreen(), // استخدم home مباشرة
      ),
    );
  }
}
