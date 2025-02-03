import 'package:equatable/equatable.dart';
import 'package:absensi_bkr/model/kid_model.dart';

abstract class CameraScanAbsenState extends Equatable {
  const CameraScanAbsenState();
  @override
  List<Object> get props => [];
  get temp => null;
}

class CameraScanAbsenInitial extends CameraScanAbsenState {}

class CameraScanAbsenTrue extends CameraScanAbsenState {
  final bool isOpened;
  const CameraScanAbsenTrue(this.isOpened);
  @override
  List<Object> get props => [isOpened];
}

class CameraScanAbsenError extends CameraScanAbsenState {
  final String errMessage;
  const CameraScanAbsenError(this.errMessage);
  @override
  List<Object> get props => [errMessage];
}

// Ambil ID dari QR Code

class GetIDScanQR extends CameraScanAbsenState {
  final Kid data;
  final bool alreadyExist;
  const GetIDScanQR(this.data, this.alreadyExist);
  @override
  List<Object> get props => [data];
}
