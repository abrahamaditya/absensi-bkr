import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_event.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_state.dart';

class ToggleSwitchAbsenBloc
    extends Bloc<ToggleSwitchAbsenEvent, ToggleSwitchAbsenState> {
  ToggleSwitchAbsenBloc() : super(ToggleSwitchAbsenInitial()) {
    on<InitToggleEvent>((data, emit) async {
      emit(ToggleSwitchAbsenInitial());
    });
    on<FetchToggleSwitchAbsenEvent>((option, emit) async {
      try {
        if (option.index == 0) {
          emit(ToggleSwitchAbsenScanQRCode(option.index!));
        } else {
          emit(ToggleSwitchAbsenManual(option.index!));
        }
      } catch (e) {
        emit(
          ToggleSwitchAbsenError(e.toString()),
        );
      }
    });
  }
}

class TabToggleSwitchBloc
    extends Bloc<ToggleSwitchAbsenEvent, ToggleSwitchAbsenState> {
  TabToggleSwitchBloc() : super(ToggleSwitchAbsenInitial()) {
    on<InitTabToggleEvent>((data, emit) async {
      emit(ToggleSwitchAbsenInitial());
    });
    on<FetchTabToggleSwitchEvent>((option, emit) async {
      try {
        emit(TabToggleSwitch(option.index!));
      } catch (e) {
        emit(
          ToggleSwitchAbsenError(e.toString()),
        );
      }
    });
  }
}
