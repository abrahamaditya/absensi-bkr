import 'dart:math';
import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_bloc.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_state.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_event.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';

String? idController;
String? kegiatanController;

TextEditingController lainnyaController = TextEditingController();
TextEditingController tanggalKegiatanController = TextEditingController();
TextEditingController waktuKegiatanController = TextEditingController();

Widget kegiatanTambahDataSubmenu(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  idController = "";
  kegiatanController = "Pilih Kegiatan";

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
                          context.read<SidebarMenuBloc>().add(
                                FetchSidebarMenuEvent(
                                    menu: "Kegiatan", data: Object()),
                              );
                        },
                        icon: Icon(Icons.arrow_back, color: white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Tambah Data Kegiatan",
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Divider(
                      color: lightGrey,
                      thickness: 1,
                    ),
                    const SizedBox(height: 20),
                    _fieldDropdownFormKegiatan(
                        "Kegiatan", kegiatanController!, context,
                        isMobile: false),
                    const SizedBox(height: 18),
                    BlocBuilder<LainnyaServicesBloc, ServicesState>(
                      builder: (context, state) {
                        if (state is LainnyaServicesTrue) {
                          return Column(
                            children: [
                              _fieldFormInputTeks(
                                  "Kegiatan Lainnya", lainnyaController,
                                  isMobile: false),
                              const SizedBox(height: 18),
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                    _fieldDatePickerTanggal(
                        "Tanggal Kegiatan", tanggalKegiatanController, context,
                        isMobile: false),
                    const SizedBox(height: 18),
                    _fieldDropdownFormWaktu(
                        "Waktu Kegiatan", waktuKegiatanController, context,
                        isMobile: false),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.read<SidebarMenuBloc>().add(
                                  FetchSidebarMenuEvent(
                                      menu: "Kegiatan", data: Object()),
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
                            "Batal",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: orange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            String selectedKegiatan =
                                kegiatanController ?? "Pilih Kegiatan";

                            // Hati-hati dengan code ini
                            // Fungsinya adalah jika kegiatan adalah "Lainnya", maka kita akan ambil inputan dari field "Lainnya"
                            if (selectedKegiatan == "Lainnya") {
                              selectedKegiatan = lainnyaController.text;
                            }

                            // Validasi
                            if (selectedKegiatan == "Pilih Kegiatan" ||
                                selectedKegiatan.isEmpty ||
                                tanggalKegiatanController.text.isEmpty ||
                                waktuKegiatanController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: red,
                                  duration: Duration(seconds: 3),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  showCloseIcon: true,
                                  closeIconColor: white,
                                  content: Text(
                                    "Pastikan semua data terisi dengan benar",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: white,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }

                            if (lainnyaController.text.isNotEmpty) {
                              idController = _membuatServiceId(
                                selectedKegiatan,
                                tanggalKegiatanController.text,
                                waktuKegiatanController.text,
                                lainnyaController.text,
                              );
                            } else {
                              idController = _membuatServiceId(
                                selectedKegiatan,
                                tanggalKegiatanController.text,
                                waktuKegiatanController.text,
                              );
                            }

                            Map<String, dynamic> newData = {
                              '_id': idController,
                              'name': selectedKegiatan,
                              'date': tanggalKegiatanController.text,
                              'time': waktuKegiatanController.text,
                              'attendance': [],
                            };

                            try {
                              context
                                  .read<CreateServicesBloc>()
                                  .add(CreateServicesEvent(newData: newData));

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: green,
                                  duration: Duration(seconds: 3),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  showCloseIcon: true,
                                  closeIconColor: white,
                                  content: Text(
                                    "Data berhasil ditambahkan!",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: white,
                                    ),
                                  ),
                                ),
                              );

                              context.read<GetServicesBloc>().add(
                                  FetchServicesEvent(
                                      page: 1, searchNameQuery: ""));

                              context.read<SidebarMenuBloc>().add(
                                    FetchSidebarMenuEvent(
                                        menu: "Kegiatan", data: Object()),
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
                                    "Gagal menambahkan kegiatan baru",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: white,
                                    ),
                                  ),
                                ),
                              );
                            }
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
                          child: Text(
                            "Simpan Data",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
}

Widget _fieldFormInputTeks(String labelText, TextEditingController controller,
    {bool isMobile = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: black,
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        cursorColor: black,
        decoration: InputDecoration(
          hintText: 'Masukkan $labelText',
          hintStyle: GoogleFonts.montserrat(
            fontSize: isMobile == true ? 13 : 16,
            fontWeight: FontWeight.w400,
            color: textFieldGrey,
          ),
          filled: true,
          fillColor: fillFieldGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: lightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: purple),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
        ),
        style: GoogleFonts.montserrat(
          fontSize: controller.text.isNotEmpty
              ? (isMobile == true ? 14 : 16)
              : (isMobile == true ? 14 : 16),
          fontWeight: FontWeight.w400,
          color: black,
        ),
      ),
    ],
  );
}

