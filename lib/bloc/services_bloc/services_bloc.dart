import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_bkr/service/kids_service.dart';
import 'package:absensi_bkr/service/services_service.dart';
import 'package:absensi_bkr/service/global_attendance_service.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_event.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_state.dart';

final ServicesService _servicesService = ServicesService();
final KidsService _kidsService = KidsService();
final GlobalAttendanceService _globalAttendanceService =
    GlobalAttendanceService();

class GetServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  GetServicesBloc() : super(ServicesInitial()) {
    on<FetchServicesEvent>((get, emit) async {
      try {
        int limit = 20;
        final services = await _servicesService.ambilDataKegiatan(
          page: get.page,
          limit: limit,
        );
        final totalData = await _servicesService.ambilTotalJumlahDataKegiatan();
        final int totalPage = (totalData / limit).ceil();
        if (services.isEmpty) {
          emit(ServicesGetDataIsEmpty());
          return;
        } else {
          emit(ServicesGetData(services, totalData, totalPage));
        }
      } catch (e) {
        emit(ServicesError(e.toString()));
      }
    });
  }
}

class CreateServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  CreateServicesBloc() : super(ServicesInitial()) {
    on<InitCreateServicesEvent>((data, emit) async {
      emit(ServicesInitial());
    });
    on<CreateServicesEvent>((data, emit) async {
      try {
        bool result = await _servicesService.tambahDataKegiatan(data.newData);
        if (result == false) {
          emit(ServicesCreateDataFailed());
          return;
        }
        emit(ServicesCreateDataSuccess());
      } catch (e) {
        emit(ServicesError(e.toString()));
      }
    });
  }
}

class LainnyaServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  LainnyaServicesBloc() : super(ServicesInitial()) {
    on<LainnyaServicesEvent>((lainnya, emit) async {
      try {
        if (lainnya.visibility == true) {
          emit(LainnyaServicesTrue());
          return;
        }
        emit(LainnyaServicesFalse());
      } catch (e) {
        emit(ServicesError(e.toString()));
      }
    });
  }
}

class TakeAttendanceBloc extends Bloc<ServicesEvent, ServicesState> {
  TakeAttendanceBloc() : super(ServicesInitial()) {
    on<InitTakeAttendanceEvent>((data, emit) async {
      emit(ServicesInitial());
    });
    on<TakeAttendanceEvent>((data, emit) async {
      try {
        bool resultUpdateAttendanceService =
            await _servicesService.tambahAbsenDocsKegiatan(
                data.serviceId, data.dataAttendanceService);

        if (!resultUpdateAttendanceService) {
          emit(ServicesCreateDataFailed());
          return;
        }

        bool resultUpdateAttendanceKid = await _kidsService.tambahAbsenDocsAnak(
            data.kidId, data.dataAttendanceKid);

        if (!resultUpdateAttendanceKid) {
          emit(ServicesCreateDataFailed());
          return;
        }

        bool resultUpdateAttendanceGlobal =
            await _globalAttendanceService.tambahAbsenDocsGlobalAttendance(
                data.dataAttendanceGlobalAttendance);

        if (!resultUpdateAttendanceGlobal) {
          emit(ServicesCreateDataFailed());
          return;
        }

        emit(ServicesCreateDataSuccess());
      } catch (e) {
        emit(ServicesError(e.toString()));
      }
    });
  }
}

class GetServiceByIdBloc extends Bloc<ServicesEvent, ServicesState> {
  GetServiceByIdBloc() : super(ServicesInitial()) {
    on<InitServiceByIDvent>((data, emit) async {
      emit(ServicesInitial());
    });
    on<FetchServiceByIDEvent>((data, emit) async {
      try {
        final service =
            await _servicesService.ambilDataKegiatanDariId(data.serviceId!);
        emit(GetDataByID(service));
      } catch (e) {
        emit(ServicesError(e.toString()));
      }
    });
  }
}
