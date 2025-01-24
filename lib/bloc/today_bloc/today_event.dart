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
  FetchTodayEvent();
  @override
  List<Object?> get props => [];
}
