import 'package:equatable/equatable.dart';

abstract class ServicesEvent extends Equatable {}

class InitEvent extends ServicesEvent {
  InitEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllServicesEvent extends ServicesEvent {
  FetchAllServicesEvent();
  @override
  List<Object?> get props => [];
}

class FetchServicesEvent extends ServicesEvent {
  final int page;
  final String searchNameQuery;
  FetchServicesEvent({required this.page, required this.searchNameQuery});
  @override
  List<Object?> get props => [];
}

// Create Services

class InitCreateServicesEvent extends ServicesEvent {
  InitCreateServicesEvent();
  @override
  List<Object?> get props => [];
}

class CreateServicesEvent extends ServicesEvent {
  final Map<String, dynamic> newData;
  CreateServicesEvent({required this.newData});
  @override
  List<Object?> get props => [newData];
}

// Lainnya (form) Services

class LainnyaServicesEvent extends ServicesEvent {
  final bool visibility;
  LainnyaServicesEvent({required this.visibility});
  @override
  List<Object?> get props => [visibility];
}

// Create Services

class InitTakeAttendanceEvent extends ServicesEvent {
  InitTakeAttendanceEvent();
  @override
  List<Object?> get props => [];
}

class TakeAttendanceEvent extends ServicesEvent {
  final String serviceId;
  final String kidId;
  final Map<String, dynamic> dataAttendanceKid;
  final Map<String, dynamic> dataAttendanceService;
  final Map<String, dynamic> dataAttendanceGlobalAttendance;
  TakeAttendanceEvent(
      {required this.serviceId,
      required this.kidId,
      required this.dataAttendanceKid,
      required this.dataAttendanceService,
      required this.dataAttendanceGlobalAttendance});
  @override
  List<Object?> get props => [
        serviceId,
        kidId,
        dataAttendanceKid,
        dataAttendanceService,
        dataAttendanceGlobalAttendance
      ];
}

// Ambil ID dari QR Code

class InitServiceByIDvent extends ServicesEvent {
  InitServiceByIDvent();
  @override
  List<Object?> get props => [];
}

class FetchServiceByIDEvent extends ServicesEvent {
  final String? serviceId;
  FetchServiceByIDEvent({required this.serviceId});
  @override
  List<Object?> get props => [];
}
