import 'package:equatable/equatable.dart';
import 'package:absensi_bkr/model/kid_model.dart';

abstract class SelectDataAbsenState extends Equatable {
  const SelectDataAbsenState();
  @override
  List<Object> get props => [];
  get temp => null;
}

class SelectDataAbsenInitial extends SelectDataAbsenState {}

class SelectDataAbsenTrue extends SelectDataAbsenState {
  final bool isSelected;
  const SelectDataAbsenTrue(this.isSelected);
  @override
  List<Object> get props => [isSelected];
}

class SelectDataAbsenError extends SelectDataAbsenState {
  final String errMessage;
  const SelectDataAbsenError(this.errMessage);
  @override
  List<Object> get props => [errMessage];
}

class SelectDataAbsenFalse extends SelectDataAbsenState {
  final bool boolean;
  const SelectDataAbsenFalse(this.boolean);
  @override
  List<Object> get props => [boolean];
}

// Select Dropdown Input Manual

class SelectInputManualDataAbsen extends SelectDataAbsenState {
  final Kid selectedKid;
  final bool alreadyExist;
  const SelectInputManualDataAbsen(this.selectedKid, this.alreadyExist);
  @override
  List<Object> get props => [selectedKid];
}
