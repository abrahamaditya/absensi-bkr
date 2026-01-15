import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/model/kid_model.dart';
import 'package:absensi_bkr/menu/master_menu.dart';
import 'package:absensi_bkr/helper/format_date.dart';
import 'package:absensi_bkr/popup/anak_qr_popup.dart';
import 'package:absensi_bkr/model/attendance_model.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_bloc.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_event.dart';
import 'package:absensi_bkr/popup/delete_confirmation_anak_popup.dart';
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
                                    SelectionArea(
                                      child: Text(
                                        kidsData.name!,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          color: black,
                                        ),
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
                                            "Ubah Data Anak",
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
                                      child: SelectionArea(
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
                                            "Ubah Data Anak",
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
                              kidsData.birthdate == null ||
                                      kidsData.birthdate!.isEmpty
                                  ? null
                                  : formatJadiDDMMMMYYYYIndonesia(
                                      kidsData.birthdate),
                              false),
                          _infoDetailAnak("Alamat", kidsData.address, false),
                          _infoDetailAnak("No. Hp", kidsData.mobile, false),
                          _infoDetailAnak(
                              "Nama Orang Tua", kidsData.parentName, false),
                          _infoDetailAnak("Sekolah", kidsData.school, false),
                          _infoDetailAnak("Kelas", kidsData.grade, false),
                          const SizedBox(height: 3),
                          Divider(
                            color: lightGrey,
                            thickness: 1,
                          ),
                          const SizedBox(height: 10),
                          _infoDetailStatusDataAnak(
                            context: context,
                            label: "Kelengkapan Data",
                            value: kidsData.isDataComplete.toString(),
                            kidsData: kidsData,
                            isMobile: false,
                          ),
                          _infoDetailStatusDataAnak(
                            context: context,
                            label: "Status Cetak Badge",
                            value: kidsData.isPrinted.toString(),
                            kidsData: kidsData,
                            isMobile: false,
                          ),
                          Visibility(
                            visible: kidsData.isPrinted == false ? false : true,
                            child: _infoDetailStatusDataAnak(
                              context: context,
                              label: "Status Pengambilan Badge",
                              value: kidsData.isDelivered.toString(),
                              kidsData: kidsData,
                              isMobile: false,
                            ),
                          ),
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
    0: FixedColumnWidth(150), // Lebar kolom pertama sesuai teks
    1: FixedColumnWidth(10), // Lebar kolom ":" tetap
    2: FlexColumnWidth(), // Kolom terakhir fleksibel
  };
  Map<int, TableColumnWidth>? normalScreen = {
    0: FixedColumnWidth(250), // Lebar kolom pertama sesuai teks
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
            SelectionArea(
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: isMobile == true ? 12 : 16,
                  fontWeight: FontWeight.w400,
                  color: black,
                ),
              ),
            ),
            SelectionArea(
              child: Text(
                ":",
                style: GoogleFonts.montserrat(
                  fontSize: isMobile == true ? 12 : 16,
                  fontWeight: FontWeight.w600,
                  color: black,
                ),
              ),
            ),
            SelectionArea(
              child: Text(
                (value == null || value.isEmpty) ? "-" : value,
                style: GoogleFonts.montserrat(
                  fontSize: isMobile == true ? 12 : 16,
                  fontWeight: FontWeight.w600,
                  color: black,
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );
}

Widget _infoDetailStatusDataAnak({
  required BuildContext context,
  required String label,
  required String? value,
  required bool isMobile,
  required Kid kidsData,
}) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      bool isTrue = value?.toLowerCase() == "true";
      String displayValue = "-";
      Color bgColor = white;
      Color labelTextColor = black;

      // 1. Logika Khusus Kelengkapan Data
      if (label == "Kelengkapan Data") {
        // 1. Cek apakah semua field utama (selain school) sudah terisi
        bool isOtherFieldsFilled = (kidsData.id?.trim().isNotEmpty ?? false) &&
            (kidsData.id?.trim() != "-") &&
            (kidsData.birthdate?.trim().isNotEmpty ?? false) &&
            (kidsData.birthdate?.trim() != "-") &&
            (kidsData.address?.trim().isNotEmpty ?? false) &&
            (kidsData.address?.trim() != "-") &&
            (kidsData.mobile?.trim().isNotEmpty ?? false) &&
            (kidsData.mobile?.trim() != "-") &&
            (kidsData.parentName?.trim().isNotEmpty ?? false) &&
            (kidsData.parentName?.trim() != "-") &&
            (kidsData.grade?.trim().isNotEmpty ?? false) &&
            (kidsData.grade?.trim() != "-");

        // 2. Cek apakah school terisi
        bool isSchoolFilled = (kidsData.school?.trim().isNotEmpty ?? false) &&
            (kidsData.school?.trim() != "-");

        if (isOtherFieldsFilled) {
          if (isSchoolFilled) {
            // Poin 2: Field lain ada + School ada = Lengkap
            displayValue = "Data Lengkap";
          } else {
            // Poin 3: Field lain ada + School kosong = Cukup Lengkap
            displayValue = "Data Cukup Lengkap";
          }
          bgColor = Colors.green.shade100;
          labelTextColor = Colors.green.shade800;
        } else {
          // Poin 4: Field lain ada yang kosong (meskipun school ada) = Tidak Lengkap
          displayValue = "Data Tidak Lengkap";
          bgColor = Colors.red.shade100;
          labelTextColor = Colors.red.shade800;
        }
      }
      // 2. Status Cetak Badge (Sekarang Statis / Tidak bisa diubah)
      else if (label == "Status Cetak Badge") {
        displayValue = isTrue ? "Sudah Dicetak" : "Belum Dicetak";
        bgColor = isTrue ? Colors.blue.shade100 : Colors.orange.shade100;
        labelTextColor = isTrue ? Colors.blue.shade800 : Colors.orange.shade800;
      }
      // 3. Status Pengambilan Badge (Tetap Dropdown/Editable)
      else if (label == "Status Pengambilan Badge") {
        displayValue = isTrue ? "Sudah Diambil" : "Belum Diambil";
        bgColor = isTrue ? Colors.teal.shade100 : Colors.grey.shade300;
        labelTextColor = isTrue ? Colors.teal.shade800 : Colors.black54;
      }

      // Definisi mana yang boleh di-edit (Hanya Status Pengambilan)
      bool isEditable = label == "Status Pengambilan Badge";

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Table(
          columnWidths: isMobile
              ? {
                  0: FixedColumnWidth(150),
                  1: FixedColumnWidth(10),
                  2: FlexColumnWidth()
                }
              : {
                  0: FixedColumnWidth(250),
                  1: FixedColumnWidth(10),
                  2: FlexColumnWidth()
                },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Text(label,
                    style: GoogleFonts.montserrat(
                        fontSize: isMobile ? 12 : 16, color: black)),
                Text(":",
                    style: GoogleFonts.montserrat(
                        fontSize: isMobile ? 12 : 16,
                        fontWeight: FontWeight.w600)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: isEditable
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: value,
                              isDense: true,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: labelTextColor, size: 20),
                              selectedItemBuilder: (BuildContext context) {
                                return ["true", "false"]
                                    .map<Widget>((String item) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      item == "true"
                                          ? "Sudah Diambil"
                                          : "Belum Diambil",
                                      style: GoogleFonts.montserrat(
                                        fontSize: isMobile ? 11 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: labelTextColor,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              items: [
                                DropdownMenuItem(
                                  value: "true",
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: green,
                                        size: isMobile ? 18 : 22,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Sudah Diambil",
                                        style: GoogleFonts.montserrat(
                                          fontSize: isMobile ? 11 : 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "false",
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.pending,
                                        color: darkGrey,
                                        size: isMobile ? 18 : 22,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Belum Diambil",
                                        style: GoogleFonts.montserrat(
                                          fontSize: isMobile ? 11 : 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (newValue) {
                                if (newValue != null && newValue != value) {
                                  setState(() {
                                    value = newValue;
                                  });

                                  kidsData.isDelivered = newValue == "true";

                                  try {
                                    context.read<UpdateKidsBloc>().add(
                                          UpdateKidsEvent(
                                            id: kidsData.id!,
                                            updatedData: {
                                              'name': kidsData.name,
                                              'birthDate': kidsData.birthdate,
                                              'address': kidsData.address,
                                              'mobile': kidsData.mobile,
                                              'parents': kidsData.parentName,
                                              'school': kidsData.school,
                                              'grade': kidsData.grade,
                                              'isDataComplete':
                                                  kidsData.isDataComplete,
                                              'isPrinted': kidsData.isPrinted,
                                              'isDelivered':
                                                  kidsData.isDelivered,
                                            },
                                          ),
                                        );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: green,
                                        duration: Duration(seconds: 3),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        showCloseIcon: true,
                                        closeIconColor: white,
                                        content: Text(
                                          "Data berhasil diperbaharui!",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: red,
                                        duration: Duration(seconds: 3),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        showCloseIcon: true,
                                        closeIconColor: white,
                                        content: Text(
                                          "Gagal memperbaharui data anak",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: white,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            displayValue,
                            style: GoogleFonts.montserrat(
                              fontSize: isMobile ? 11 : 14,
                              fontWeight: FontWeight.w600,
                              color: labelTextColor,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget mobileLayout(BuildContext parentContext, Kid kidsData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SISI KIRI: Tombol Back + Nama Anak
            Expanded(
              child: Row(
                children: [
                  // Tombol Back Bulat
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color:
                          purple, // Pastikan variabel 'purple' sudah didefinisikan
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        parentContext.read<SidebarMenuBloc>().add(
                              FetchSidebarMenuEvent(
                                  menu: "Anak", data: Object()),
                            );
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color:
                            white, // Pastikan variabel 'white' sudah didefinisikan
                        size: 15,
                      ),
                      // Menghilangkan efek hover/klik pada tombol back
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      tooltip: '',
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nama Anak dengan proteksi overflow
                  Expanded(
                    child: SelectionArea(
                      child: Text(
                        kidsData.name!,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color:
                              black, // Pastikan variabel 'black' sudah didefinisikan
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SISI KANAN: Menu Titik Tiga (Popup Menu)
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              tooltip: '', // Menghilangkan tooltip
              splashRadius:
                  0.1, // Mengecilkan radius splash hingga hampir tidak terlihat
              style: ButtonStyle(
                // Menghilangkan efek hover dan klik secara total
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              onSelected: (value) {
                if (value == 'qr') {
                  showDialog(
                    context: parentContext,
                    builder: (context) => QRCodePopup(
                      id: kidsData.id!,
                      name: kidsData.name!,
                    ),
                  );
                } else if (value == 'edit') {
                  parentContext.read<SidebarMenuBloc>().add(
                        FetchSidebarMenuEvent(
                            menu: "Anak Ubah Data", data: kidsData),
                      );
                } else if (value == 'delete') {
                  showDialog(
                    context: parentContext,
                    builder: (context) => DeleteConfirmationAnakPopup(
                      parentContext: parentContext,
                      kidData: kidsData,
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'qr',
                  child: Row(
                    children: [
                      Icon(Icons.qr_code, size: 18, color: black),
                      const SizedBox(width: 10),
                      Text(
                        "Lihat QR Code",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.mode_edit_outline_outlined,
                          size: 18, color: black),
                      const SizedBox(width: 10),
                      Text(
                        "Ubah Data Anak",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, size: 18, color: red),
                      const SizedBox(width: 10),
                      Text(
                        "Hapus Anak",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoDetailAnak("ID", kidsData.id!, true),
              _infoDetailAnak("Tanggal Lahir",
                  formatJadiDDMMMMYYYYIndonesia(kidsData.birthdate), true),
              _infoDetailAnak("Alamat", kidsData.address, true),
              _infoDetailAnak("No. Hp", kidsData.mobile, true),
              _infoDetailAnak("Nama Orang Tua", kidsData.parentName, true),
              _infoDetailAnak("Sekolah", kidsData.school, true),
              _infoDetailAnak("Kelas", kidsData.grade, true),
              const SizedBox(height: 4),
              Divider(
                color: lightGrey,
                thickness: 1,
              ),
              const SizedBox(height: 7),
              _infoDetailStatusDataAnak(
                context: parentContext,
                label: "Kelengkapan Data",
                value: kidsData.isDataComplete.toString(),
                kidsData: kidsData,
                isMobile: true,
              ),
              _infoDetailStatusDataAnak(
                context: parentContext,
                label: "Status Cetak Badge",
                value: kidsData.isPrinted.toString(),
                kidsData: kidsData,
                isMobile: true,
              ),
              Visibility(
                visible: kidsData.isPrinted == false ? false : true,
                child: _infoDetailStatusDataAnak(
                  context: parentContext,
                  label: "Status Pengambilan Badge",
                  value: kidsData.isDelivered.toString(),
                  kidsData: kidsData,
                  isMobile: true,
                ),
              ),
              Divider(
                color: lightGrey,
                thickness: 1,
              ),
              const SizedBox(height: 12),
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
          ),
        ),
      ),
    ],
  );
}
