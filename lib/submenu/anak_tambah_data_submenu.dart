import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/grade.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_bloc.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_event.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';

String? kelasController;

Widget anakTambahDataSubmenu(BuildContext context) {
  TextEditingController namaController = TextEditingController();
  TextEditingController tanggalLahirController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController orangTuaController = TextEditingController();
  kelasController = "Pilih Kelas";

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
                          FetchSidebarMenuEvent(menu: "Anak", data: Object()),
                        );
                  },
                  icon: Icon(Icons.arrow_back, color: white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Tambah Data Anak",
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldFormInputTeks("Nama lengkap", namaController),
                        const SizedBox(height: 18),
                        _fieldDatePickerTanggal(
                            "Tanggal Lahir", tanggalLahirController, context),
                        const SizedBox(height: 18),
                        _fieldFormInputTeks("Alamat", alamatController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldFormInputTeks("No. HP", noHpController,
                            isNumber: true),
                        const SizedBox(height: 18),
                        _fieldFormInputTeks(
                            "Nama Orang Tua", orangTuaController),
                        const SizedBox(height: 18),
                        _fieldDropdownFormKelas("Kelas", kelasController!),
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
                            FetchSidebarMenuEvent(menu: "Anak", data: Object()),
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
                      // Validasi
                      if (namaController.text.isEmpty ||
                          tanggalLahirController.text.isEmpty ||
                          alamatController.text.isEmpty ||
                          noHpController.text.isEmpty ||
                          orangTuaController.text.isEmpty ||
                          kelasController == "Pilih Kelas") {
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
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: white,
                              ),
                            ),
                          ),
                        );
                        return;
                      }

                      // Validasi Berhasil
                      Map<String, dynamic> newData = {
                        '_id': membuatKidId(),
                        'name': namaController.text,
                        'birthDate': tanggalLahirController.text,
                        'address': alamatController.text,
                        'phoneNumbers': noHpController.text,
                        'parents': orangTuaController.text,
                        'grade': kelasController,
                        'absence': [],
                      };

                      try {
                        // Berhasil menambahkan data
                        context
                            .read<CreateKidsBloc>()
                            .add(CreateKidsEvent(newData: newData));
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
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: white,
                              ),
                            ),
                          ),
                        );

                        context
                            .read<GetKidsBloc>()
                            .add(FetchKidsEvent(page: 1, searchNameQuery: ""));
                        context.read<SidebarMenuBloc>().add(
                              FetchSidebarMenuEvent(
                                  menu: "Anak", data: Object()),
                            );
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
                              "Gagal menambahkan data anak baru",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
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
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          hintText: 'Masukkan $labelText',
          hintStyle: GoogleFonts.montserrat(
            fontSize: 16,
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
      ),
    ],
  );
}

Widget _fieldDropdownFormKelas(String labelText, String selectedKelas) {
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
            fontSize: 16,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: kelas == "Pilih Kelas" ? textFieldGrey : black,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          kelasController = value ?? selectedKelas;
        },
      ),
    ],
  );
}

Widget _fieldDatePickerTanggal(
    String labelText, TextEditingController controller, BuildContext context) {
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
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
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
            fontSize: 16,
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
      ),
    ],
  );
}

String membuatKidId() {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';
  Random rand = Random();

  String lettersPart = String.fromCharCodes(
    Iterable.generate(
        4, (_) => letters.codeUnitAt(rand.nextInt(letters.length))),
  );

  String numbersPart = String.fromCharCodes(
    Iterable.generate(
        4, (_) => numbers.codeUnitAt(rand.nextInt(numbers.length))),
  );

  return '$lettersPart-$numbersPart';
}
