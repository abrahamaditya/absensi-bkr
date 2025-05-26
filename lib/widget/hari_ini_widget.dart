import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
  final ScrollController scrollController = ScrollController();
  final double screenWidth = MediaQuery.of(context).size.width;

  return screenWidth < 1000
      ? mobileLayout(context)
      : Container(
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
                      const SizedBox(height: 20),
                      BlocBuilder<TodayBloc, TodayState>(
                        builder: (context, state) {
                          if (state is TodayGetData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.liveData.isNotEmpty ||
                                    state.upcomingData.isNotEmpty) ...[
                                  Text(
                                    state.liveData.isNotEmpty == true
                                        ? "Sedang Berlangsung"
                                        : "Selanjutnya",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: state.liveData.isNotEmpty == true
                                          ? orange
                                          : middlePurple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onHorizontalDragUpdate: (details) {
                                      scrollController.jumpTo(
                                        scrollController.offset -
                                            details.delta.dx,
                                      );
                                    },
                                    child: Scrollbar(
                                      controller: scrollController,
                                      thumbVisibility: true,
                                      scrollbarOrientation:
                                          ScrollbarOrientation.bottom,
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 10,
                                          children: [
                                            if (state.liveData.isNotEmpty) ...[
                                              Wrap(
                                                spacing: 10,
                                                runSpacing: 10,
                                                children: state.liveData
                                                    .map((service) {
                                                  return _kartu(
                                                    context: context,
                                                    data: service,
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                            if (state
                                                .upcomingData.isNotEmpty) ...[
                                              Wrap(
                                                spacing: 10,
                                                runSpacing: 10,
                                                children: state.upcomingData
                                                    .map((service) {
                                                  return _kartu(
                                                    context: context,
                                                    data: service,
                                                    isNext: true,
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 35),
                                ],
                                if (state.pastData.isNotEmpty) ...[
                                  Wrap(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Sudah Berakhir",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: darkGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          if (state.pastData.isNotEmpty) ...[
                                            Wrap(
                                              spacing: 10,
                                              runSpacing: 10,
                                              children:
                                                  state.pastData.map((service) {
                                                return _kartu(
                                                  context: context,
                                                  data: service,
                                                  isFinished: true,
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ],
                            );
                          } else if (state is TodayGetDataIsEmpty) {
                            return Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  Container(
                                    height: 225,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'asset/image/jesus-with-children.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Tidak ada jadwal kegiatan hari ini",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Skeletonizer(
                              enabled: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Daftar Kegiatan",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: black,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Wrap(
                                    spacing: 10,
                                    children: [
                                      Container(
                                        height: 200,
                                        width: 200,
                                        color: lightPurple,
                                      ),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        color: lightPurple,
                                      ),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        color: lightPurple,
                                      ),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        color: lightPurple,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "Daftar Kegiatan",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: black,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Wrap(
                                    spacing: 10,
                                    children: [
                                      Container(
                                        height: 125,
                                        width: 200,
                                        color: lightPurple,
                                      ),
                                      Container(
                                        height: 125,
                                        width: 200,
                                        color: lightPurple,
                                      ),
                                    ],
                                  ),
                                ],
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
    width: 210,
    padding: EdgeInsets.symmetric(
      vertical: isNext || isFinished ? 17 : 20,
      horizontal: 17,
    ),
    decoration: BoxDecoration(
      color: isFinished
          ? lightGrey
          : isNext
              ? lightPurple
              : purple,
      borderRadius: BorderRadius.circular(2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isNext
              ? "Upcoming"
              : isFinished
                  ? "Ended"
                  : "LIVE",
          style: GoogleFonts.montserrat(
            color: isNext
                ? middlePurple
                : isFinished
                    ? darkGrey
                    : white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.name!,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: GoogleFonts.montserrat(
            color: isNext
                ? middlePurple
                : isFinished
                    ? darkGrey
                    : white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          data.time!,
          style: GoogleFonts.montserrat(
            color: isNext
                ? middlePurple
                : isFinished
                    ? darkGrey
                    : white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (isNext == false) ...[
          const SizedBox(height: 30),
          Row(
            spacing: 3,
            children: [
              Icon(
                Icons.person,
                color: isFinished == false ? white : darkGrey,
                size: 14,
              ),
              Text(
                "${data.attendance!.length} Anak Hadir",
                style: GoogleFonts.montserrat(
                  color: isFinished || isNext ? darkGrey : white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
        if (isNext == true && isFinished == false) ...[
          const SizedBox(height: 103),
        ],
        if (!isNext && !isFinished) ...[
          const SizedBox(height: 15),
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

Widget _kartuMobile({
  required BuildContext context,
  required Service data,
  bool isNext = false,
  bool isFinished = false,
}) {
  return Container(
    width: double.infinity,
    height: 206,
    padding: EdgeInsets.symmetric(
      vertical: isNext || isFinished ? 17 : 20,
      horizontal: 17,
    ),
    decoration: BoxDecoration(
      color: isFinished
          ? lightGrey
          : isNext
              ? lightPurple
              : purple,
      borderRadius: BorderRadius.circular(2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isNext
                  ? "Upcoming"
                  : isFinished
                      ? "Ended"
                      : "LIVE",
              style: GoogleFonts.montserrat(
                color: isNext
                    ? middlePurple
                    : isFinished
                        ? darkGrey
                        : white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data.name!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.montserrat(
                color: isNext
                    ? middlePurple
                    : isFinished
                        ? darkGrey
                        : white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              data.time!,
              style: GoogleFonts.montserrat(
                color: isNext
                    ? middlePurple
                    : isFinished
                        ? darkGrey
                        : white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (isNext == false) ...[
          const SizedBox(height: 30),
          Row(
            spacing: 3,
            children: [
              Icon(
                Icons.person,
                color: isFinished == false ? white : darkGrey,
                size: 14,
              ),
              Text(
                "${data.attendance!.length} Anak Hadir",
                style: GoogleFonts.montserrat(
                  color: isFinished || isNext ? darkGrey : white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
        if (!isNext && !isFinished) ...[
          const SizedBox(height: 2),
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
                  fontSize: 12,
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

Widget mobileLayout(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Jadwal Hari Ini",
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: black,
        ),
      ),
      Text(
        dateNow,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: black,
        ),
      ),
      const SizedBox(height: 16),
      BlocBuilder<TodayBloc, TodayState>(
        builder: (context, state) {
          if (state is TodayGetData) {
            return LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth;
                double cardWidth = (maxWidth / 2) - 6;
                final allData = [
                  ...state.liveData,
                  ...state.upcomingData,
                  ...state.pastData
                ];
                return Column(
                  children: List.generate(
                    (allData.length / 2).ceil(),
                    (index) {
                      int firstIndex = index * 2;
                      int secondIndex = firstIndex + 1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: cardWidth,
                              child: _kartuMobile(
                                context: context,
                                data: allData[firstIndex],
                                isNext: state.upcomingData
                                    .contains(allData[firstIndex]),
                                isFinished: state.pastData
                                    .contains(allData[firstIndex]),
                              ),
                            ),
                            if (secondIndex < allData.length)
                              SizedBox(
                                width: cardWidth,
                                child: _kartuMobile(
                                  context: context,
                                  data: allData[secondIndex],
                                  isNext: state.upcomingData
                                      .contains(allData[secondIndex]),
                                  isFinished: state.pastData
                                      .contains(allData[secondIndex]),
                                ),
                              )
                            else
                              SizedBox(width: cardWidth),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is TodayGetDataIsEmpty) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Container(
                    height: 165,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage('asset/image/jesus-with-children.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tidak ada jadwal kegiatan hari ini",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: black,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Skeletonizer(
              enabled: true,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    height: 400,
                    width: double.infinity,
                    color: lightPurple,
                  );
                },
              ),
            );
          }
        },
      )
    ],
  );
}
