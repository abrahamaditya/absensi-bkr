import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/model/kid_model.dart';
import 'package:absensi_bkr/popup/anak_qr_popup.dart';
import 'package:absensi_bkr/menu/master_menu.dart';
import 'package:absensi_bkr/helper/format_date.dart';
import 'package:absensi_bkr/model/attendance_model.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_bloc.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_event.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';

Widget detailAnakSubmenu(BuildContext context, dynamic data) {
  final kidsData = data as Kid;
  final ScrollController scrollController = ScrollController();
  final double screenWidth = MediaQuery.of(context).size.width;

  return screenWidth < 1000
      ? mobileLayout(context, kidsData)
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                context.read<GetKidsBloc>().add(FetchKidsEvent(
                                    page: 1, searchNameQuery: ""));
                                selectedPaginationNumberOfAllAnakPage = 1;
                                context.read<SidebarMenuBloc>().add(
                                    FetchSidebarMenuEvent(
                                        menu: "Anak", data: Object()));
                              },
                              icon: Icon(Icons.arrow_back, color: white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isSmallScreen = constraints.maxWidth < 700;
                          return isSmallScreen
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      kidsData.name!,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800,
                                        color: black,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return QRCodePopup(
                                                  id: kidsData.id!,
                                                  name: kidsData.name!,
                                                );
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              side: BorderSide(
                                                  color: orange, width: 1),
                                            ),
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 18,
                                              horizontal: 20,
                                            ),
                                          ),
                                          child: Text(
                                            "Lihat QR Code",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: orange,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            context.read<SidebarMenuBloc>().add(
                                                FetchSidebarMenuEvent(
                                                    menu: "Anak Ubah Data"));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              side: BorderSide(
                                                  color: orange, width: 1),
                                            ),
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 18,
                                              horizontal: 20,
                                            ),
                                          ),
                                          child: Text(
                                            "Ubah Data",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        kidsData.name!,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          color: black,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return QRCodePopup(
                                                  id: kidsData.id!,
                                                  name: kidsData.name!,
                                                );
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              side: BorderSide(
                                                  color: orange, width: 1),
                                            ),
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 18,
                                              horizontal: 20,
                                            ),
                                          ),
                                          child: Text(
                                            "Lihat QR Code",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: orange,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            context.read<SidebarMenuBloc>().add(
                                                FetchSidebarMenuEvent(
                                                    menu: "Anak Ubah Data",
                                                    data: kidsData));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              side: BorderSide(
                                                  color: orange, width: 1),
                                            ),
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 18,
                                              horizontal: 20,
                                            ),
                                          ),
                                          child: Text(
                                            "Ubah Data",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                        },
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoDetailAnak("ID", kidsData.id!, false),
                          _infoDetailAnak(
                              "Tanggal Lahir",
                              formatJadiDDMMMMYYYYIndonesia(kidsData.birthdate),
                              false),
                          _infoDetailAnak("Alamat", kidsData.address, false),
                          _infoDetailAnak("No. Hp", kidsData.mobile, false),
                          _infoDetailAnak(
                              "Nama Orang Tua", kidsData.parentName, false),
                          _infoDetailAnak("Kelas", kidsData.grade, false),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Divider(
                        color: lightGrey,
                        thickness: 1,
                      ),
                      const SizedBox(height: 25),
                      if (kidsData.attendance!.isNotEmpty) ...[
                        Wrap(
                          spacing: 2,
                          runSpacing: 0,
                          children: [
                            Text(
                              "Data Absen Kegiatan ",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: black,
                              ),
                            ),
                            Text(
                              "(Total: ${kidsData.attendance!.length} kegiatan)",
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
                                    scrollController.offset - details.delta.dx,
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
                                    child: _tabel(kidsData.attendance!, true,
                                        isMobile: false),
                                  ),
                                ),
                              )
                            : _tabel(kidsData.attendance!, false,
                                isMobile: false),
                      ] else ...[
                        Text(
                          "${kidsData.name!.split(' ').first} belum melakukan absen kegiatan apapun",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: lightGrey,
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
}

Widget _tabel(List<AttendanceKids> data, bool isSmallScreen,
    {required bool isMobile}) {
  Map<int, TableColumnWidth>? smallScreen = {
    0: FixedColumnWidth(60), // Kolom "No."
    1: FixedColumnWidth(250), // Kolom "Nama"
    2: FixedColumnWidth(300), // Kolom "Tanggal"
    3: FixedColumnWidth(250), // Kolom "Jam Absen"
  };
  Map<int, TableColumnWidth>? normalScreen = {
    0: FractionColumnWidth(0.12), // 12%
    1: FractionColumnWidth(0.33), // 33%
    2: FractionColumnWidth(0.3), // 3%
    3: FractionColumnWidth(0.25), // 25%
  };
  return Table(
    columnWidths: {
      if (isSmallScreen) ...smallScreen,
      if (!isSmallScreen) ...normalScreen,
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: purple,
        ),
        children: [
          _headerTabel("No.", isMobile),
          _headerTabel("Kegiatan", isMobile),
          _headerTabel("Tanggal", isMobile),
          _headerTabel("Jam Absen", isMobile),
        ],
      ),
      // Data Baris Tabel dari parameter "data"
      for (var i = 0; i < data.length; i++)
        _barisTabel(i + 1, data[i], isMobile), // Ambil data untuk setiap baris
    ],
  );
}

