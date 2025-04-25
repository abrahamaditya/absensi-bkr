import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:absensi_bkr/helper/padding.dart';
import 'package:absensi_bkr/menu/master_menu.dart';
import 'package:absensi_bkr/helper/format_date.dart';
import 'package:absensi_bkr/model/service_model.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_bloc.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_event.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_state.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_bloc.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_bloc.dart';
import 'package:absensi_bkr/bloc/camera_scan_absen_bloc/camera_scan_absen_event.dart';
import 'package:absensi_bkr/bloc/select_data_absen_bloc/select_data_absen_event.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_bloc.dart';
import 'package:absensi_bkr/bloc/toggle_switch_absen_bloc/toggle_switch_absen_event.dart';

bool isDataActuallyThere = false;
TextEditingController namaKegiatanController = TextEditingController();

Widget semuaKegiatanWidget(BuildContext context) {
  final ScrollController scrollController = ScrollController();
  final double screenWidth = MediaQuery.of(context).size.width;

  return screenWidth < 1000
      ? mobileLayout(context)
      : Container(
          color: white,
          height: 1000,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Semua Kegiatan",
                                style: GoogleFonts.montserrat(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: black,
                                ),
                              ),
                              Text(
                                "Maret 2025 - Hari Ini",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<LainnyaServicesBloc>().add(
                                      LainnyaServicesEvent(visibility: false),
                                    );
                                context.read<SidebarMenuBloc>().add(
                                    FetchSidebarMenuEvent(
                                        menu: "Kegiatan Tambah Data",
                                        data: Object()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: orange,
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
                                  Icon(Icons.add, color: white),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Tambah Kegiatan",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: lightGrey,
                        thickness: 1,
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<GetServicesBloc, ServicesState>(
                        builder: (context, state) {
                          if (tableLoadingAnak == false) {
                            tableLoadingAnak = true;
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
                                        "Total Data: ",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      Text(
                                        "0 dari 00 kegiatan",
                                        style: TextStyle(fontSize: 22),
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
                          } else if (state is ServicesGetData) {
                            isDataActuallyThere = true;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.spaceBetween,
                                  spacing: 2,
                                  runSpacing: 0,
                                  children: [
                                    Wrap(
                                      children: [
                                        Text(
                                          "Total Data: ",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: black,
                                          ),
                                        ),
                                        Text(
                                          "${state.data.length} dari ${state.totalData} kegiatan",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: black,
                                          ),
                                        ),
                                      ],
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
                                            child: _tabel(
                                                context,
                                                state.data,
                                                selectedPaginationNumberOfAllKegiatanPage,
                                                true),
                                          ),
                                        ),
                                      )
                                    : _tabel(
                                        context,
                                        state.data,
                                        selectedPaginationNumberOfAllKegiatanPage,
                                        false),
                                SizedBox(height: 20),
                                NumberPagination(
                                  onPageChanged: (int pageNumber) {
                                    selectedPaginationNumberOfAllKegiatanPage =
                                        pageNumber;
                                    context.read<GetServicesBloc>().add(
                                          FetchServicesEvent(
                                            page:
                                                selectedPaginationNumberOfAllKegiatanPage,
                                            searchNameQuery:
                                                namaKegiatanController.text,
                                          ),
                                        );
                                  },
                                  visiblePagesCount: state.totalPage,
                                  totalPages: state.totalPage,
                                  currentPage:
                                      selectedPaginationNumberOfAllKegiatanPage,
                                  selectedButtonColor: purple,
                                  fontFamily: "Montserrat",
                                  fontSize: 14,
                                  buttonRadius: 2,
                                  buttonElevation: 0,
                                  betweenNumberButtonSpacing: 1,
                                  controlButtonSize: Size(30, 34),
                                  numberButtonSize: Size(30, 34),
                                  buttonSelectedBorderColor: purple,
                                  buttonUnSelectedBorderColor: lightGrey,
                                  controlButtonColor: lightPurple,
                                  firstPageIcon: Icon(
                                    Icons.keyboard_double_arrow_left,
                                    size: 15,
                                    color: black,
                                  ),
                                  lastPageIcon: Icon(
                                    Icons.keyboard_double_arrow_right,
                                    size: 15,
                                    color: black,
                                  ),
                                  nextPageIcon: Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 15,
                                    color: black,
                                  ),
                                  previousPageIcon: Icon(
                                    Icons.keyboard_arrow_left,
                                    size: 15,
                                    color: black,
                                  ),
                                ),
                              ],
                            );
                          } else if (state is ServicesGetDataIsEmpty) {
                            if (isDataActuallyThere == false) {
                              return Center(
                                child: Text(
                                  "Data kegiatan tidak ditemukan.",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: lightGrey,
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: Text(
                                  "Data kegiatan tidak ditemukan.",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: lightGrey,
                                  ),
                                ),
                              );
                            }
                          } else {
                            return SizedBox.shrink();
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

Widget _tabel(BuildContext context, List<Service> data, int currentPage,
    bool isSmallScreen) {
  Map<int, TableColumnWidth>? smallScreen = {
    0: FixedColumnWidth(60), // Kolom "No."
    1: FixedColumnWidth(190), // Kolom "Kegiatan"
    2: FixedColumnWidth(90), // Kolom "Waktu"
    3: FixedColumnWidth(240), // Kolom "Tanggal"
    4: FixedColumnWidth(130), // Kolom "Jumlah Anak"
    5: FixedColumnWidth(175), // Kolom "Aksi"
  };
  Map<int, TableColumnWidth>? normalScreen = {
    0: FractionColumnWidth(0.065), // 6,5%
    1: FractionColumnWidth(0.23), // 23%
    2: FractionColumnWidth(0.12), // 12%
    3: FractionColumnWidth(0.285), // 28,5%
    4: FractionColumnWidth(0.12), // 12%
    5: FractionColumnWidth(0.18), // 18%
  };
  return Table(
    columnWidths: {
      if (isSmallScreen) ...smallScreen,
      if (!isSmallScreen) ...normalScreen,
    },
    children: [
      TableRow(
        decoration: BoxDecoration(color: purple),
        children: [
          _headerTabel(context, "No."),
          _headerTabel(context, "Kegiatan"),
          _headerTabel(context, "Waktu"),
          _headerTabel(context, "Tanggal"),
          _headerTabel(context, "Jumlah Anak"),
          _headerTabel(context, ""),
        ],
      ),
      // Data Baris Tabel
      for (var i = 0; i < data.length; i++)
        _barisTabel(
          context,
          ((currentPage - 1) * 20) + (i + 1), // Perhitungan nomor
          data[i],
        ), // Ambil data[i] untuk setiap baris
    ],
  );
}

Widget _headerTabel(BuildContext context, title) {
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

TableRow _barisTabel(BuildContext context, int index, Service service) {
  return TableRow(
    decoration: BoxDecoration(
      color: index % 2 == 0 ? fillFieldGrey : white,
    ),
    children: [
      _selTabel("$index.", isCenter: true),
      _selTabel(service.name!),
      _selTabel(service.time!),
      _selTabel(service.date!),
      _selTabel(service.attendance!.length.toString()),
      _selTabel(
        service.attendance!.length.toString(),
        action: SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              context
                  .read<GetServiceByIdBloc>()
                  .add(FetchServiceByIDEvent(serviceId: service.id));
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
                  data: service,
                  detailKegiatanPreviousMenu: "Kegiatan"));
            },
            style: TextButton.styleFrom(
              foregroundColor: orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              "Lihat Daftar Absen",
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: orange,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _selTabel(String text, {bool isCenter = false, Widget? action}) {
  return Container(
    height: 45,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
    child: action ??
        Text(
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

Widget mobileLayout(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Semua Kegiatan",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: black,
                ),
              ),
              Text(
                "12 Januari 2025 - Hari Ini",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: black,
                ),
              ),
            ],
          ),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                context.read<LainnyaServicesBloc>().add(
                      LainnyaServicesEvent(visibility: false),
                    );
                context.read<SidebarMenuBloc>().add(FetchSidebarMenuEvent(
                    menu: "Kegiatan Tambah Data", data: Object()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 14,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.add,
                    color: white,
                    size: 12,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Tambah Kegiatan",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 2),
      BlocBuilder<GetAllServicesBloc, ServicesState>(
        builder: (context, state) {
          if (tableLoadingAnak == false) {
            tableLoadingAnak = true;
            return Skeletonizer(
              enabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(2, (index) {
                  return Column(
                    children: [
                      if (index == 0) const SizedBox(height: 22),
                      Container(
                        height: 15,
                        width: double.infinity,
                        color: lightGrey,
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(2, (_) {
                        return Column(
                          children: [
                            Container(
                              height: 75,
                              width: double.infinity,
                              color: lightGrey,
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      }),
                      if (index < 2) const SizedBox(height: 12),
                    ],
                  );
                }).expand((widget) => widget.children).toList(),
              ),
            );
          } else if (state is ServicesGetAllData) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 250,
              child: GroupedListView<Service, String>(
                elements: state.data,
                groupBy: (Service element) {
                  return element.date!;
                },
                groupComparator: (value1, value2) {
                  DateFormat dateFormat =
                      DateFormat('EEEE, d MMMM yyyy', 'id_ID');
                  DateTime date1 = dateFormat.parse(value1);
                  DateTime date2 = dateFormat.parse(value2);
                  return date2
                      .compareTo(date1); // Tanggal paling baru muncul pertama
                },
                itemComparator: (item1, item2) {
                  DateFormat timeFormat = DateFormat('HH:mm');
                  DateTime time1 = timeFormat.parse(item1.time!);
                  DateTime time2 = timeFormat.parse(item2.time!);
                  return time2
                      .compareTo(time1); // Urutkan dari waktu yang paling pagi
                },
                order: GroupedListOrder.ASC, // Urutkan grup dari yang terbaru
                useStickyGroupSeparators: true,
                groupSeparatorBuilder: (String value) => Container(
                  padding: EdgeInsets.only(top: 20, bottom: 8),
                  color: white,
                  child: Row(
                    children: [
                      Text(
                        formatAwalanAngka(value),
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: black,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: black,
                          thickness: 0.25,
                          indent: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, Service element) {
                  final DateTime serviceTime =
                      formatTimestamp(element.date!, element.time!);
                  final DateTime now = DateTime.now();
                  return Column(
                    children: [
                      _kartuMobile(
                        context: context,
                        data: element,
                        isNext: serviceTime.difference(now).inMinutes > 29,
                        isFinished: now.difference(serviceTime).inMinutes > 89,
                      ),
                      SizedBox(height: 7),
                    ],
                  );
                },
              ),
            );
          } else if (state is ServicesGetAllDataIsEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Text(
                  "Data kegiatan tidak ditemukan.",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: lightGrey,
                  ),
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    ],
  );
}

Widget _kartuMobile({
  required BuildContext context,
  required Service data,
  bool isNext = false,
  bool isFinished = false,
}) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {
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
            detailKegiatanPreviousMenu: "Kegiatan"));
      },
      child: Container(
        width: double.infinity,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                  ],
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
                    fontSize: 16,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (isNext == false) ...[
                  Row(
                    spacing: 3,
                    children: [
                      Icon(
                        Icons.person,
                        color: isFinished == false ? white : darkGrey,
                        size: 12,
                      ),
                      Text(
                        "${data.attendance!.length} Anak Hadir",
                        style: GoogleFonts.montserrat(
                          color: isFinished || isNext ? darkGrey : white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isFinished == false ? (isNext ? purple : white) : darkGrey,
              size: 16,
            ),
          ],
        ),
      ),
    ),
  );
}
