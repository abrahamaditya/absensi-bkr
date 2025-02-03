import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_bkr/service/services_service.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_event.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_state.dart';

final ServicesService _servicesService = ServicesService();

class SelectDataAbsenBloc
    extends Bloc<SelectDataAbsenEvent, SelectDataAbsenState> {
  SelectDataAbsenBloc() : super(SelectDataAbsenInitial()) {
    on<FetchSelectDataAbsenEvent>((select, emit) async {
      try {
        emit(SelectDataAbsenTrue(select.isSelected!));
      } catch (e) {
        emit(
          SelectDataAbsenError(e.toString()),
        );
      }
    });
    on<InitialSelectDataAbsenEvent>((event, emit) {
      emit(SelectDataAbsenFalse(false));
    });
  }
}

class SelectInputManualDataAbsenBloc
    extends Bloc<SelectDataAbsenEvent, SelectDataAbsenState> {
  SelectInputManualDataAbsenBloc() : super(SelectDataAbsenInitial()) {
    on<InitialInputManualDataAbsenEvent>((event, emit) {
      emit(SelectDataAbsenInitial());
    });
    on<FetchSelectInputManualDataAbsenEvent>((select, emit) async {
      try {
        bool alreadyExist = false;

        final service =
            await _servicesService.ambilDataKegiatanDariId(select.serviceId!);

        if (service.attendance != null) {
          for (var element in service.attendance!) {
            if (element.kidsId == select.selectedKid!.id) {
              alreadyExist = true;
            }
          }
          emit(SelectInputManualDataAbsen(select.selectedKid!, alreadyExist));
        } else {
          alreadyExist = false;
          emit(SelectInputManualDataAbsen(select.selectedKid!, alreadyExist));
        }
      } catch (e) {
        emit(
          SelectDataAbsenError(e.toString()),
        );
      }
    });
  }
}
