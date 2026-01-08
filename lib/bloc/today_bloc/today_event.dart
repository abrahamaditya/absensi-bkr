import 'package:equatable/equatable.dart';

abstract class TodayEvent extends Equatable {}

class InitEvent extends TodayEvent {
  InitEvent();
  @override
  List<Object?> get props => [];
}

class InitTodayEvent extends TodayEvent {
  InitTodayEvent();
  @override
  List<Object?> get props => [];
}

class FetchTodayEvent extends TodayEvent {
  final String date;
  FetchTodayEvent({required this.date});
  @override
  List<Object?> get props => [date];
}
