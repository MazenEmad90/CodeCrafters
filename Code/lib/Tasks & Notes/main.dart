import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B2D22),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {},
        child: const Icon(Icons.add,color: Colors.black),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff0B2D22),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Habits"),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.center_focus_strong), label: "Focus"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions), label: "Mood"),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [

              /// title
              const Text(
                "Focus Tasks",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),

              const Text(
                "Monday, Oct 24",
                style: TextStyle(color: Colors.greenAccent),
              ),

              const SizedBox(height: 20),

              /// progress card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Today's Progress",
                            style: TextStyle(color: Colors.white)),
                        Text("68%",
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold))
                      ],
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: 0.68,
                      backgroundColor: Colors.white24,
                      color: Colors.greenAccent,
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// filters
              Row(
                children: [
                  filterButton("All Tasks", true),
                  const SizedBox(width: 10),
                  filterButton("Work", false),
                  const SizedBox(width: 10),
                  filterButton("Personal", false),
                  const SizedBox(width: 10),
                  filterButton("Health", false),
                ],
              ),

              const SizedBox(height: 30),

              const Text("WORK • 3",
                  style: TextStyle(color: Colors.white54)),

              const SizedBox(height: 15),

              taskCard(
                  title: "Project sync with Design Team",
                  subtitle: "10:30 AM",
                  done: false),

              taskCard(
                  title: "Draft quarterly roadmap",
                  subtitle: "",
                  done: true),

              const SizedBox(height: 25),

              const Text("PERSONAL • 2",
                  style: TextStyle(color: Colors.white54)),

              const SizedBox(height: 15),

              taskCard(
                  title: "Groceries: Buy fresh produce",
                  subtitle: "WholeFoods",
                  done: false),

              const SizedBox(height: 25),

              const Text("HEALTH • 1",
                  style: TextStyle(color: Colors.white54)),

              const SizedBox(height: 15),

              taskCard(
                  title: "Afternoon Yoga Session",
                  subtitle: "20 min",
                  done: false),
            ],
          ),
        ),
      ),
    );
  }

  /// task card widget
  Widget taskCard(
      {required String title,
        required String subtitle,
        required bool done}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: Colors.greenAccent,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    decoration:
                    done ? TextDecoration.lineThrough : null,
                  ),
                ),

                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54),
                  )
              ],
            ),
          ),

          const Icon(Icons.mic, color: Colors.white54)
        ],
      ),
    );
  }

  /// filter button
  Widget filterButton(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: active ? Colors.greenAccent : Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: active ? Colors.black : Colors.white),
      ),
    );
  }
}