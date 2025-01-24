import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_event.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_state.dart';

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
        emit(SelectInputManualDataAbsen(select.selectedKid!));
      } catch (e) {
        emit(
          SelectDataAbsenError(e.toString()),
        );
      }
    });
  }
}
