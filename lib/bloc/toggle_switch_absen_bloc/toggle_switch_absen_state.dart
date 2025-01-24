import 'package:equatable/equatable.dart';

abstract class ToggleSwitchAbsenState extends Equatable {
  const ToggleSwitchAbsenState();
  @override
  List<Object> get props => [];
  get temp => null;
}

class ToggleSwitchAbsenInitial extends ToggleSwitchAbsenState {}

class ToggleSwitchAbsenScanQRCode extends ToggleSwitchAbsenState {
  final int index;
  const ToggleSwitchAbsenScanQRCode(this.index);
  @override
  List<Object> get props => [index];
}

class ToggleSwitchAbsenManual extends ToggleSwitchAbsenState {
  final int index;
  const ToggleSwitchAbsenManual(this.index);
  @override
  List<Object> get props => [index];
}

class ToggleSwitchAbsenError extends ToggleSwitchAbsenState {
  final String errMessage;
  const ToggleSwitchAbsenError(this.errMessage);
  @override
  List<Object> get props => [errMessage];
}

// Tab Toggle Switch

class TabToggleSwitch extends ToggleSwitchAbsenState {
  final int index;
  const TabToggleSwitch(this.index);
  @override
  List<Object> get props => [index];
}
