import 'package:equatable/equatable.dart';

class FocusState extends Equatable {
  final int seconds;
  final bool isRunning;

  const FocusState({required this.seconds, this.isRunning = false});

  FocusState copyWith({int? seconds, bool? isRunning}) {
    return FocusState(seconds: seconds ?? this.seconds, isRunning: isRunning ?? this.isRunning);
  }

  @override
  List<Object> get props => [seconds, isRunning];
}
