import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/habit_cubit.dart';
import '../cubit/habit_state.dart';


//  App Colors 
const Color kBgDark = Color(0xFF062E1E);    
const Color kCardColor = Color(0xFF0E402B); 
const Color kGreen = Color(0xFF00FF7F);     
const Color kGreenDim = Color(0xFF1A5C3A);  

//  HomeScreen - Main page that displays daily habits
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Week days shown in the date strip date strip
  final List<Map<String, String>> _weekDays = [
    {'day': 'WED', 'date': '07'},
    {'day': 'THU', 'date': '08'},
    {'day': 'FRI', 'date': '09'},
    {'day': 'SAT', 'date': '10'},
    {'day': 'SUN', 'date': '11'},
    {'day': 'MON', 'date': '12'},
  ];

  /// Index of the currently selected day
  int _selectedDayIndex = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: BlocBuilder<HabitCubit, HabitState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Header: title + avatar avatar
                  _buildHeader(),

                  const SizedBox(height: 20),

                  // Date strip: week days 
                  _buildDateStrip(),

                  const SizedBox(height: 24),

                  // Stats cards: streak + success rate 
                  _buildStatsRow(state),

                  const SizedBox(height: 24),

                  // Section title / 
                  const Text(
                    "DAILY TASKS",
                    style: TextStyle(
                      color: kGreen,
                      letterSpacing: 2,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Habits list + quote card at the bottom
                  
                  Expanded(
                    child: ListView(
                      children: [
                        ...List.generate(state.habits.length, (index) {
                          return _buildHabitCard(context, state, index);
                        }),
                        const SizedBox(height: 8),
                        _buildQuoteCard(),
                      ],
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

  //  Header Widget - Title, date, and avatar
  
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Today's Habits",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            // Date in green below the title / التاريخ بالأخضر تحت العنوان
            Text(
              "Monday, June 12",
              style: TextStyle(color: kGreen, fontSize: 14),
            ),
          ],
        ),
        // Circular profile avatar / صورة الـ profile دائرية
        CircleAvatar(
          radius: 24,
          backgroundColor: kCardColor,
          child: ClipOval(
            child: Image.network(
              'https://i.pravatar.cc/100',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, color: Colors.white54),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  //  Date Strip - Scrollable week day selector
  // 
  // ============================================================
  Widget _buildDateStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_weekDays.length, (index) {
        final isSelected = index == _selectedDayIndex;
        return GestureDetector(
          onTap: () => setState(() => _selectedDayIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              // Selected day is green, others are dark card /
              color: isSelected ? kGreen : kCardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  _weekDays[index]['day']!,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _weekDays[index]['date']!,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ============================================================
  //  Stats Row - Two stat cards side by side
  // 
  // ============================================================
  Widget _buildStatsRow(HabitState state) {
    return Row(
      children: [
        _statCard("CURRENT STREAK", "${state.streak} days"),
        const SizedBox(width: 15),
        _statCard("SUCCESS RATE", "${state.successRate.toStringAsFixed(0)} %"),
      ],
    );
  }

  /// Single stat card (streak or success rate)
  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: kGreen,
                fontSize: 11,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
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

  
  //  Habit Card - Displays a single habit with progress

  Widget _buildHabitCard(BuildContext context, HabitState state, int index) {
    final habit = state.habits[index];

    // Clamp progress between 0 and 1 for the progress bar
    
    final progressPercent = (habit.progress / habit.target).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        // Green border when completed /
        border: habit.isCompleted
            ? Border.all(color: kGreen.withOpacity(0.4), width: 1)
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Habit icon with colored background / 
              _buildHabitIcon(habit.icon, habit.iconBgColor),

              const SizedBox(width: 12),

              // Habit name and subtitle /
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      habit.subtitle,
                      style: TextStyle(
                        // Green if completed, faded white otherwise
                        color: habit.isCompleted
                            ? kGreen
                            : Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Toggle button: complete / incomplete / 
              GestureDetector(
                onTap: () => context.read<HabitCubit>().toggleHabit(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: habit.isCompleted ? kGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: habit.isCompleted
                          ? kGreen
                          : kGreen.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: habit.isCompleted
                        ? Colors.black
                        : kGreen.withOpacity(0.5),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar / 
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressPercent,
              backgroundColor: Colors.black26,
              valueColor: AlwaysStoppedAnimation<Color>(kGreen),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  /// Colored icon container for each habit

  Widget _buildHabitIcon(String emoji, int bgColor) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Color(bgColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  // ============================================================
  //  Quote Card - Motivational quote at the bottom of the list

  // ============================================================
  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Opening quote mark /
          const Text(
            '❝',
            style: TextStyle(color: kGreen, fontSize: 24),
          ),
          const SizedBox(height: 8),
          const Text(
            '"The secret of your future is hidden in your daily routine."',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Quote author /
          Row(
            children: const [
              Text('— ', style: TextStyle(color: kGreen, fontWeight: FontWeight.bold)),
              Text(
                'MIKE MURDOCK',
                style: TextStyle(
                  color: kGreen,
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
