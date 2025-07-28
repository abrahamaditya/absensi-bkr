import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/helper/format_date.dart';
import 'package:absensi_bkr/model/service_model.dart';
import 'package:scanning_effect/scanning_effect.dart';
import 'package:qrcode_reader_web/qrcode_reader_web.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:absensi_bkr/submenu/kegiatan_detail_submenu.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_bloc.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_event.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_bloc.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_bloc.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_event.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_state.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_event.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_bloc.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_event.dart';

class ScanMobileMenu extends StatelessWidget {
  final BuildContext parentContext;
  final Service serviceData;
  const ScanMobileMenu({
    super.key,
    required this.parentContext,
    required this.serviceData,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CameraScanAbsenBloc()
            ..add(FetchCameraScanAbsenEvent(isOpened: true)),
        ),
        BlocProvider(
          create: (_) => GetKidsByIdScanQRBloc()..add(InitIDScanQREvent()),
        ),
        BlocProvider(
          create: (_) => GetServiceByIdBloc()..add(InitServiceByIDEvent()),
        ),
        BlocProvider(
          create: (_) => TakeAttendanceBloc()..add(InitTakeAttendanceEvent()),
        ),
        BlocProvider(
          create: (_) => SelectDataAbsenBloc()
            ..add(FetchSelectDataAbsenEvent(isSelected: false)),
        ),
        BlocProvider(
          create: (_) => ToggleSwitchAbsenBloc()
            ..add(FetchToggleSwitchAbsenEvent(index: 0)),
        ),
      ],
      child: ScreenUtilInit(
        builder: (BuildContext context, Widget? child) => Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 2 / 5,
                    color: purple,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 3 / 5,
                    decoration: BoxDecoration(
                      color: black,
                      border: Border(
                        top: BorderSide(
                          color: white,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 22,
                    ),
                    child: Column(
                      children: [
                        Row(
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  try {
                                    Future.delayed(
                                        const Duration(milliseconds: 400), () {
                                      // ignore: use_build_context_synchronously
                                      parentContext
                                          .read<GetServiceByIdBloc>()
                                          .add(FetchServiceByIDEvent(
                                              serviceId: serviceData.id));
                                    });
                                    Navigator.pop(context);
                                  } catch (e) {
                                    // Handle any errors that may occur
                                  }
                                  // context.read<SelectDataAbsenBloc>().add(
                                  //     FetchSelectDataAbsenEvent(
                                  //         isSelected: false));
                                  // context
                                  //     .read<ToggleSwitchAbsenBloc>()
                                  //     .add(FetchToggleSwitchAbsenEvent(index: 0));
                                  // context
                                  //     .read<TabToggleSwitchBloc>()
                                  //     .add(FetchTabToggleSwitchEvent(index: 0));
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: purple,
                                  size: 15,
                                ),
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  serviceData.name!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: white,
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                                Row(
                                  spacing: 2,
                                  children: [
                                    Text(
                                      "${serviceData.date!} • ",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: white,
                                      ),
                                    ),
                                    Text(
                                      serviceData.time!,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 80),
                        BlocBuilder<GetKidsByIdScanQRBloc,
                            CameraScanAbsenState>(
                          builder: (context, state) {
                            if (state is GetIDScanQR) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BlocBuilder<CameraScanAbsenBloc,
                                      CameraScanAbsenState>(
                                    builder: (context, state2) {
                                      if (state2 is CameraScanAbsenTrue &&
                                          state2.isOpened == true) {
                                        return Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            border: Border.all(
                                              color: state.alreadyExist == true
                                                  ? darkGrey
                                                  : orange,
                                              width: 6,
                                            ),
                                          ),
                                          width: 325,
                                          height: 325,
                                          child: ScanningEffect(
                                            scanningColor: darkOrange,
                                            enableBorder: false,
                                            delay: Duration(microseconds: 1),
                                            duration: Duration(seconds: 3),
                                            child: QRCodeReaderSquareWidget(
                                              size: 325,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              onDetect:
                                                  (QRCodeCapture capture) {
                                                context
                                                    .read<
                                                        GetKidsByIdScanQRBloc>()
                                                    .add(FetchIDScanQREvent(
                                                        kidId: capture.raw,
                                                        serviceId:
                                                            serviceData.id));
                                              },
                                              errorBuilder: (
                                                  {required context,
                                                  required exception}) {
                                                return Container(
                                                  color: white,
                                                  width: 325,
                                                  height: 325,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    spacing: 3,
                                                    children: [
                                                      Text(
                                                        "Terjadi Kesalahan",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: orange,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Kamera tidak dapat digunakan",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: orange,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return InkWell(
                                          onTap: () {
                                            context
                                                .read<CameraScanAbsenBloc>()
                                                .add(FetchCameraScanAbsenEvent(
                                                    isOpened: true));
                                          },
                                          child: Container(
                                            width: 325,
                                            height: 325,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              color: white,
                                              border: Border.all(
                                                color: lightGrey,
                                                width: 6,
                                              ),
                                            ),
                                            child: Column(
                                              spacing: 4,
                                              children: [
                                                Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 23,
                                                  color: darkGrey,
                                                ),
                                                Text(
                                                  "Aktifkan Scanner QR ID Anak",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: darkGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    state.data.name!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: white,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  SizedBox(
                                    width: 250,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${state.data.id}",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: white,
                                          ),
                                        ),
                                        if (state.data.mobile != null)
                                          Text(
                                            " • ${state.data.mobile!}",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: white,
                                            ),
                                          ),
                                        if (state.data.grade != null)
                                          Text(
                                            " • ${state.data.grade!}",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: white,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 76),
                                  SizedBox(
                                    width: 325,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: state.alreadyExist ==
                                                    true
                                                ? () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        margin: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height -
                                                              75,
                                                        ),
                                                        backgroundColor: red,
                                                        duration: Duration(
                                                            seconds: 1),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        showCloseIcon: true,
                                                        closeIconColor: white,
                                                        content: Text(
                                                          "${state.data.name!.split(' ').first} sudah melakukan absen sebelumnya",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: white,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                : () {
                                                    final id = membuatAbsenId();
                                                    final dateNow =
                                                        ambilWaktuSekarang();

                                                    Map<String, dynamic>
                                                        dataAttendanceService =
                                                        {
                                                      '_id': id,
                                                      'kidId': state.data.id,
                                                      'kidName':
                                                          state.data.name,
                                                      'method': 'Scan QR',
                                                      'timestamp': dateNow,
                                                    };

                                                    Map<String, dynamic>
                                                        dataAttendanceKid = {
                                                      '_id': id,
                                                      'serviceId':
                                                          serviceData.id,
                                                      'serviceName':
                                                          serviceData.name,
                                                      'serviceDate':
                                                          formatJadiYYYYMMDD(
                                                              serviceData.date),
                                                      'serviceTime':
                                                          serviceData.time,
                                                      'method': 'Scan QR',
                                                      'timestamp': dateNow,
                                                    };

                                                    Map<String, dynamic>
                                                        dataAttendanceGlobalAttendance =
                                                        {
                                                      '_id': id,
                                                      'kidId': state.data.id,
                                                      'kidName':
                                                          state.data.name,
                                                      'serviceId':
                                                          serviceData.id,
                                                      'serviceName':
                                                          serviceData.name,
                                                      'serviceDate':
                                                          formatJadiYYYYMMDD(
                                                              serviceData.date),
                                                      'serviceTime':
                                                          serviceData.time,
                                                      'method': 'Scan QR',
                                                      'timestamp': dateNow,
                                                    };
                                                    try {
                                                      context
                                                          .read<
                                                              TakeAttendanceBloc>()
                                                          .add(
                                                            TakeAttendanceEvent(
                                                              kidId: state
                                                                  .data.id!,
                                                              serviceId:
                                                                  serviceData
                                                                      .id!,
                                                              dataAttendanceService:
                                                                  dataAttendanceService,
                                                              dataAttendanceKid:
                                                                  dataAttendanceKid,
                                                              dataAttendanceGlobalAttendance:
                                                                  dataAttendanceGlobalAttendance,
                                                            ),
                                                          );

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          margin:
                                                              EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                75,
                                                          ),
                                                          backgroundColor:
                                                              green,
                                                          duration: Duration(
                                                              seconds: 1),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                          showCloseIcon: true,
                                                          closeIconColor: white,
                                                          content: Text(
                                                            "${state.data.name} berhasil diabsen!",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                      context
                                                          .read<
                                                              GetKidsByIdScanQRBloc>()
                                                          .add(
                                                              InitIDScanQREvent());

                                                      context
                                                          .read<
                                                              GetServiceByIdBloc>()
                                                          .add(FetchServiceByIDEvent(
                                                              serviceId:
                                                                  serviceData
                                                                      .id));
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          margin:
                                                              EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                75,
                                                          ),
                                                          backgroundColor: red,
                                                          duration: Duration(
                                                              seconds: 1),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                          showCloseIcon: true,
                                                          closeIconColor: white,
                                                          content: Text(
                                                            "Gagal melakukan absen",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  state.alreadyExist == true
                                                      ? darkGrey
                                                      : darkOrange,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 18,
                                                horizontal: 20,
                                              ),
                                            ),
                                            child: Text(
                                              state.alreadyExist == true
                                                  ? "Sudah Absen"
                                                  : "Absen",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else if (state is CameraScanAbsenError) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BlocBuilder<CameraScanAbsenBloc,
                                      CameraScanAbsenState>(
                                    builder: (context, state2) {
                                      if (state2 is CameraScanAbsenTrue &&
                                          state2.isOpened == true) {
                                        return Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            border: Border.all(
                                              color: darkGrey,
                                              width: 6,
                                            ),
                                          ),
                                          width: 325,
                                          height: 325,
                                          child: ScanningEffect(
                                            scanningColor: darkOrange,
                                            enableBorder: false,
                                            delay: Duration(microseconds: 1),
                                            duration: Duration(seconds: 3),
                                            child: QRCodeReaderSquareWidget(
                                              size: 325,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              onDetect:
                                                  (QRCodeCapture capture) {
                                                context
                                                    .read<
                                                        GetKidsByIdScanQRBloc>()
                                                    .add(FetchIDScanQREvent(
                                                        kidId: capture.raw,
                                                        serviceId:
                                                            serviceData.id));
                                              },
                                              errorBuilder: (
                                                  {required context,
                                                  required exception}) {
                                                return Container(
                                                  color: white,
                                                  width: 325,
                                                  height: 325,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    spacing: 3,
                                                    children: [
                                                      Text(
                                                        "Terjadi Kesalahan",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: orange,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Kamera tidak dapat digunakan",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: orange,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return InkWell(
                                          onTap: () {
                                            context
                                                .read<CameraScanAbsenBloc>()
                                                .add(FetchCameraScanAbsenEvent(
                                                    isOpened: true));
                                          },
                                          child: Container(
                                            width: 325,
                                            height: 325,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              color: white,
                                              border: Border.all(
                                                color: darkGrey,
                                                width: 6,
                                              ),
                                            ),
                                            child: Column(
                                              spacing: 4,
                                              children: [
                                                Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 23,
                                                  color: darkGrey,
                                                ),
                                                Text(
                                                  "Aktifkan Scanner QR ID Anak",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: darkGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Arahkan Badge ke Scanner",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      "Posisikan QR Code anak berada di dalam area kotak scanner",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 70),
                                  SizedBox(
                                    width: 325,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: darkGrey,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 18,
                                                horizontal: 20,
                                              ),
                                            ),
                                            child: Text(
                                              "Absen",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BlocBuilder<CameraScanAbsenBloc,
                                      CameraScanAbsenState>(
                                    builder: (context, state2) {
                                      if (state2 is CameraScanAbsenTrue &&
                                          state2.isOpened == true) {
                                        return Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            border: Border.all(
                                              color: darkGrey,
                                              width: 6,
                                            ),
                                          ),
                                          width: 325,
                                          height: 325,
                                          child: ScanningEffect(
                                            scanningColor: darkOrange,
                                            enableBorder: false,
                                            delay: Duration(microseconds: 1),
                                            duration: Duration(seconds: 3),
                                            child: QRCodeReaderSquareWidget(
                                              size: 325,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              onDetect:
                                                  (QRCodeCapture capture) {
                                                context
                                                    .read<
                                                        GetKidsByIdScanQRBloc>()
                                                    .add(FetchIDScanQREvent(
                                                        kidId: capture.raw,
                                                        serviceId:
                                                            serviceData.id));
                                              },
                                              errorBuilder: (
                                                  {required context,
                                                  required exception}) {
                                                return Container(
                                                  color: white,
                                                  width: 325,
                                                  height: 325,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    spacing: 3,
                                                    children: [
                                                      Text(
                                                        "Terjadi Kesalahan",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: orange,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Kamera tidak dapat digunakan",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: orange,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return InkWell(
                                          onTap: () {
                                            context
                                                .read<CameraScanAbsenBloc>()
                                                .add(FetchCameraScanAbsenEvent(
                                                    isOpened: true));
                                          },
                                          child: Container(
                                            width: 325,
                                            height: 325,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              color: white,
                                              border: Border.all(
                                                color: lightGrey,
                                                width: 6,
                                              ),
                                            ),
                                            child: Column(
                                              spacing: 4,
                                              children: [
                                                Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 23,
                                                  color: darkGrey,
                                                ),
                                                Text(
                                                  "Aktifkan Scanner QR ID Anak",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: darkGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Arahkan Badge ke Scanner",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      "Posisikan QR Code anak berada di dalam area kotak scanner",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 70),
                                  SizedBox(
                                    width: 325,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: darkGrey,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 18,
                                                horizontal: 20,
                                              ),
                                            ),
                                            child: Text(
                                              "Absen",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
