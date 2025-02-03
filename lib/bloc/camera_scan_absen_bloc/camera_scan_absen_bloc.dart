import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_bkr/service/kids_service.dart';
import 'package:absensi_bkr/service/services_service.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_event.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_state.dart';

final KidsService _kidsService = KidsService();
final ServicesService _servicesService = ServicesService();

class CameraScanAbsenBloc
    extends Bloc<CameraScanAbsenEvent, CameraScanAbsenState> {
  CameraScanAbsenBloc() : super(CameraScanAbsenInitial()) {
    on<FetchCameraScanAbsenEvent>((open, emit) async {
      try {
        emit(CameraScanAbsenTrue(open.isOpened!));
      } catch (e) {
        emit(
          CameraScanAbsenError(e.toString()),
        );
      }
    });
  }
}

class GetKidsByIdScanQRBloc
    extends Bloc<CameraScanAbsenEvent, CameraScanAbsenState> {
  GetKidsByIdScanQRBloc() : super(CameraScanAbsenInitial()) {
    on<InitIDScanQREvent>((data, emit) async {
      emit(CameraScanAbsenInitial());
    });
    on<FetchIDScanQREvent>((data, emit) async {
      try {
        final kids = await _kidsService.ambilDataAnakDariId(data.kidId!);

        bool alreadyExist = false;

        final service =
            await _servicesService.ambilDataKegiatanDariId(data.serviceId!);

        if (service.attendance != null) {
          for (var element in service.attendance!) {
            if (element.kidsId == data.kidId) {
              alreadyExist = true;
            }
          }
          emit(GetIDScanQR(kids, alreadyExist));
        } else {
          alreadyExist = false;
          emit(GetIDScanQR(kids, alreadyExist));
        }
      } catch (e) {
        emit(CameraScanAbsenError(e.toString()));
      }
    });
  }
}
