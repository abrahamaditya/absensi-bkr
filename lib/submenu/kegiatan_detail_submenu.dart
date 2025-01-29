import 'dart:math';
import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:absensi_bkr/model/kid_model.dart';
import 'package:absensi_bkr/menu/master_menu.dart';
import 'package:absensi_bkr/helper/format_date.dart';
import 'package:absensi_bkr/model/service_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:absensi_bkr/service/kids_service.dart';
import 'package:absensi_bkr/model/attendance_model.dart';
import 'package:qrcode_reader_web/qrcode_reader_web.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_bloc.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_state.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_event.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_bloc.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_bloc.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_event.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_state.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_event.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_state.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_bloc.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_state.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_event.dart';

final KidsService _kidsService = KidsService();

Kid selected = Kid(
  id: "-",
  name: "Pilih Data",
  birthdate: null,
  parentName: null,
  mobile: null,
  address: null,
  grade: null,
  attendance: null,
);

Widget detailKegiatanSubmenu(
    BuildContext context, dynamic data, String previousMenu) {
  final serviceData = data as Service;
  final ScrollController scrollController = ScrollController();
  final double screenWidth = MediaQuery.of(context).size.width;
  final dropDownKey = GlobalKey<DropdownSearchState>();

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
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: purple,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      context.read<SidebarMenuBloc>().add(FetchSidebarMenuEvent(
                          menu: previousMenu == "Kegiatan"
                              ? "Kegiatan"
                              : "Hari Ini",
                          data: Object()));
                    },
                    icon: Icon(Icons.arrow_back, color: white),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  serviceData.name!,
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: black,
                  ),
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 2,
                  runSpacing: 0,
                  children: [
                    Text(
                      "${serviceData.date!} • ",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: black,
                      ),
                    ),
                    Text(
                      serviceData.time!,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: black,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: lightGrey,
                  thickness: 1,
                ),
                const SizedBox(height: 15),
                if (_apakahKegiatannyaItuBisaAbsenAtauLive(
                    formatJadiYYYYMMDD(serviceData.date!),
                    serviceData.time!)) ...[
                  BlocBuilder<TabToggleSwitchBloc, ToggleSwitchAbsenState>(
                    builder: (context, state) {
                      if (state is TabToggleSwitch) {
                        return Row(
                          spacing: 6,
                          children: [
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22, vertical: 12),
                                decoration: BoxDecoration(
                                  color: state.index == 0 ? orange : lightGrey,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Absen melalui:",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: state.index == 0
                                              ? white
                                              : darkGrey,
                                        ),
                                      ),
                                      Text(
                                        "Scan QR Code",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: state.index == 0
                                              ? white
                                              : darkGrey,
                                        ),
                                      ),
                                    ]),
                              ),
                              onTap: () {
                                selected = defaultKid;
                                context
                                    .read<SelectInputManualDataAbsenBloc>()
                                    .add(InitialInputManualDataAbsenEvent());
                                context.read<SelectDataAbsenBloc>().add(
                                    FetchSelectDataAbsenEvent(
                                        isSelected: false));
                                context.read<CameraScanAbsenBloc>().add(
                                    FetchCameraScanAbsenEvent(isOpened: false));
                                context
                                    .read<ToggleSwitchAbsenBloc>()
                                    .add(FetchToggleSwitchAbsenEvent(index: 0));
                                context
                                    .read<TabToggleSwitchBloc>()
                                    .add(FetchTabToggleSwitchEvent(index: 0));
                              },
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22, vertical: 12),
                                decoration: BoxDecoration(
                                  color: state.index == 1 ? orange : lightGrey,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Absen melalui:",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: state.index == 1
                                              ? white
                                              : darkGrey,
                                        ),
                                      ),
                                      Text(
                                        "Input Manual",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: state.index == 1
                                              ? white
                                              : darkGrey,
                                        ),
                                      ),
                                    ]),
                              ),
                              onTap: () {
                                selected = defaultKid;
                                context
                                    .read<SelectInputManualDataAbsenBloc>()
                                    .add(InitialInputManualDataAbsenEvent());
                                context.read<SelectDataAbsenBloc>().add(
                                    FetchSelectDataAbsenEvent(
                                        isSelected: false));
                                context.read<CameraScanAbsenBloc>().add(
                                    FetchCameraScanAbsenEvent(isOpened: false));
                                context
                                    .read<ToggleSwitchAbsenBloc>()
                                    .add(FetchToggleSwitchAbsenEvent(index: 1));
                                context
                                    .read<TabToggleSwitchBloc>()
                                    .add(FetchTabToggleSwitchEvent(index: 1));
                              },
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  BlocBuilder<ToggleSwitchAbsenBloc, ToggleSwitchAbsenState>(
                    builder: (context, state) {
                      if (state is ToggleSwitchAbsenScanQRCode) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(2),
                              bottomLeft: Radius.circular(2),
                              bottomRight: Radius.circular(2),
                            ),
                            gradient: LinearGradient(
                              colors: [orange, lightOrange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<CameraScanAbsenBloc,
                                      CameraScanAbsenState>(
                                  builder: (context, state) {
                                if (state is CameraScanAbsenTrue &&
                                    state.isOpened == true) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          context
                                              .read<CameraScanAbsenBloc>()
                                              .add(FetchCameraScanAbsenEvent(
                                                  isOpened: false));
                                          context
                                              .read<GetKidsByIdScanQRBloc>()
                                              .add(InitIDScanQREvent());
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.close,
                                              size: 22,
                                              color: white,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Nonaktifkan Kamera",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border: Border.all(
                                            color: darkOrange,
                                            width: 7,
                                          ),
                                        ),
                                        width: 300,
                                        height: 300,
                                        child: QRCodeReaderSquareWidget(
                                          size: 300,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          onDetect: (QRCodeCapture capture) {
                                            context
                                                .read<GetKidsByIdScanQRBloc>()
                                                .add(FetchIDScanQREvent(
                                                    kidId: capture.raw));
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      context.read<CameraScanAbsenBloc>().add(
                                          FetchCameraScanAbsenEvent(
                                              isOpened: true));
                                    },
                                    child: Container(
                                      width: 300,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: white,
                                        border: Border.all(
                                          color: darkOrange,
                                          width: 7,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 5,
                                        children: [
                                          Icon(
                                            Icons.camera_alt_outlined,
                                            size: 36,
                                            color: darkGrey,
                                          ),
                                          Text(
                                            "Scan Code ID Anak",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: darkGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }),
                              BlocBuilder<GetKidsByIdScanQRBloc,
                                  CameraScanAbsenState>(
                                builder: (context, state) {
                                  if (state is GetIDScanQR) {
                                    return SizedBox(
                                      width: 500,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 35),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 20,
                                              right: 10,
                                              bottom: 5,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _infoDetailKegiatan(
                                                    "Nama", state.data.name),
                                                _infoDetailKegiatan(
                                                    "ID", state.data.id),
                                                _infoDetailKegiatan("No. Hp",
                                                    state.data.mobile),
                                                _infoDetailKegiatan(
                                                    "Kelas", state.data.grade),
                                                SizedBox(height: 20),
                                                ElevatedButton(
                                                  onPressed: () {
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
                                                          backgroundColor:
                                                              green,
                                                          duration: Duration(
                                                              seconds: 3),
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
                                                              fontSize: 16,
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
                                                              CameraScanAbsenBloc>()
                                                          .add(
                                                              FetchCameraScanAbsenEvent(
                                                                  isOpened:
                                                                      false));
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
                                                          backgroundColor: red,
                                                          duration: Duration(
                                                              seconds: 3),
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
                                                              fontSize: 16,
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: darkOrange,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                    ),
                                                    elevation: 0,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 18,
                                                      horizontal: 20,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Absen",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      } else if (state is ToggleSwitchAbsenManual) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              colors: [orange, lightOrange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 50,
                                child: DropdownSearch<Kid>(
                                  key: dropDownKey,
                                  enabled: true,
                                  onChanged: (value) {
                                    selected = value!;
                                    context.read<SelectDataAbsenBloc>().add(
                                        FetchSelectDataAbsenEvent(
                                            isSelected: true));
                                    context
                                        .read<SelectInputManualDataAbsenBloc>()
                                        .add(
                                            FetchSelectInputManualDataAbsenEvent(
                                                selectedKid: selected));
                                  },
                                  selectedItem: selected,
                                  itemAsString: (item) {
                                    return item.name!;
                                  },
                                  compareFn: (item1, item2) {
                                    return item1.id == item2.id;
                                  },
                                  items: (filter, loadProps) async {
                                    final kids =
                                        await _kidsService.ambilSemuaDataAnak();
                                    return kids;
                                  },
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      suffixIconColor: darkGrey,
                                      filled: true,
                                      fillColor: white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          4,
                                        ),
                                        borderSide: BorderSide(
                                          color: darkOrange,
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide(
                                          color: darkOrange,
                                          width: 0.75,
                                        ),
                                      ),
                                    ),
                                  ),
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                    emptyBuilder: (context, searchEntry) {
                                      return SizedBox(
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            "Data anak tidak ditemukan",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: orange,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    searchFieldProps: TextFieldProps(
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: black,
                                      ),
                                      cursorColor: black,
                                      decoration: InputDecoration(
                                        hintText: "Cari ID atau Nama Anak",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        filled: true,
                                        fillColor: white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: BorderSide(
                                            color: darkOrange,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: BorderSide(
                                            color: darkOrange,
                                            width: 0.5,
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                          maxHeight: 45,
                                        ),
                                      ),
                                    ),
                                    itemBuilder: (context, item, isDisabled,
                                        isSelected) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          color: white,
                                        ),
                                        child: Row(
                                          spacing: 5,
                                          children: [
                                            Flexible(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: item.name,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " [ID: ${item.id}]",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              BlocBuilder<SelectInputManualDataAbsenBloc,
                                  SelectDataAbsenState>(
                                builder: (context, state) {
                                  if (state is SelectInputManualDataAbsen) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 0,
                                            top: 15,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _infoDetailKegiatan("Nama",
                                                  state.selectedKid.name),
                                              _infoDetailKegiatan(
                                                  "ID", state.selectedKid.id),
                                              _infoDetailKegiatan("No. Hp",
                                                  state.selectedKid.mobile),
                                              _infoDetailKegiatan("Kelas",
                                                  state.selectedKid.grade),
                                              SizedBox(height: 20),
                                              ElevatedButton(
                                                onPressed: () {
                                                  final id = membuatAbsenId();
                                                  final dateNow =
                                                      ambilWaktuSekarang();

                                                  Map<String, dynamic>
                                                      dataAttendanceService = {
                                                    '_id': id,
                                                    'kidId':
                                                        state.selectedKid.id,
                                                    'kidName':
                                                        state.selectedKid.name,
                                                    'method': 'Manual',
                                                    'timestamp': dateNow,
                                                  };

                                                  Map<String, dynamic>
                                                      dataAttendanceKid = {
                                                    '_id': id,
                                                    'serviceId': serviceData.id,
                                                    'serviceName':
                                                        serviceData.name,
                                                    'serviceDate':
                                                        formatJadiYYYYMMDD(
                                                            serviceData.date),
                                                    'serviceTime':
                                                        serviceData.time,
                                                    'method': 'Manual',
                                                    'timestamp': dateNow,
                                                  };

                                                  Map<String, dynamic>
                                                      dataAttendanceGlobalAttendance =
                                                      {
                                                    '_id': id,
                                                    'kidId':
                                                        state.selectedKid.id,
                                                    'kidName':
                                                        state.selectedKid.name,
                                                    'serviceId': serviceData.id,
                                                    'serviceName':
                                                        serviceData.name,
                                                    'serviceDate':
                                                        formatJadiYYYYMMDD(
                                                            serviceData.date),
                                                    'serviceTime':
                                                        serviceData.time,
                                                    'method': 'Manual',
                                                    'timestamp': dateNow,
                                                  };
                                                  try {
                                                    context
                                                        .read<
                                                            TakeAttendanceBloc>()
                                                        .add(
                                                          TakeAttendanceEvent(
                                                            kidId: state
                                                                .selectedKid
                                                                .id!,
                                                            serviceId:
                                                                serviceData.id!,
                                                            dataAttendanceService:
                                                                dataAttendanceService,
                                                            dataAttendanceKid:
                                                                dataAttendanceKid,
                                                            dataAttendanceGlobalAttendance:
                                                                dataAttendanceGlobalAttendance,
                                                          ),
                                                        );

                                                    context
                                                        .read<
                                                            GetServiceByIdBloc>()
                                                        .add(
                                                            FetchServiceByIDEvent(
                                                                serviceId:
                                                                    serviceData
                                                                        .id));

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor: green,
                                                        duration: Duration(
                                                            seconds: 3),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        showCloseIcon: true,
                                                        closeIconColor: white,
                                                        content: Text(
                                                          "${state.selectedKid.name} berhasil diabsen!",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: white,
                                                          ),
                                                        ),
                                                      ),
                                                    );

                                                    selected = defaultKid;
                                                    dropDownKey.currentState!
                                                        .changeSelectedItem(
                                                            selected);

                                                    context
                                                        .read<
                                                            SelectInputManualDataAbsenBloc>()
                                                        .add(
                                                            InitialInputManualDataAbsenEvent());
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor: red,
                                                        duration: Duration(
                                                            seconds: 3),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        showCloseIcon: true,
                                                        closeIconColor: white,
                                                        content: Text(
                                                          "Gagal melakukan absen",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: white,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: darkOrange,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                  ),
                                                  elevation: 0,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 18,
                                                    horizontal: 20,
                                                  ),
                                                ),
                                                child: Text(
                                                  "Absen",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: white,
                                                  ),
                                                ),
                                              ),
                                            ],
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
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                ],
                const SizedBox(height: 5),
                BlocBuilder<GetServiceByIdBloc, ServicesState>(
                  builder: (context, state) {
                    if (state is GetDataByID &&
                        state.data.attendance!.isEmpty &&
                        _apakahKegiatannyaItuBisaAbsenAtauLive(
                                formatJadiYYYYMMDD(serviceData.date!),
                                serviceData.time!) ==
                            false) {
                      return Text(
                        "Tidak ada data absen",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: lightGrey,
                        ),
                      );
                    }
                    if (state is GetDataByID) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 2,
                            runSpacing: 0,
                            children: [
                              Text(
                                "Daftar Nama Absen ",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: black,
                                ),
                              ),
                              Text(
                                "(Total: ${state.data.attendance!.length} anak)",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          screenWidth < 1200
                              ? GestureDetector(
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
                                      child:
                                          _tabel(state.data.attendance!, true),
                                    ),
                                  ),
                                )
                              : _tabel(state.data.attendance!, false)
                        ],
                      );
                    } else {
                      return Skeletonizer(
                        enabled: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 2,
                              runSpacing: 0,
                              children: [
                                Text(
                                  "Daftar Nama Absen ",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: black,
                                  ),
                                ),
                                Text(
                                  "(Total:          anak)",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Container(
                              height: 400,
                              width: double.infinity,
                              color: lightGrey,
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

Widget _tabel(List<AttendanceService> data, bool isSmallScreen) {
  Map<int, TableColumnWidth>? smallScreen = {
    0: FixedColumnWidth(60), // Kolom "No."
    1: FixedColumnWidth(300), // Kolom "Nama"
    2: FixedColumnWidth(250), // Kolom "Waktu Absen Masuk"
    3: FixedColumnWidth(250), // Kolom "Metode Absen"
  };
  Map<int, TableColumnWidth>? normalScreen = {
    0: FractionColumnWidth(0.065), // 6,5%
    1: FractionColumnWidth(0.4), // 40%
    2: FractionColumnWidth(0.3), // 30%
    3: FractionColumnWidth(0.235), // 23,5%
  };
  return Table(
    columnWidths: {
      if (isSmallScreen) ...smallScreen,
      if (!isSmallScreen) ...normalScreen,
    },
    children: [
      TableRow(
        decoration:
            BoxDecoration(color: data.isNotEmpty == true ? purple : lightGrey),
        children: [
          _headerTabel("No."),
          _headerTabel("Nama"),
          _headerTabel("Waktu Absen Masuk"),
          _headerTabel("Metode Absen"),
        ],
      ),
      // Data Baris Tabel dari parameter "data"
      for (var i = 0; i < data.length; i++)
        _barisTabel(i + 1, data[i]), // Ambil data untuk setiap baris
    ],
  );
}

Widget _headerTabel(String title) {
  return Container(
    height: 75,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: white,
      ),
    ),
  );
}

TableRow _barisTabel(int index, AttendanceService attendance) {
  return TableRow(
    decoration: BoxDecoration(
      color: index % 2 == 0 ? fillFieldGrey : white,
    ),
    children: [
      _selTabel("$index.", isCenter: true),
      _selTabel(attendance.kidsName!),
      _selTabel(formatJadiHHMMSSDariString(attendance.timestamp!)),
      _selTabel(attendance.method!),
    ],
  );
}

Widget _selTabel(String text, {bool isCenter = false}) {
  return Container(
    height: 45,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
    child: Text(
      text,
      textAlign: isCenter ? TextAlign.center : TextAlign.left,
      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: black,
      ),
    ),
  );
}

Widget _infoDetailKegiatan(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Table(
      columnWidths: const {
        0: FixedColumnWidth(95), // Lebar kolom pertama sesuai teks
        1: FixedColumnWidth(15), // Lebar kolom ":" tetap
        3: FlexColumnWidth(), // Kolom terakhir fleksibel
      },
      children: [
        TableRow(
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: white,
              ),
            ),
            Text(
              ":",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: white,
              ),
            ),
            Text(
              value ?? "-",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: white,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

bool _apakahKegiatannyaItuBisaAbsenAtauLive(String date, String time) {
  try {
    // Format date dan time digabung menjadi satu DateTime
    final dateTime = DateTime.parse('$date $time:00');

    // Rentang waktu absen (30 menit sebelum dan 1 jam 30 menit setelah waktu kegiatan)
    final startTime = dateTime.subtract(Duration(minutes: 30));
    final endTime = dateTime.add(Duration(hours: 1, minutes: 30));

    // Gunakan waktu sekarang
    final now = DateTime.now();
    //final now = DateTime.parse('2025-01-16 09:30:00.001');

    return now.isAfter(startTime) && now.isBefore(endTime);
  } catch (e) {
    return false;
  }
}

String membuatAbsenId() {
  final random = Random();

  // Generate 4 random uppercase letters
  String letters = String.fromCharCodes(
      Iterable.generate(4, (_) => random.nextInt(26) + 65));

  // Generate 4 random numbers
  String firstNum = random.nextInt(10000).toString().padLeft(4, '0');
  String secondNum = random.nextInt(10000).toString().padLeft(4, '0');

  return '$letters-$firstNum-$secondNum';
}
