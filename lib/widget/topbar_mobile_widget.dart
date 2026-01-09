import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_bloc.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_bloc.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_event.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_event.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_bloc.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_event.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_state.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_bloc.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_event.dart';

Widget topbarMobileWidget(BuildContext context, SidebarMenuSuccess state) {
  return Stack(
    children: [
      Container(
        height: 140,
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
                InkWell(
                  onTap: () {
                    web.window.location.assign('/');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'asset/logo/logo-bkr.png',
                        width: 35,
                        height: 35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Absensi BKR",
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: white,
                            ),
                          ),
                          Text(
                            "Modernland",
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  iconSize: 22,
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent(context: context));
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                    color: white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            BlocBuilder<SidebarMenuBloc, SidebarMenuState>(
              builder: (context, state) {
                if (state is SidebarMenuSuccess) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // context.read<TodayBloc>().add(FetchTodayEvent(
                            //     date: DateTime.now()
                            //         .toIso8601String()
                            //         .split('T')[0]));
                            // context.read<TodayBloc>().add(InitTodayEvent());
                            // context.read<SidebarMenuBloc>().add(
                            //     FetchSidebarMenuEvent(
                            //         menu: "Hari Ini", data: Object()));
                            // context
                            //     .read<GetKidsByIdScanQRBloc>()
                            //     .add(InitIDScanQREvent());
                            web.window.location.assign('/');
                          },
                          child: Container(
                            width: 75,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: state.menu!.startsWith("Hari Ini")
                                  ? orange
                                  : white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(2),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, -1),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 2,
                              children: [
                                Icon(
                                  Icons.flag_outlined,
                                  color: state.menu!.startsWith("Hari Ini")
                                      ? white
                                      : black,
                                  size: 22,
                                ),
                                Text(
                                  "Hari Ini",
                                  style: GoogleFonts.montserrat(
                                    color: state.menu!.startsWith("Hari Ini")
                                        ? white
                                        : black,
                                    fontSize: 12,
                                    fontWeight:
                                        state.menu!.startsWith("Hari Ini")
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
                                    menu: "Kegiatan", data: Object()));
                            context
                                .read<GetKidsByIdScanQRBloc>()
                                .add(InitIDScanQREvent());
                          },
                          child: Container(
                            width: 75,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: state.menu!.startsWith("Kegiatan")
                                  ? orange
                                  : white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(2),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, -1),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 2,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: state.menu!.startsWith("Kegiatan")
                                      ? white
                                      : black,
                                  size: 22,
                                ),
                                Text(
                                  "Kegiatan",
                                  style: GoogleFonts.montserrat(
                                    color: state.menu!.startsWith("Kegiatan")
                                        ? white
                                        : black,
                                    fontSize: 12,
                                    fontWeight:
                                        state.menu!.startsWith("Kegiatan")
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
                                FetchKidsEvent(page: 1, searchNameQuery: ""));
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
                              vertical: 15,
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
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, -1),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 2,
                              children: [
                                Icon(
                                  Icons.people_outlined,
                                  color: state.menu!.startsWith("Anak")
                                      ? white
                                      : black,
                                  size: 22,
                                ),
                                Text(
                                  "Anak",
                                  style: GoogleFonts.montserrat(
                                    color: state.menu!.startsWith("Anak")
                                        ? white
                                        : black,
                                    fontSize: 12,
                                    fontWeight: state.menu!.startsWith("Anak")
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
  );
}
