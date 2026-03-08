import 'package:flutter_bloc/flutter_bloc.dart';
import 'mood_state.dart';

class MoodCubit extends Cubit<MoodState> {
  MoodCubit() : super(MoodState(energy: 5, mood: "Neutral"));

  void changeMood(String mood) {
    emit(MoodState(energy: state.energy, mood: mood));
  }

  void changeEnergy(double value) {
    emit(MoodState(energy: value.toInt(), mood: state.mood));
  }
}