Widget _fieldDropdownFormWaktu(
    String labelText, TextEditingController controller, BuildContext context,
    {required bool isMobile}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: black,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          TimeOfDay? selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            confirmText: "Pilih",
            cancelText: "Batal",
            helpText: "Pilih Waktu Kegiatan",
            builder: (context, childWidget) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: childWidget!,
              );
            },
          );

          if (selectedTime != null) {
            String formattedTime =
                "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
            controller.text = formattedTime;
          }
        },
        decoration: InputDecoration(
          hintText: 'Pilih $labelText',
          hintStyle: GoogleFonts.montserrat(
            fontSize: isMobile == true ? 13 : 16,
            fontWeight: FontWeight.w400,
            color: textFieldGrey,
          ),
          filled: true,
          fillColor: fillFieldGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: lightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: purple),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
        ),
        style: GoogleFonts.montserrat(
          fontSize: controller.text.isNotEmpty
              ? (isMobile == true ? 14 : 16)
              : (isMobile == true ? 14 : 16),
          fontWeight: FontWeight.w400,
          color: black,
        ),
      ),
    ],
  );
}

Widget _fieldDropdownFormKegiatan(
    String labelText, String selectedKelas, BuildContext context,
    {required bool isMobile}) {
  List<String> kegiatanOptions = [
    "Pilih Kegiatan",
    "Ibadah Reguler I",
    "Ibadah Reguler II",
    "Ibadah Reguler III",
    "Ibadah Reguler IV",
    "English Service II",
    "English Service III",
    "Menara Doa",
    "Lainnya"
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: black,
        ),
      ),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: selectedKelas,
        decoration: InputDecoration(
          hintText: 'Pilih $labelText',
          hintStyle: GoogleFonts.montserrat(
            fontSize: isMobile == true ? 13 : 16,
            fontWeight: FontWeight.w400,
            color: selectedKelas == "Pilih Kegiatan" ? textFieldGrey : black,
          ),
          filled: true,
          fillColor: fillFieldGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: lightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: purple),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
        items: kegiatanOptions
            .map((kelas) => DropdownMenuItem<String>(
                  value: kelas,
                  child: Text(
                    kelas,
                    style: GoogleFonts.montserrat(
                      fontSize: isMobile == true ? 13 : 16,
                      fontWeight: FontWeight.w400,
                      color: kelas == "Pilih Kegiatan" ? textFieldGrey : black,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          if (value == "Lainnya") {
            context.read<LainnyaServicesBloc>().add(
                  LainnyaServicesEvent(visibility: true),
                );
          } else {
            context.read<LainnyaServicesBloc>().add(
                  LainnyaServicesEvent(visibility: false),
                );
          }
          kegiatanController = value ?? selectedKelas;
        },
      ),
    ],
  );
}

Widget _fieldDatePickerTanggal(
    String labelText, TextEditingController controller, BuildContext context,
    {required bool isMobile}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: black,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2025),
            lastDate: DateTime(2030),
            cancelText: "Batal",
            confirmText: "Pilih",
            helpText: "Pilih Tanggal",
          );
          if (selectedDate != null) {
            controller.text =
                "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
          }
        },
        decoration: InputDecoration(
          hintText: 'Pilih $labelText',
          hintStyle: GoogleFonts.montserrat(
            fontSize: isMobile == true ? 13 : 16,
            fontWeight: FontWeight.w400,
            color: textFieldGrey,
          ),
          filled: true,
          fillColor: fillFieldGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: lightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: purple),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
        ),
        style: GoogleFonts.montserrat(
          fontSize: controller.text.isNotEmpty
              ? (isMobile == true ? 14 : 16)
              : (isMobile == true ? 14 : 16),
          fontWeight: FontWeight.w400,
          color: black,
        ),
      ),
    ],
  );
}

String _membuatServiceId(String kegiatan, String tanggal, String waktu,
    [String? lainnya]) {
  String kegiatanCode = '';

  if (kegiatan.contains('English Service')) {
    kegiatanCode = 'ENG';
  } else if (kegiatan.contains('Menara Doa')) {
    kegiatanCode = 'MEN';
  } else if (kegiatan.contains('Ibadah Reguler')) {
    kegiatanCode = 'REG';
  } else if (lainnya != null) {
    // Jika kegiatan adalah "Lainnya", maka kita proses input kustom untuk kegiatan
    kegiatanCode = _membuatIdUntukKegiatanLainnya(lainnya);
  } else {
    kegiatanCode = _membuat3HurufRandom(3);
  }

  // Memformat tanggal menjadi YYMMDD (misalnya 2025-01-22 menjadi 2201)
  List<String> tanggalParts = tanggal.split('-');
  String formattedTanggal =
      tanggalParts[1] + tanggalParts[2] + tanggalParts[0].substring(2);

  String formattedWaktu = waktu.replaceAll(":", "");

  return '$kegiatanCode-$formattedTanggal-$formattedWaktu';
}

