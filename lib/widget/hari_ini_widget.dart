import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/helper/padding.dart';
import 'package:absensi_bkr/helper/format_date.dart';
import 'package:absensi_bkr/model/service_model.dart';
import 'package:absensi_bkr/bloc/today_bloc/today_bloc.dart';
import 'package:absensi_bkr/bloc/today_bloc/today_state.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_bloc.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_event.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_bloc.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_bloc.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_event.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_event.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_bloc.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_event.dart';

Widget hariIniWidget(BuildContext context) {
  return Container(
    color: white,
    height: double.infinity,
    child: Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.025,
            child: Image.asset(
              'asset/image/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: paddingMenu,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jadwal Hari Ini",
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: black,
                  ),
                ),
                Text(
                  dateNow,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: black,
                  ),
                ),
                Divider(
                  color: lightGrey,
                  thickness: 1,
                ),
                const SizedBox(height: 40),
                BlocBuilder<TodayBloc, TodayState>(
                  builder: (context, state) {
                    if (state is TodayGetData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.liveData.isNotEmpty) ...[
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  "Sedang Berlangsung",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: orange,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: lightGrey,
                              thickness: 1,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: state.liveData.map((service) {
                                return _kartu(
                                  context: context,
                                  data: service,
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 40),
                          ],
                          if (state.upcomingData.isNotEmpty) ...[
                            Text(
                              "Selanjutnya",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: black,
                              ),
                            ),
                            Divider(
                              color: lightGrey,
                              thickness: 1,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: state.upcomingData.map((service) {
                                return _kartu(
                                  context: context,
                                  data: service,
                                  isNext: true,
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 40),
                          ],
                          if (state.pastData.isNotEmpty) ...[
                            Text(
                              "Sudah Berakhir",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: black,
                              ),
                            ),
                            Divider(
                              color: lightGrey,
                              thickness: 1,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: state.pastData.map((service) {
                                return _kartu(
                                  context: context,
                                  data: service,
                                  isFinished: true,
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      );
                    } else {
                      return Center(
                        child: SizedBox(
                          width: 700,
                          height: MediaQuery.of(context).size.height / 2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Lottie.asset(
                                'asset/lottiefiles/orange-walk.json',
                                width: 300,
                              ),
                              Positioned(
                                bottom: 70,
                                child: Text(
                                  "Tidak ada jadwal apapun hari ini",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: lightGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _kartu({
  required BuildContext context,
  required Service data,
  bool isNext = false,
  bool isFinished = false,
}) {
  return Container(
    width: 225,
    padding: EdgeInsets.symmetric(
      vertical: isNext || isFinished ? 15 : 20,
      horizontal: 15,
    ),
    decoration: BoxDecoration(
      color: isFinished
          ? lightGrey
          : isNext
              ? lightGrey
              : purple,
      borderRadius: BorderRadius.circular(2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.name!.contains("Ibadah Reguler") ||
                  data.name!.contains("English Service")
              ? "Ibadah Anak"
              : data.name!.contains("Menara Doa")
                  ? "Menara Doa"
                  : "Lainnya",
          style: GoogleFonts.montserrat(
            color: isFinished || isNext ? darkGrey : white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.name!,
          style: GoogleFonts.montserrat(
            color: isFinished || isNext ? darkGrey : white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          data.time!,
          style: GoogleFonts.montserrat(
            color: isFinished || isNext ? darkGrey : white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (!isNext && !isFinished) ...[
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context
                    .read<GetServiceByIdBloc>()
                    .add(FetchServiceByIDEvent(serviceId: data.id));
                context
                    .read<SelectDataAbsenBloc>()
                    .add(FetchSelectDataAbsenEvent(isSelected: false));
                context
                    .read<CameraScanAbsenBloc>()
                    .add(FetchCameraScanAbsenEvent(isOpened: false));
                context
                    .read<ToggleSwitchAbsenBloc>()
                    .add(FetchToggleSwitchAbsenEvent(index: 0));
                context
                    .read<TabToggleSwitchBloc>()
                    .add(FetchTabToggleSwitchEvent(index: 0));
                context.read<SidebarMenuBloc>().add(FetchSidebarMenuEvent(
                    menu: "Kegiatan Detail",
                    data: data,
                    detailKegiatanPreviousMenu: "Hari Ini"));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: Text(
                "Absensi",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: white,
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
