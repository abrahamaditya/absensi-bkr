import 'package:equatable/equatable.dart';
import 'package:absensi_bkr/model/service_model.dart';

abstract class TodayState extends Equatable {
  const TodayState();
  @override
  List<Object> get props => [];
  get temp => null;
}

class TodayInitial extends TodayState {}

class TodayLoading extends TodayState {}

class TodayGetData extends TodayState {
  final List<Service> pastData;
  final List<Service> liveData;
  final List<Service> upcomingData;
  final String date;
  const TodayGetData(
      this.pastData, this.liveData, this.upcomingData, this.date);
  @override
  List<Object> get props => [pastData, upcomingData];
}

class TodayGetDataIsEmpty extends TodayState {
  final String date;
  const TodayGetDataIsEmpty(this.date);
  @override
  List<Object> get props => [];
}

class TodayError extends TodayState {
  final String errMessage;
  const TodayError(this.errMessage);
  @override
  List<Object> get props => [errMessage];
}
