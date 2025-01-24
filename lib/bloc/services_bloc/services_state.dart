import 'package:equatable/equatable.dart';
import 'package:absensi_bkr/model/service_model.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();
  @override
  List<Object> get props => [];
  get temp => null;
}

class ServicesInitial extends ServicesState {}

class ServicesGetData extends ServicesState {
  final List<Service> data;
  final int totalData;
  final int totalPage;
  const ServicesGetData(this.data, this.totalData, this.totalPage);
  @override
  List<Object> get props => [data];
}

class ServicesGetDataIsEmpty extends ServicesState {
  const ServicesGetDataIsEmpty();
  @override
  List<Object> get props => [];
}

class ServicesError extends ServicesState {
  final String errMessage;
  const ServicesError(this.errMessage);
  @override
  List<Object> get props => [errMessage];
}

// Create Services

class ServicesCreateDataSuccess extends ServicesState {
  const ServicesCreateDataSuccess();
  @override
  List<Object> get props => [];
}

class ServicesCreateDataFailed extends ServicesState {
  const ServicesCreateDataFailed();
  @override
  List<Object> get props => [];
}

// Lainnya (form) Services

class LainnyaServicesTrue extends ServicesState {
  const LainnyaServicesTrue();
  @override
  List<Object> get props => [];
}

class LainnyaServicesFalse extends ServicesState {
  const LainnyaServicesFalse();
  @override
  List<Object> get props => [];
}

// Ambil ID dari QR Code

class GetDataByID extends ServicesState {
  final Service data;
  const GetDataByID(this.data);
  @override
  List<Object> get props => [data];
}
