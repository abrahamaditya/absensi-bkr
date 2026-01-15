import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:absensi_bkr/helper/grade.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/model/kid_model.dart';
import 'package:absensi_bkr/helper/format_date.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_bloc.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_event.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';

String? kelasController;
String? formattedDateForSubmit;
bool isDataComplete = false;

Widget anakUbahDataSubmenu(BuildContext context, dynamic data) {
  final kidsData = data as Kid;

  TextEditingController namaController =
      TextEditingController(text: kidsData.name);
  TextEditingController tanggalLahirController =
      TextEditingController(text: kidsData.birthdate);
  TextEditingController alamatController =
      TextEditingController(text: kidsData.address);
  TextEditingController sekolahController =
      TextEditingController(text: kidsData.school);
  TextEditingController noHpController =
      TextEditingController(text: kidsData.mobile);
  TextEditingController orangTuaController =
      TextEditingController(text: kidsData.parentName);

  kelasController = kidsData.grade;

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
                                  menu: "Anak Detail", data: kidsData));
                        },
                        icon: Icon(Icons.arrow_back, color: white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Ubah Data Anak",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldFormInputTeks(
                                  "Nama lengkap", namaController, false),
                              const SizedBox(height: 18),
                              _fieldDatePickerTanggal("Tanggal Lahir",
                                  tanggalLahirController, context, false),
                              const SizedBox(height: 18),
                              _fieldFormInputTeks(
                                  "Alamat", alamatController, false),
                              const SizedBox(height: 18),
                              _fieldDropdownFormKelas(
                                  "Kelas", kelasController, false),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldFormInputTeks(
                                  "No. HP", noHpController, false,
                                  isNumber: true),
                              const SizedBox(height: 18),
                              _fieldFormInputTeks(
                                  "Nama Orang Tua", orangTuaController, false),
                              const SizedBox(height: 18),
                              _fieldFormInputTeks(
                                  "Sekolah", sekolahController, false),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.read<SidebarMenuBloc>().add(
                                FetchSidebarMenuEvent(
                                    menu: "Anak Detail", data: kidsData));
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
                            // Validasi
                            if (namaController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: red,
                                  duration: Duration(seconds: 3),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  showCloseIcon: true,
                                  closeIconColor: white,
                                  content: Text(
                                    "Pastikan nama anak sudah terisi",
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

                            // Validasi Berhasil

                            if ((namaController.text.isNotEmpty &&
                                    namaController.text != "" &&
                                    namaController.text != "-") &&
                                (tanggalLahirController.text.isNotEmpty &&
                                    tanggalLahirController.text != "" &&
                                    tanggalLahirController.text != "-") &&
                                (alamatController.text.isNotEmpty &&
                                    alamatController.text != "" &&
                                    alamatController.text != "-") &&
                                (noHpController.text.isNotEmpty &&
                                    noHpController.text != "" &&
                                    noHpController.text != "-") &&
                                (orangTuaController.text.isNotEmpty &&
                                    orangTuaController.text != "" &&
                                    orangTuaController.text != "-") &&
                                kelasController != "Pilih Kelas") {
                              isDataComplete = true;
                            }

                            if (kelasController == "Pilih Kelas") {
                              kelasController = "";
                            }

                            Map<String, dynamic> updatedData = {
                              'name': namaController.text,
                              'birthDate': formattedDateForSubmit,
                              'address': alamatController.text,
                              'mobile': noHpController.text,
                              'parents': orangTuaController.text,
                              'school': sekolahController.text,
                              'grade': kelasController,
                              'isDataComplete': isDataComplete,
                              'updatedAt': ambilWaktuSekarang(),
                            };

                            // Ganti data anak dengan data yang telah diperbaharui (lokal) untuk kembali ke halaman detail
                            kidsData.name = namaController.text;
                            kidsData.birthdate = formattedDateForSubmit;
                            kidsData.address = alamatController.text;
                            kidsData.mobile = noHpController.text;
                            kidsData.parentName = orangTuaController.text;
                            kidsData.grade = kelasController;
                            kidsData.school = sekolahController.text;
                            kidsData.isDataComplete = isDataComplete;

                            try {
                              // Berhasil menambahkan data
                              context.read<UpdateKidsBloc>().add(
                                  UpdateKidsEvent(
                                      id: kidsData.id!,
                                      updatedData: updatedData));

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

                              namaController.clear();
                              tanggalLahirController.clear();
                              alamatController.clear();
                              noHpController.clear();
                              orangTuaController.clear();
                              sekolahController.clear();
                              kelasController = null;
                              formattedDateForSubmit = null;

                              context.read<SidebarMenuBloc>().add(
                                  FetchSidebarMenuEvent(
                                      menu: "Anak Detail", data: kidsData));
                            } catch (e) {
                              // Gagal menambahkan data
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

Widget _fieldFormInputTeks(
    String labelText, TextEditingController controller, bool isMobile,
    {bool isNumber = false}) {
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
        keyboardType: isNumber
            ? TextInputType.number
            : TextInputType.text, // Atur tipe keyboard
        inputFormatters:
            isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
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
              ? (isMobile == true ? 13 : 16)
              : (isMobile == true ? 13 : 16),
          fontWeight: FontWeight.w400,
          color: black,
        ),
      ),
    ],
  );
}

