import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/menu/master_menu.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_bloc.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_bloc.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_event.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_event.dart';
import 'package:absensi_bkr/bloc/today_bloc/today_bloc.dart';
import 'package:absensi_bkr/bloc/today_bloc/today_event.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_bloc.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_event.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_state.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_bloc.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_event.dart';

Widget sidebarMobileWidget(BuildContext context, SidebarMenuSuccess state) {
  return Container(
    color: white,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    color: purple,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 25,
                      left: 20,
                      right: 20,
                      bottom: 28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'asset/logo/logo-bkr.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Absensi BKR",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: white,
                                      ),
                                    ),
                                    Text(
                                      "Modernland",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              iconSize: 22,
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(LogoutEvent(context: context));
                              },
                              icon: Icon(
                                Icons.logout_outlined,
                                color: white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        BlocBuilder<SidebarMenuBloc, SidebarMenuState>(
                          builder: (context, state) {
                            if (state is SidebarMenuSuccess) {
                              return Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        context
                                            .read<TodayBloc>()
                                            .add(InitTodayEvent());
                                        context.read<TodayBloc>().add(
                                            FetchTodayEvent(
                                                date: DateTime.now()
                                                    .toIso8601String()
                                                    .split('T')[0]));
                                        context.read<SidebarMenuBloc>().add(
                                            FetchSidebarMenuEvent(
                                                menu: "Hari Ini",
                                                data: Object()));
                                        context
                                            .read<GetKidsByIdScanQRBloc>()
                                            .add(InitIDScanQREvent());
                                      },
                                      child: Container(
                                        width: 75,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              state.menu!.startsWith("Hari Ini")
                                                  ? orange
                                                  : white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(2),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, -1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.flag_outlined,
                                              color: state.menu!
                                                      .startsWith("Hari Ini")
                                                  ? white
                                                  : black,
                                              size: 24,
                                            ),
                                            Text(
                                              "Hari Ini",
                                              style: GoogleFonts.montserrat(
                                                color: state.menu!
                                                        .startsWith("Hari Ini")
                                                    ? white
                                                    : black,
                                                fontSize: 14,
                                                fontWeight: state.menu!
                                                        .startsWith("Hari Ini")
                                                    ? FontWeight.w700
                                                    : FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        context
                                            .read<GetAllServicesBloc>()
                                            .add(FetchAllServicesEvent());
                                        context.read<SidebarMenuBloc>().add(
                                            FetchSidebarMenuEvent(
                                                menu: "Kegiatan",
                                                data: Object()));
                                        context
                                            .read<GetKidsByIdScanQRBloc>()
                                            .add(InitIDScanQREvent());
                                      },
                                      child: Container(
                                        width: 75,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              state.menu!.startsWith("Kegiatan")
                                                  ? orange
                                                  : white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(2),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, -1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: state.menu!
                                                      .startsWith("Kegiatan")
                                                  ? white
                                                  : black,
                                              size: 24,
                                            ),
                                            Text(
                                              "Kegiatan",
                                              style: GoogleFonts.montserrat(
                                                color: state.menu!
                                                        .startsWith("Kegiatan")
                                                    ? white
                                                    : black,
                                                fontSize: 14,
                                                fontWeight: state.menu!
                                                        .startsWith("Kegiatan")
                                                    ? FontWeight.w700
                                                    : FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        context.read<GetKidsBloc>().add(
                                            FetchKidsEvent(
                                                page: 1, searchNameQuery: ""));
                                        context.read<SidebarMenuBloc>().add(
                                            FetchSidebarMenuEvent(
                                                menu: "Anak", data: Object()));
                                        context
                                            .read<GetKidsByIdScanQRBloc>()
                                            .add(InitIDScanQREvent());
                                      },
                                      child: Container(
                                        width: 75,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: state.menu!.startsWith("Anak")
                                              ? orange
                                              : white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(2),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, -1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.people_outlined,
                                              color:
                                                  state.menu!.startsWith("Anak")
                                                      ? white
                                                      : black,
                                              size: 24,
                                            ),
                                            Text(
                                              "Anak",
                                              style: GoogleFonts.montserrat(
                                                color: state.menu!
                                                        .startsWith("Anak")
                                                    ? white
                                                    : black,
                                                fontSize: 14,
                                                fontWeight: state.menu!
                                                        .startsWith("Anak")
                                                    ? FontWeight.w700
                                                    : FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: ScreensView(
                  context: context,
                  menu: state.menu!,
                  data: state.data,
                  detailKegiatanPreviousMenu:
                      state.detailKegiatanPreviousMenu ?? "",
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
