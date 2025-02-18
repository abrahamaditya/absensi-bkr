import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/model/kid_model.dart';
import 'package:absensi_bkr/widget/anak_widget.dart';
import 'package:absensi_bkr/widget/kegiatan_menu.dart';
import 'package:absensi_bkr/widget/sidebar_widget.dart';
import 'package:absensi_bkr/widget/hari_ini_widget.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_bloc.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_bloc.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_event.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:absensi_bkr/bloc/today_bloc/today_bloc.dart';
import 'package:absensi_bkr/bloc/today_bloc/today_event.dart';
import 'package:absensi_bkr/submenu/anak_detail_submenu.dart';
import 'package:absensi_bkr/submenu/anak_ubah_data_submenu.dart';
import 'package:absensi_bkr/submenu/kegiatan_detail_submenu.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_bloc.dart';
import 'package:absensi_bkr/submenu/anak_tambah_data_submenu.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_event.dart';
import 'package:absensi_bkr/submenu/kegiatan_tambah_data_submenu.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_state.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_bloc.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_bloc.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_event.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_event.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_bloc.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_event.dart';

// Global Variable
var selectedPaginationNumberOfAllAnakPage = 1;
var selectedPaginationNumberOfAllKegiatanPage = 1;
bool tableLoadingAnak = false;
bool tableLoadingKegiatan = false;

Kid defaultKid = Kid(
  id: "-",
  name: "Pilih Data",
  birthdate: null,
  parentName: null,
  mobile: null,
  address: null,
  grade: null,
  attendance: null,
);

