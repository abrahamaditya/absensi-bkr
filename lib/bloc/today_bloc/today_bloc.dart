import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_bkr/helper/format_date.dart';
import 'package:absensi_bkr/service/services_service.dart';
import 'package:absensi_bkr/bloc/today_bloc/today_event.dart';
import 'package:absensi_bkr/bloc/today_bloc/today_state.dart';

final ServicesService _servicesService = ServicesService();

class TodayBloc extends Bloc<TodayEvent, TodayState> {
  TodayBloc() : super(TodayInitial()) {
    on<InitTodayEvent>((data, emit) async {
      emit(TodayInitial());
    });
    on<FetchTodayEvent>((event, emit) async {
      try {
        final DateTime now = DateTime.now();
        String today = DateTime.now().toIso8601String().split('T')[0];

        //final now = DateTime.parse('2025-01-16 09:30:00.001');
        //String today =
        //DateTime.parse('2025-01-16').toIso8601String().split('T')[0];

        final servicesToday =
            await _servicesService.ambilDataKegiatanHariIni(today);

        if (servicesToday.isEmpty) {
          emit(TodayGetDataIsEmpty());
          return;
        } else {
          // Membagi data menjadi tiga kategori
          final pastServices = servicesToday.where((service) {
            final DateTime serviceTime =
                DateTime.parse('${service.date} ${service.time}');
            return now.difference(serviceTime).inMinutes >
                89; // Lewat lebih dari 1 jam 30 menit
          }).toList();

          final upcomingServices = servicesToday.where((service) {
            final DateTime serviceTime =
                DateTime.parse('${service.date} ${service.time}');
            return serviceTime.difference(now).inMinutes >
                29; // Lebih dari 30 menit dari sekarang
          }).toList();

          var liveServices = servicesToday.where((service) {
            final DateTime serviceTime =
                DateTime.parse('${service.date} ${service.time}');
            final int differenceInMinutes =
                now.difference(serviceTime).inMinutes;
            return differenceInMinutes <= 89 &&
                differenceInMinutes >= -29; // Live rentang waktu
          }).toList();

          liveServices = liveServices.map((service) {
            if (service.attendance != null) {
              service.attendance!.sort((a, b) {
                DateTime timestampA = formatYYYYMMDDHHMMSS(a.timestamp!);
                DateTime timestampB = formatYYYYMMDDHHMMSS(b.timestamp!);
                return timestampB.compareTo(timestampA);
              });
            }
            if (service.date != null) {
              service.date =
                  formatTanggalEEEEDDMMMMYYYYIndonesia(service.date!);
            }
            return service;
          }).toList();

          emit(TodayGetData(pastServices, liveServices, upcomingServices));
        }
      } catch (e) {
        emit(TodayError(e.toString()));
      }
    });
  }
}
