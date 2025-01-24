import 'package:equatable/equatable.dart';

abstract class ToggleSwitchAbsenEvent extends Equatable {}

class InitToggleEvent extends ToggleSwitchAbsenEvent {
  InitToggleEvent();
  @override
  List<Object?> get props => [];
}

class FetchToggleSwitchAbsenEvent extends ToggleSwitchAbsenEvent {
  final int? index;
  FetchToggleSwitchAbsenEvent({required this.index});
  @override
  List<Object?> get props => [];
}

// Tab Toggle Switch

class InitTabToggleEvent extends ToggleSwitchAbsenEvent {
  InitTabToggleEvent();
  @override
  List<Object?> get props => [];
}

class FetchTabToggleSwitchEvent extends ToggleSwitchAbsenEvent {
  final int? index;
  FetchTabToggleSwitchEvent({required this.index});
  @override
  List<Object?> get props => [];
}
