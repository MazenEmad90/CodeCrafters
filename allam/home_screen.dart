import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/habit_cubit.dart';
import '../cubit/habit_state.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF062E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<HabitCubit, HabitState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Title
                  const Text(
                    "Today's Habits",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Stats Cards
                  Row(
                    children: [
                      _statCard(
                        "CURRENT STREAK",
                        "${state.streak} days",
                      ),
                      const SizedBox(width: 15),
                      _statCard(
                        "SUCCESS RATE",
                        "${state.successRate.toStringAsFixed(0)} %",
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "DAILY TASKS",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Tasks
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.habits.length,
                      itemBuilder: (context, index) {
                        final habit = state.habits[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E402B),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      habit.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      habit.isCompleted
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: Colors.greenAccent,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<HabitCubit>()
                                          .toggleHabit(index);
                                    },
                                  )
                                ],
                              ),

                              const SizedBox(height: 10),

                              LinearProgressIndicator(
                                value:
                                    habit.progress / habit.target,
                                backgroundColor: Colors.black26,
                                color: Colors.greenAccent,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0E402B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