Widget _fieldDropdownFormKelas(
    String labelText, String? selectedKelas, bool isMobile) {
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
        value: (selectedKelas != null && selectedKelas.isNotEmpty)
            ? selectedKelas
            : "Pilih Kelas",
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
            vertical: 16,
            horizontal: 20,
          ),
        ),
        items: kelasOptions
            .map((kelas) => DropdownMenuItem<String>(
                  value: kelas,
                  child: Text(
                    kelas,
                    style: GoogleFonts.montserrat(
                      fontSize: isMobile == true ? 13 : 16,
                      fontWeight: FontWeight.w400,
                      color: kelas == "Pilih Kelas" ? textFieldGrey : black,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          kelasController = value;
        },
        onSaved: (newValue) {
          kelasController = newValue;
        },
      ),
    ],
  );
}

Widget _fieldDatePickerTanggal(String labelText,
    TextEditingController controller, BuildContext context, bool isMobile) {
  if (controller.text.isNotEmpty) {
    DateTime parsedDate = DateTime.parse(controller.text);
    String displayDate =
        "${parsedDate.day.toString().padLeft(2, '0')} ${_getMonthName(parsedDate.month)} ${parsedDate.year}";

    controller.text = displayDate;
    formattedDateForSubmit =
        "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
  }
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
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            locale: const Locale("id", "ID"),
            cancelText: "Batal",
            confirmText: "Pilih",
            helpText: "Pilih Tanggal Lahir",
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: purple,
                    onPrimary: white,
                    onSurface: black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: purple,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (selectedDate != null) {
            // Format untuk ditampilkan di TextField (DD MM YYYY)
            String displayDate =
                "${selectedDate.day.toString().padLeft(2, '0')} ${_getMonthName(selectedDate.month)} ${selectedDate.year}";

            // Format untuk disubmit (YYYY-MM-DD)
            formattedDateForSubmit =
                "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

            // Tampilkan format DD MM YYYY di TextField
            controller.text = displayDate;
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
              ? (isMobile == true ? 13 : 16)
              : (isMobile == true ? 13 : 16),
          fontWeight: FontWeight.w400,
          color: black,
        ),
      ),
    ],
  );
}

// Fungsi untuk mendapatkan nama bulan dalam format teks
String _getMonthName(int month) {
  const List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  return months[month - 1];
}

