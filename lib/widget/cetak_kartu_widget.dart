import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/helper/padding.dart';

Widget cetakKartuWidget(BuildContext context) {
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
                      Text(
                        "Cetak Kartu Absensi",
                        style: GoogleFonts.montserrat(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: black,
                        ),
                      ),
                      Text(
                        "Pendataan Kartu Absensi",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: black,
                        ),
                      ),
                      Divider(
                        color: lightGrey,
                        thickness: 1,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "🖨️ Data Spreadsheet Kartu Absensi",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Lihat pendataan anak yang telah melakukan pencetakan kartu absensi di setiap batch-nya, serta dapat diisi untuk pendataan jika ada anak yang ingin melakukan pencetakan ulang.",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () => web.window.open(
                            'https://docs.google.com/spreadsheets/d/1T-ezLitcax3z4xfvTz0lXhpNtD7oqUJxJsrenuD6Hcs/edit?usp=sharing',
                            '_blank'),
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Lihat & Isi Data",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: orange,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.open_in_new_rounded,
                              color: orange,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
}

Widget mobileLayout(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Cetak Kartu Absensi",
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: black,
        ),
      ),
      Text(
        "Pendataan Kartu Absensi",
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: black,
        ),
      ),
      const SizedBox(height: 2),
      Divider(
        color: lightGrey,
        thickness: 1,
      ),
      const SizedBox(height: 12),
      Text(
        "🖨️ Data Spreadsheet Kartu Absensi",
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: black,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        "Lihat pendataan anak yang telah melakukan pencetakan kartu absensi di setiap batch-nya, serta dapat diisi untuk pendataan jika ada anak yang ingin melakukan pencetakan ulang.",
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: black,
        ),
      ),
      const SizedBox(height: 5),
      ElevatedButton(
        onPressed: () => web.window.open(
            'https://docs.google.com/spreadsheets/d/1T-ezLitcax3z4xfvTz0lXhpNtD7oqUJxJsrenuD6Hcs/edit?usp=sharing',
            '_blank'),
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: BorderSide(color: orange, width: 1),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 14,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Lihat Laporan Selengkapnya",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: orange,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.open_in_new_rounded,
              color: orange,
              size: 12,
            ),
          ],
        ),
      ),
    ],
  );
}
