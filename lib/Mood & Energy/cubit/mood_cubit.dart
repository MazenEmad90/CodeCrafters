import 'package:flutter_bloc/flutter_bloc.dart';
import 'mood_state.dart';

class MoodCubit extends Cubit<MoodState> {
  MoodCubit() : super(MoodState(energy:5 ));

  void changeEnergy(double value) {
    emit(MoodState(energy: value.toInt()));
  }
}