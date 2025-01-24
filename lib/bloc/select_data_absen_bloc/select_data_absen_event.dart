import 'package:equatable/equatable.dart';
import 'package:absensi_bkr/model/kid_model.dart';

abstract class SelectDataAbsenEvent extends Equatable {}

class InitEvent extends SelectDataAbsenEvent {
  InitEvent();
  @override
  List<Object?> get props => [];
}

class FetchSelectDataAbsenEvent extends SelectDataAbsenEvent {
  final bool? isSelected;
  FetchSelectDataAbsenEvent({required this.isSelected});
  @override
  List<Object?> get props => [];
}

class InitialSelectDataAbsenEvent extends SelectDataAbsenEvent {
  InitialSelectDataAbsenEvent();
  @override
  List<Object?> get props => [];
}

// Select Dropdown Input Manual

class FetchSelectInputManualDataAbsenEvent extends SelectDataAbsenEvent {
  final Kid? selectedKid;
  FetchSelectInputManualDataAbsenEvent({required this.selectedKid});
  @override
  List<Object?> get props => [];
}

class InitialInputManualDataAbsenEvent extends SelectDataAbsenEvent {
  InitialInputManualDataAbsenEvent();
  @override
  List<Object?> get props => [];
}
