import 'package:intl/intl.dart';
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
        DateTime parsedDate = DateTime.parse(event.date);
        String dateShow =
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(parsedDate);

        //final now = DateTime.parse('2025-01-16 09:30:00.001');
        //String today =
        //DateTime.parse('2025-01-16').toIso8601String().split('T')[0];

        final servicesToday =
            await _servicesService.ambilDataKegiatanHariIni(event.date);

        if (servicesToday.isEmpty) {
          emit(TodayGetDataIsEmpty(dateShow));
        }
        if (servicesToday.isNotEmpty) {
          // Membagi data menjadi tiga kategori
          final pastServices = servicesToday.where((service) {
            final DateTime serviceTime =
                DateTime.parse('${service.date} ${service.time}');
            return now.difference(serviceTime).inMinutes >
                104; // Lewat lebih dari 1 jam 45 menit
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
            return differenceInMinutes <= 104 &&
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

          emit(TodayGetData(
              pastServices, liveServices, upcomingServices, dateShow));
        }
      } catch (e) {
        emit(TodayError(e.toString()));
      }
    });
  }
}
