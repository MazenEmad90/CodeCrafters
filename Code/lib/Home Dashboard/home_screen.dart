import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'focus_cubit.dart';
import 'focus_state.dart';

final List<String> moods = ['😔', '😐', '😊', '🤩', '🔥'];

class DashboardScreen extends StatelessWidget {
  final ValueNotifier<bool> _task1Completed = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _task2Completed = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _task3Completed = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _task4Completed = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _task5Completed = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E2214),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monday, Oct 24',
                      style: TextStyle(
                          color: Color.fromARGB(255, 23, 92, 43), fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Hey, Alex 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/onboarding3.jpg'),
                ),
              ],
            ),

            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 23, 92, 43),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'How are you feeling today?',
                            style: TextStyle(
                                color: const Color.fromARGB(170, 255, 255, 255),
                                fontSize: 20,
                                fontWeight: FontWeight.w200),
                          ),
                        ]),
                    SizedBox(height: 12),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              5,
                              (index) => CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.green.shade900,
                                child: Text(moods[index],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 28)),
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
              ]),
            ),

            SizedBox(height: 30),

            // Habits
            _sectionHeader('My Habits', onTap: () {}),
            _habitTile('Water Intake', 0.75),
            _habitTile('Read 10 Pages', 0.30),
            _habitTile('Meditation 15m', 1.95),

            SizedBox(height: 30),

            // Tasks
            Text(
              "Today's Top Tasks",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ValueListenableBuilder<bool>(
              valueListenable: _task1Completed,
              builder: (context, completed, _) => _taskTile(
                'Draft project proposal',
                '9:30 AM',
                'WORK',
                completed: completed,
                onToggle: () => _task1Completed.value = !completed,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _task2Completed,
              builder: (context, completed, _) => _taskTile(
                'Buy groceries',
                '5:00 PM',
                'ERRAND',
                completed: completed,
                onToggle: () => _task2Completed.value = !completed,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _task3Completed,
              builder: (context, completed, _) => _taskTile(
                'Family dinner',
                '8:30 PM',
                'PERSONAL',
                completed: completed,
                onToggle: () => _task3Completed.value = !completed,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _task4Completed,
              builder: (context, completed, _) => _taskTile(
                'Go to the gym',
                '7:00 AM',
                'HEALTH',
                completed: completed,
                onToggle: () => _task4Completed.value = !completed,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _task5Completed,
              builder: (context, completed, _) => _taskTile(
                'Client sync call',
                '1:00 PM',
                'CALL',
                completed: completed,
                onToggle: () => _task5Completed.value = !completed,
              ),
            ),

            SizedBox(height: 30),

            // Focus Session (uses FocusCubit)
            BlocProvider(
              create: (_) => FocusCubit(initialSeconds: 24 * 60),
              child: BlocBuilder<FocusCubit, FocusState>(builder: (context, focus) {
                String formatSeconds(int s) {
                  final mm = s ~/ 60;
                  final ss = s % 60;
                  return '${mm.toString().padLeft(2, '0')}:${ss.toString().padLeft(2, '0')}';
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatSeconds(focus.seconds),
                      textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text("Focusing on 'Project Proposal'", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            IconButton(
                              icon: Icon(focus.isRunning ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.greenAccent, size: 40),
                              onPressed: () {
                                if (focus.isRunning) {
                                  context.read<FocusCubit>().pause();
                                } else {
                                  context.read<FocusCubit>().start();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.replay, color: Colors.white70),
                              onPressed: () => context.read<FocusCubit>().reset(),
                            ),
                          ]),

                          Row(children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.white70),
                              onPressed: () => context.read<FocusCubit>().decrement(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white70),
                              onPressed: () => context.read<FocusCubit>().increment(),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0E2214),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white54,
        currentIndex: 0, // Focus is selected
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Focus'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood'),
        ],
      ),
    );
  }

  // Section header with optional "See All"
  Widget _sectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: onTap,
          child: Text('SEE ALL', style: TextStyle(color: Colors.greenAccent)),
        ),
      ],
    );
  }

  Widget _habitTile(String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white)),
        SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white12,
          color: Colors.greenAccent,
          minHeight: 8,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Task tile with optional completion
  Widget _taskTile(String title, String time, String tag,
      {bool completed = false, required VoidCallback onToggle}) {
    return GestureDetector(
      onTap: onToggle, // لما تدوس يستدعي الكول باك
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(
              completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: completed ? Colors.greenAccent : Colors.white54,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.white)),
                  SizedBox(height: 4),
                  Text('$time  •  $tag',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
