import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_bkr/service/kids_service.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_event.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_state.dart';

final KidsService _kidsService = KidsService();

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
        emit(GetIDScanQR(kids));
      } catch (e) {
        emit(CameraScanAbsenError(e.toString()));
      }
    });
  }
}