Widget mobileLayout(BuildContext context, Kid kidsData) {
  TextEditingController namaController =
      TextEditingController(text: kidsData.name);
  TextEditingController tanggalLahirController =
      TextEditingController(text: kidsData.birthdate);
  TextEditingController alamatController =
      TextEditingController(text: kidsData.address);
  TextEditingController sekolahController =
      TextEditingController(text: kidsData.school);
  TextEditingController noHpController =
      TextEditingController(text: kidsData.mobile);
  TextEditingController orangTuaController =
      TextEditingController(text: kidsData.parentName);
  kelasController = kidsData.grade;

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
                    FetchSidebarMenuEvent(menu: "Anak Detail", data: kidsData));
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
            "Ubah Data Anak",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: black,
            ),
          ),
        ],
      ),
      const SizedBox(height: 25),
      ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldFormInputTeks(
                            "Nama lengkap", namaController, true),
                        const SizedBox(height: 18),
                        _fieldDatePickerTanggal("Tanggal Lahir",
                            tanggalLahirController, context, true),
                        const SizedBox(height: 18),
                        _fieldFormInputTeks("Alamat", alamatController, true),
                        const SizedBox(height: 18),
                        _fieldDropdownFormKelas("Kelas", kelasController, true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldFormInputTeks("No. HP", noHpController, true,
                            isNumber: true),
                        const SizedBox(height: 18),
                        _fieldFormInputTeks(
                            "Nama Orang Tua", orangTuaController, true),
                        const SizedBox(height: 18),
                        _fieldFormInputTeks("Sekolah", sekolahController, true),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<SidebarMenuBloc>().add(FetchSidebarMenuEvent(
                          menu: "Anak Detail", data: kidsData));
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
                      // Validasi
                      if (namaController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: red,
                            duration: Duration(seconds: 3),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            showCloseIcon: true,
                            closeIconColor: white,
                            content: Text(
                              "Pastikan nama anak sudah terisi",
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

                      // Validasi Berhasil

                      if ((namaController.text.isNotEmpty &&
                              namaController.text != "" &&
                              namaController.text != "-") &&
                          (tanggalLahirController.text.isNotEmpty &&
                              tanggalLahirController.text != "" &&
                              tanggalLahirController.text != "-") &&
                          (alamatController.text.isNotEmpty &&
                              alamatController.text != "" &&
                              alamatController.text != "-") &&
                          (noHpController.text.isNotEmpty &&
                              noHpController.text != "" &&
                              noHpController.text != "-") &&
                          (orangTuaController.text.isNotEmpty &&
                              orangTuaController.text != "" &&
                              orangTuaController.text != "-") &&
                          kelasController != "Pilih Kelas") {
                        isDataComplete = true;
                      }

                      if (kelasController == "Pilih Kelas") {
                        kelasController = "";
                      }

                      Map<String, dynamic> updatedData = {
                        'name': namaController.text,
                        'birthDate': formattedDateForSubmit,
                        'address': alamatController.text,
                        'mobile': noHpController.text,
                        'parents': orangTuaController.text,
                        'school': sekolahController.text,
                        'grade': kelasController,
                        'isDataComplete': isDataComplete,
                        'updatedAt': ambilWaktuSekarang(),
                      };

                      // Ganti data anak dengan data yang telah diperbaharui (lokal) untuk kembali ke halaman detail
                      kidsData.name = namaController.text;
                      kidsData.birthdate = formattedDateForSubmit;
                      kidsData.address = alamatController.text;
                      kidsData.mobile = noHpController.text;
                      kidsData.parentName = orangTuaController.text;
                      kidsData.grade = kelasController;
                      kidsData.school = sekolahController.text;
                      kidsData.isDataComplete = isDataComplete;

                      try {
                        // Berhasil menambahkan data
                        context.read<UpdateKidsBloc>().add(UpdateKidsEvent(
                            id: kidsData.id!, updatedData: updatedData));

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

                        namaController.clear();
                        tanggalLahirController.clear();
                        alamatController.clear();
                        noHpController.clear();
                        orangTuaController.clear();
                        sekolahController.clear();
                        kelasController = null;
                        formattedDateForSubmit = null;

                        context.read<SidebarMenuBloc>().add(
                            FetchSidebarMenuEvent(
                                menu: "Anak Detail", data: kidsData));
                      } catch (e) {
                        // Gagal menambahkan data
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
        ),
      ),
    ],
  );
}