String _membuatIdUntukKegiatanLainnya(String lainnya) {
  if (lainnya.length >= 3) {
    // Ambil 3 huruf pertama dari input lainnya
    return lainnya.substring(0, 3).toUpperCase();
  } else {
    // Jika kurang dari 3 huruf, buatkan random 3 huruf
    String randomChars = _membuat3HurufRandom(3);
    return randomChars;
  }
}

String _membuat3HurufRandom(int length) {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Random random = Random();
  return List.generate(
          length, (index) => characters[random.nextInt(characters.length)])
      .join('');
}

Widget mobileLayout(BuildContext context) {
  idController = "";
  kegiatanController = "Pilih Kegiatan";
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
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
                      FetchSidebarMenuEvent(menu: "Kegiatan", data: Object()),
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
          Text(
            "Tambah Data Kegiatan",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: black,
            ),
          ),
        ],
      ),
      const SizedBox(height: 25),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldDropdownFormKegiatan("Kegiatan", kegiatanController!, context,
              isMobile: true),
          const SizedBox(height: 18),
          BlocBuilder<LainnyaServicesBloc, ServicesState>(
            builder: (context, state) {
              if (state is LainnyaServicesTrue) {
                return Column(
                  children: [
                    _fieldFormInputTeks("Kegiatan Lainnya", lainnyaController,
                        isMobile: true),
                    const SizedBox(height: 18),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          _fieldDatePickerTanggal(
              "Tanggal Kegiatan", tanggalKegiatanController, context,
              isMobile: true),
          const SizedBox(height: 18),
          _fieldDropdownFormWaktu(
              "Waktu Kegiatan", waktuKegiatanController, context,
              isMobile: true),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<SidebarMenuBloc>().add(
                        FetchSidebarMenuEvent(menu: "Kegiatan", data: Object()),
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
                  "Batal",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: orange,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  String selectedKegiatan =
                      kegiatanController ?? "Pilih Kegiatan";

                  // Hati-hati dengan code ini
                  // Fungsinya adalah jika kegiatan adalah "Lainnya", maka kita akan ambil inputan dari field "Lainnya"
                  if (selectedKegiatan == "Lainnya") {
                    selectedKegiatan = lainnyaController.text;
                  }

                  // Validasi
                  if (selectedKegiatan == "Pilih Kegiatan" ||
                      selectedKegiatan.isEmpty ||
                      tanggalKegiatanController.text.isEmpty ||
                      waktuKegiatanController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: red,
                        duration: Duration(seconds: 3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        showCloseIcon: true,
                        closeIconColor: white,
                        content: Text(
                          "Pastikan semua data terisi dengan benar",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: white,
                          ),
                        ),
                      ),
                    );
                    return;
                  }

                  if (lainnyaController.text.isNotEmpty) {
                    idController = _membuatServiceId(
                      selectedKegiatan,
                      tanggalKegiatanController.text,
                      waktuKegiatanController.text,
                      lainnyaController.text,
                    );
                  } else {
                    idController = _membuatServiceId(
                      selectedKegiatan,
                      tanggalKegiatanController.text,
                      waktuKegiatanController.text,
                    );
                  }

                  Map<String, dynamic> newData = {
                    '_id': idController,
                    'name': selectedKegiatan,
                    'date': tanggalKegiatanController.text,
                    'time': waktuKegiatanController.text,
                    'attendance': [],
                  };

                  try {
                    context
                        .read<CreateServicesBloc>()
                        .add(CreateServicesEvent(newData: newData));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: green,
                        duration: Duration(seconds: 3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        showCloseIcon: true,
                        closeIconColor: white,
                        content: Text(
                          "Data berhasil ditambahkan!",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: white,
                          ),
                        ),
                      ),
                    );

                    context
                        .read<GetServicesBloc>()
                        .add(FetchServicesEvent(page: 1, searchNameQuery: ""));

                    context.read<SidebarMenuBloc>().add(
                          FetchSidebarMenuEvent(
                              menu: "Kegiatan", data: Object()),
                        );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: red,
                        duration: Duration(seconds: 3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        showCloseIcon: true,
                        closeIconColor: white,
                        content: Text(
                          "Gagal menambahkan kegiatan baru",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: white,
                          ),
                        ),
                      ),
                    );
                  }
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
                child: Text(
                  "Simpan Data",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
