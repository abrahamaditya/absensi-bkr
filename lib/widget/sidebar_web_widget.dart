import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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

Widget sidebarWebWidget(BuildContext context, SidebarMenuSuccess state) {
  return Container(
    width: 275,
    color: purple,
    padding: const EdgeInsets.only(
      left: 25,
      top: 35,
      bottom: 30,
    ),
    child: Padding(
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: Column(
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: InkWell(
              onTap: () {
                web.window.location.assign('/');
              },
              child: Row(
                children: [
                  Image.asset(
                    'asset/logo/logo-bkr.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Absensi BKR",
                        style: GoogleFonts.montserrat(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Modernland",
                        style: GoogleFonts.montserrat(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // context.read<TodayBloc>().add(InitTodayEvent());
                // context.read<TodayBloc>().add(FetchTodayEvent(
                //     date: DateTime.now().toIso8601String().split('T')[0]));
                // context.read<SidebarMenuBloc>().add(
                //     FetchSidebarMenuEvent(menu: "Hari Ini", data: Object()));
                // context.read<GetKidsByIdScanQRBloc>().add(InitIDScanQREvent());
                web.window.location.assign('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    state.menu!.startsWith("Hari Ini") ? white : purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    color: state.menu!.startsWith("Hari Ini") ? purple : white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Hari Ini",
                    style: GoogleFonts.montserrat(
                      color:
                          state.menu!.startsWith("Hari Ini") ? purple : white,
                      fontSize: 18,
                      fontWeight: state.menu!.startsWith("Hari Ini")
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context
                    .read<GetServicesBloc>()
                    .add(FetchServicesEvent(page: 1, searchNameQuery: ""));
                context.read<SidebarMenuBloc>().add(
                    FetchSidebarMenuEvent(menu: "Kegiatan", data: Object()));
                context.read<GetKidsByIdScanQRBloc>().add(InitIDScanQREvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    state.menu!.startsWith("Kegiatan") ? white : purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: state.menu!.startsWith("Kegiatan") ? purple : white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Kegiatan",
                    style: GoogleFonts.montserrat(
                      color:
                          state.menu!.startsWith("Kegiatan") ? purple : white,
                      fontSize: 18,
                      fontWeight: state.menu!.startsWith("Kegiatan")
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context
                    .read<GetKidsBloc>()
                    .add(FetchKidsEvent(page: 1, searchNameQuery: ""));
                context
                    .read<SidebarMenuBloc>()
                    .add(FetchSidebarMenuEvent(menu: "Anak", data: Object()));
                context.read<GetKidsByIdScanQRBloc>().add(InitIDScanQREvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    state.menu!.startsWith("Anak") ? white : purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.people_outlined,
                    color: state.menu!.startsWith("Anak") ? purple : white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Anak",
                    style: GoogleFonts.montserrat(
                      color: state.menu!.startsWith("Anak") ? purple : white,
                      fontSize: 18,
                      fontWeight: state.menu!.startsWith("Anak")
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 190,
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent(context: context));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightRed,
                  foregroundColor: red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 20,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      color: red,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Keluar",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
