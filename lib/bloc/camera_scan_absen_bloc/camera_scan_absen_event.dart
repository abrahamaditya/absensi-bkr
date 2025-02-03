import 'package:equatable/equatable.dart';

abstract class CameraScanAbsenEvent extends Equatable {}

class InitEvent extends CameraScanAbsenEvent {
  InitEvent();
  @override
  List<Object?> get props => [];
}

class FetchCameraScanAbsenEvent extends CameraScanAbsenEvent {
  final bool? isOpened;
  FetchCameraScanAbsenEvent({required this.isOpened});
  @override
  List<Object?> get props => [];
}

// Ambil ID dari QR Code

class InitIDScanQREvent extends CameraScanAbsenEvent {
  InitIDScanQREvent();
  @override
  List<Object?> get props => [];
}

class FetchIDScanQREvent extends CameraScanAbsenEvent {
  final String? kidId;
  final String? serviceId;
  FetchIDScanQREvent({required this.kidId, required this.serviceId});
  @override
  List<Object?> get props => [];
}
