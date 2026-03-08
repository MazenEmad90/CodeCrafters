import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/mood_cubit.dart';
import '../cubit/mood_state.dart';

class MoodPage extends StatelessWidget {
  const MoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0B2D22),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<MoodCubit, MoodState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Daily Log",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "How are you feeling right now?",
                    style: TextStyle(color: Colors.white70),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      moodButton(context, "Low", "😔"),
                      moodButton(context, "Neutral", "😐"),
                      moodButton(context, "Good", "😊"),
                      moodButton(context, "Great", "🤩"),
                    ],
                  ),

                  SizedBox(height: 40),

                  Text(
                    "Energy Level",
                    style: TextStyle(color: Colors.white),
                  ),

                  Slider(
                    value: state.energy.toDouble(),
                    min: 0,
                    max: 10,
                    onChanged: (value) {
                      context.read<MoodCubit>().changeEnergy(value);
                    },
                  ),

                  Text(
                    "${state.energy}/10",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 40),

                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Weekly Trend",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      ),
                      onPressed: () {},
                      child: Text(
                        "Log Your Mood",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget moodButton(BuildContext context, String mood, String emoji) {
    return GestureDetector(
      onTap: () {
        context.read<MoodCubit>().changeMood(mood);
      },
      child: Column(
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 28),
          ),
          SizedBox(height: 5),
          Text(
            mood,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}