Widget _headerTabel(String title, bool isMobile) {
  return Container(
    height: isMobile == true ? 50 : 75,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
        fontSize: isMobile == true ? 10 : 14,
        fontWeight: FontWeight.w700,
        color: white,
      ),
    ),
  );
}

TableRow _barisTabel(int index, AttendanceKids absence, bool isMobile) {
  return TableRow(
    decoration: BoxDecoration(
      color: index % 2 == 0 ? fillFieldGrey : white,
    ),
    children: [
      _selTabel("$index.", isMobile, isCenter: true),
      _selTabel(absence.serviceName!, isMobile, isCenter: true),
      _selTabel(absence.serviceDate!, isMobile),
      _selTabel(formatJadiHHMMSSDariString(absence.timestamp!), isMobile),
    ],
  );
}

Widget _selTabel(String text, bool isMobile, {bool isCenter = false}) {
  return Container(
    height: 50,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
    child: Text(
      text,
      textAlign: isCenter ? TextAlign.center : TextAlign.left,
      style: GoogleFonts.montserrat(
        fontSize: isMobile == true ? 10 : 14,
        fontWeight: FontWeight.w500,
        color: black,
      ),
    ),
  );
}

Widget _infoDetailAnak(String label, String? value, bool isMobile) {
  Map<int, TableColumnWidth>? smallScreen = {
    0: FixedColumnWidth(125), // Lebar kolom pertama sesuai teks
    1: FixedColumnWidth(10), // Lebar kolom ":" tetap
    2: FlexColumnWidth(), // Kolom terakhir fleksibel
  };
  Map<int, TableColumnWidth>? normalScreen = {
    0: FixedColumnWidth(175), // Lebar kolom pertama sesuai teks
    1: FixedColumnWidth(10), // Lebar kolom ":" tetap
    2: FlexColumnWidth(), // Kolom terakhir fleksibel
  };
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Table(
      columnWidths: {
        if (isMobile) ...smallScreen,
        if (!isMobile) ...normalScreen,
      },
      children: [
        TableRow(
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: isMobile == true ? 12 : 16,
                fontWeight: FontWeight.w400,
                color: black,
              ),
            ),
            Text(
              ":",
              style: GoogleFonts.montserrat(
                fontSize: isMobile == true ? 12 : 16,
                fontWeight: FontWeight.w600,
                color: black,
              ),
            ),
            Text(
              value ?? "-",
              style: GoogleFonts.montserrat(
                fontSize: isMobile == true ? 12 : 16,
                fontWeight: FontWeight.w600,
                color: black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget mobileLayout(BuildContext context, Kid kidsData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: double.infinity,
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: purple,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  context.read<SidebarMenuBloc>().add(
                        FetchSidebarMenuEvent(menu: "Anak", data: Object()),
                      );
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: white,
                  size: 15,
                ),
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
            Flexible(
              child: Text(
                kidsData.name!,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: black,
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoDetailAnak("ID", kidsData.id!, true),
          _infoDetailAnak("Tanggal Lahir",
              formatJadiDDMMMMYYYYIndonesia(kidsData.birthdate), true),
          _infoDetailAnak("Alamat", kidsData.address, true),
          _infoDetailAnak("No. Hp", kidsData.mobile, true),
          _infoDetailAnak("Nama Orang Tua", kidsData.parentName, true),
          _infoDetailAnak("Kelas", kidsData.grade, true),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return QRCodePopup(
                          id: kidsData.id!,
                          name: kidsData.name!,
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(color: orange, width: 1),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                  ),
                  child: Text(
                    "Lihat QR Code",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10), // Space between buttons
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SidebarMenuBloc>().add(FetchSidebarMenuEvent(
                        menu: "Anak Ubah Data", data: kidsData));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(color: orange, width: 1),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                  ),
                  child: Text(
                    "Ubah Data",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 15),
      Divider(
        color: lightGrey,
        thickness: 1,
      ),
      const SizedBox(height: 10),
      if (kidsData.attendance!.isNotEmpty) ...[
        Wrap(
          spacing: 2,
          runSpacing: 0,
          children: [
            Text(
              "Data Absen Kegiatan ",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: black,
              ),
            ),
            Text(
              "(Total: ${kidsData.attendance!.length} kegiatan)",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: black,
              ),
            ),
            const SizedBox(height: 25),
            _tabel(kidsData.attendance!, false, isMobile: true),
          ],
        ),
      ] else ...[
        Center(
          child: Text(
            "${kidsData.name!.split(' ').first} belum melakukan absen kegiatan apapun",
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: lightGrey,
            ),
          ),
        ),
      ],
    ],
  );
}