class MasterMenu extends StatelessWidget {
  const MasterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SidebarMenuBloc()
            ..add(FetchSidebarMenuEvent(menu: "Hari Ini", data: Object())),
        ),
        BlocProvider(
          create: (_) => ToggleSwitchAbsenBloc()
            ..add(FetchToggleSwitchAbsenEvent(index: 0)),
        ),
        BlocProvider(
          create: (_) =>
              TabToggleSwitchBloc()..add(FetchTabToggleSwitchEvent(index: 0)),
        ),
        BlocProvider(
          create: (_) => SelectDataAbsenBloc()
            ..add(FetchSelectDataAbsenEvent(isSelected: false)),
        ),
        BlocProvider(
          create: (_) => SelectInputManualDataAbsenBloc()
            ..add(InitialInputManualDataAbsenEvent()),
        ),
        BlocProvider(
          create: (_) => TakeAttendanceBloc()..add(InitTakeAttendanceEvent()),
        ),
        BlocProvider(
          create: (_) => CameraScanAbsenBloc()
            ..add(FetchCameraScanAbsenEvent(isOpened: false)),
        ),
        BlocProvider(
          create: (_) => GetKidsByIdScanQRBloc()..add(InitIDScanQREvent()),
        ),
        BlocProvider(
          create: (_) => GetServiceByIdBloc()..add(InitServiceByIDvent()),
        ),
        BlocProvider(
          create: (_) => GetServicesBloc()
            ..add(FetchServicesEvent(page: 1, searchNameQuery: "")),
        ),
        BlocProvider(
          create: (_) =>
              GetKidsBloc()..add(FetchKidsEvent(page: 1, searchNameQuery: "")),
        ),
        BlocProvider(
          create: (_) => CreateKidsBloc()..add(InitCreateKidsEvent()),
        ),
        BlocProvider(
          create: (_) => UpdateKidsBloc()..add(InitUpdateKidsEvent()),
        ),
        BlocProvider(
          create: (_) => CreateServicesBloc()..add(InitCreateServicesEvent()),
        ),
        BlocProvider(
          create: (_) => LainnyaServicesBloc()
            ..add(LainnyaServicesEvent(visibility: false)),
        ),
        BlocProvider(
          create: (_) => AuthBloc()..add(InitLoginEvent()),
        ),
        BlocProvider(
          create: (_) => TodayBloc()
            ..add(FetchTodayEvent(
                date: DateTime.now().toIso8601String().split('T')[0])),
        ),
      ],
      child: ScreenUtilInit(
        builder: (BuildContext context, Widget? child) => (screenWidth < 1000
            ? Scaffold(
                body: BlocBuilder<SidebarMenuBloc, SidebarMenuState>(
                  builder: (context, state) {
                    if (state is SidebarMenuSuccess) {
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 125,
                                      color: purple,
                                      width: double.infinity,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 25,
                                        left: 20,
                                        right: 20,
                                        bottom: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'asset/logo/logo-bkr.png',
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Absensi BKR",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: white,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Modernland",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                iconSize: 20,
                                                onPressed: () {
                                                  context.read<AuthBloc>().add(
                                                      LogoutEvent(
                                                          context: context));
                                                },
                                                icon: Icon(
                                                  Icons.logout_outlined,
                                                  color: white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 30),
                                          BlocBuilder<SidebarMenuBloc,
                                              SidebarMenuState>(
                                            builder: (context, state) {
                                              if (state is SidebarMenuSuccess) {
                                                return Row(
                                                  spacing: 14,
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          context
                                                              .read<TodayBloc>()
                                                              .add(FetchTodayEvent(
                                                                  date: DateTime
                                                                          .now()
                                                                      .toIso8601String()
                                                                      .split(
                                                                          'T')[0]));
                                                          context
                                                              .read<
                                                                  SidebarMenuBloc>()
                                                              .add(FetchSidebarMenuEvent(
                                                                  menu:
                                                                      "Hari Ini",
                                                                  data:
                                                                      Object()));
                                                        },
                                                        child: Container(
                                                          width: 75,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 10,
                                                            vertical: 15,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: state.menu!
                                                                    .startsWith(
                                                                        "Hari Ini")
                                                                ? orange
                                                                : white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                                spreadRadius: 2,
                                                                blurRadius: 5,
                                                                offset: Offset(
                                                                    0, -1),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            spacing: 2,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .flag_outlined,
                                                                color: state
                                                                        .menu!
                                                                        .startsWith(
                                                                            "Hari Ini")
                                                                    ? white
                                                                    : black,
                                                                size: 20,
                                                              ),
                                                              Text(
                                                                "Hari Ini",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  color: state
                                                                          .menu!
                                                                          .startsWith(
                                                                              "Hari Ini")
                                                                      ? white
                                                                      : black,
                                                                  fontSize: 10,
                                                                  fontWeight: state
                                                                          .menu!
                                                                          .startsWith(
                                                                              "Hari Ini")
                                                                      ? FontWeight
                                                                          .w700
                                                                      : FontWeight
                                                                          .w500,
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
                                                              .read<TodayBloc>()
                                                              .add(FetchTodayEvent(
                                                                  date: DateTime
                                                                          .now()
                                                                      .toIso8601String()
                                                                      .split(
                                                                          'T')[0]));
                                                          context
                                                              .read<
                                                                  SidebarMenuBloc>()
                                                              .add(FetchSidebarMenuEvent(
                                                                  menu:
                                                                      "Kegiatan",
                                                                  data:
                                                                      Object()));
                                                        },
                                                        child: Container(
                                                          width: 75,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 10,
                                                            vertical: 15,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: state.menu!
                                                                    .startsWith(
                                                                        "Kegiatan")
                                                                ? orange
                                                                : white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                                spreadRadius: 2,
                                                                blurRadius: 5,
                                                                offset: Offset(
                                                                    0, -1),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            spacing: 2,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .calendar_month,
                                                                color: state
                                                                        .menu!
                                                                        .startsWith(
                                                                            "Kegiatan")
                                                                    ? white
                                                                    : black,
                                                                size: 20,
                                                              ),
                                                              Text(
                                                                "Kegiatan",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  color: state
                                                                          .menu!
                                                                          .startsWith(
                                                                              "Kegiatan")
                                                                      ? white
                                                                      : black,
                                                                  fontSize: 10,
                                                                  fontWeight: state
                                                                          .menu!
                                                                          .startsWith(
                                                                              "Kegiatan")
                                                                      ? FontWeight
                                                                          .w700
                                                                      : FontWeight
                                                                          .w500,
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
                                                              .read<TodayBloc>()
                                                              .add(FetchTodayEvent(
                                                                  date: DateTime
                                                                          .now()
                                                                      .toIso8601String()
                                                                      .split(
                                                                          'T')[0]));
                                                          context
                                                              .read<
                                                                  SidebarMenuBloc>()
                                                              .add(FetchSidebarMenuEvent(
                                                                  menu: "Anak",
                                                                  data:
                                                                      Object()));
                                                        },
                                                        child: Container(
                                                          width: 75,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 10,
                                                            vertical: 15,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: state.menu!
                                                                    .startsWith(
                                                                        "Anak")
                                                                ? orange
                                                                : white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                // ignore: deprecated_member_use
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                                spreadRadius: 2,
                                                                blurRadius: 5,
                                                                offset: Offset(
                                                                    0, -1),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            spacing: 2,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .people_outlined,
                                                                color: state
                                                                        .menu!
                                                                        .startsWith(
                                                                            "Anak")
                                                                    ? white
                                                                    : black,
                                                                size: 20,
                                                              ),
                                                              Text(
                                                                "Anak",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  color: state
                                                                          .menu!
                                                                          .startsWith(
                                                                              "Anak")
                                                                      ? white
                                                                      : black,
                                                                  fontSize: 10,
                                                                  fontWeight: state
                                                                          .menu!
                                                                          .startsWith(
                                                                              "Anak")
                                                                      ? FontWeight
                                                                          .w700
                                                                      : FontWeight
                                                                          .w500,
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
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 25,
                                      left: 20,
                                      right: 20,
                                      bottom: 20,
                                    ),
                                    child: ScreensView(
                                      context: context,
                                      menu: state.menu!,
                                      data: state.data,
                                      detailKegiatanPreviousMenu:
                                          state.detailKegiatanPreviousMenu ??
                                              "",
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              )
            : Scaffold(
                body: BlocBuilder<SidebarMenuBloc, SidebarMenuState>(
                  builder: (context, state) {
                    if (state is SidebarMenuSuccess) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sidebarWidget(context, state),
                          Expanded(
                              child: ScreensView(
                            context: context,
                            menu: state.menu!,
                            data: state.data,
                            detailKegiatanPreviousMenu:
                                state.detailKegiatanPreviousMenu ?? "",
                          )),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              )),
      ),
    );
  }
}

class ScreensView extends StatelessWidget {
  final BuildContext context;
  final String menu;
  final dynamic data;
  final String detailKegiatanPreviousMenu;
  const ScreensView(
      {super.key,
      required this.context,
      required this.menu,
      this.data,
      required this.detailKegiatanPreviousMenu});
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (menu) {
      case 'Hari Ini':
        page = hariIniWidget(context);
        break;
      case 'Kegiatan':
        page = semuaKegiatanWidget(context);
        break;
      case 'Anak':
        page = semuaAnakWidget(context);
        break;
      case 'Anak Detail':
        page = detailAnakSubmenu(context, data);
        break;
      case 'Kegiatan Detail':
        page = detailKegiatanSubmenu(context, data, detailKegiatanPreviousMenu);
        break;
      case 'Kegiatan Tambah Data':
        page = kegiatanTambahDataSubmenu(context);
        break;
      case 'Anak Tambah Data':
        page = anakTambahDataSubmenu(context);
        break;
      case 'Anak Ubah Data':
        page = anakUbahDataSubmenu(context, data);
        break;
      default:
        page = Container(
          color: white,
          height: double.infinity,
          child: Center(
            child: Text(
              "Oops! Halaman tidak ditemukan.",
              style: TextStyle(
                color: darkGrey,
                fontSize: 22,
              ),
            ),
          ),
        );
    }
    return page;
  }
}
