import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_bkr/service/kids_service.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_event.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_state.dart';

final KidsService _kidsService = KidsService();

class GetKidsBloc extends Bloc<KidsEvent, KidsState> {
  GetKidsBloc() : super(KidsInitial()) {
    on<FetchKidsEvent>((get, emit) async {
      try {
        final response = await _kidsService.ambilDataAnak(
          page: get.page,
          limit: 20,
          searchNameQuery: get.searchNameQuery,
        );

        final kids = response['data'];
        final totalData = response['totalData'];
        final totalPages = response['totalPages'];
        final currentPage = get.page;

        if (kids.isEmpty) {
          emit(KidsGetDataIsEmpty());
          return;
        } else {
          emit(KidsGetData(kids, totalData, totalPages, currentPage));
        }
      } catch (e) {
        emit(KidsError(e.toString()));
      }
    });
  }
}

class UpdateKidsBloc extends Bloc<KidsEvent, KidsState> {
  UpdateKidsBloc() : super(KidsInitial()) {
    on<InitUpdateKidsEvent>((data, emit) async {
      emit(KidsInitial());
    });
    on<UpdateKidsEvent>((data, emit) async {
      try {
        bool result =
            await _kidsService.updateDataAnak(data.id, data.updatedData);
        if (result == false) {
          emit(KidsUpdateDataFailed());
          return;
        }
        emit(KidsUpdateDataSuccess());
      } catch (e) {
        emit(KidsError(e.toString()));
      }
    });
  }
}

class CreateKidsBloc extends Bloc<KidsEvent, KidsState> {
  CreateKidsBloc() : super(KidsInitial()) {
    on<InitCreateKidsEvent>((data, emit) async {
      emit(KidsInitial());
    });
    on<CreateKidsEvent>((data, emit) async {
      try {
        bool result = await _kidsService.tambahDataAnak(data.newData);
        if (result == false) {
          emit(KidsCreateDataFailed());
          return;
        }
        emit(KidsCreateDataSuccess());
      } catch (e) {
        emit(KidsError(e.toString()));
      }
    });
  }
}
