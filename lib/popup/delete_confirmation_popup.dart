import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/model/service_model.dart';
import 'package:absensi_bkr/model/attendance_model.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_bloc.dart';
import 'package:absensi_bkr/bloc/services_bloc/services_event.dart';

class DeleteConfirmationPopup extends StatelessWidget {
  final BuildContext parentContext;
  final Service serviceData;
  final AttendanceService attendanceData;
  const DeleteConfirmationPopup({
    super.key,
    required this.parentContext,
    required this.attendanceData,
    required this.serviceData,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: transparent,
      child: Container(
        width: screenWidth < 1000 ? 300 : 340,
        height: screenWidth < 1000 ? 255 : 260,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: red,
              size: screenWidth < 1000 ? 52 : 54,
            ),
            SizedBox(height: 8),
            Text(
              "Hapus Absensi",
              style: GoogleFonts.montserrat(
                fontSize: screenWidth < 1000 ? 14 : 17,
                fontWeight: FontWeight.w800,
                color: black,
              ),
            ),
            Text(
              (attendanceData.kidsName != null)
                  ? "${attendanceData.kidsName!.trim().split(' ').length > 1 ? attendanceData.kidsName!.trim().split(' ').take(2).join(' ') : attendanceData.kidsName!}?"
                  : "",
              style: GoogleFonts.montserrat(
                fontSize: screenWidth < 1000 ? 14 : 17,
                fontWeight: FontWeight.w800,
                color: black,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Data absensi ${(attendanceData.kidsName != null) ? attendanceData.kidsName!.trim().split(' ').first : ""} akan dihapus dari kegiatan ini. Apakah kakak yakin?",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: screenWidth < 1000 ? 12 : 14,
                fontWeight: FontWeight.w500,
                color: black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(parentContext).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(color: red, width: 1),
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
                        fontSize: screenWidth < 1000 ? 12 : 14,
                        fontWeight: FontWeight.w600,
                        color: white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      try {
                        parentContext
                            .read<DeleteAttendanceChildbyServiceBloc>()
                            .add(DeleteAttendanceChildbyServiceEvent(
                              serviceId: serviceData.id,
                              attendanceId: attendanceData.id,
                              kidId: attendanceData.kidsId,
                            ));

                        Future.delayed(const Duration(milliseconds: 50), () {
                          // ignore: use_build_context_synchronously
                          parentContext.read<GetServiceByIdBloc>().add(
                              FetchServiceByIDEvent(serviceId: serviceData.id));
                        });

                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            backgroundColor: green,
                            duration: Duration(seconds: 3),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            showCloseIcon: true,
                            closeIconColor: white,
                            content: Text(
                              "${attendanceData.kidsName} berhasil dihapus!",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: white,
                              ),
                            ),
                          ),
                        );
                        Navigator.of(parentContext).pop(false);
                      } catch (e) {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            backgroundColor: red,
                            duration: Duration(seconds: 3),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            showCloseIcon: true,
                            closeIconColor: white,
                            content: Text(
                              "Gagal menghapus absen",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: white,
                              ),
                            ),
                          ),
                        );
                        Navigator.of(parentContext).pop(false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(color: red, width: 1),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                    ),
                    child: Text(
                      "Ya, Hapus",
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth < 1000 ? 12 : 14,
                        fontWeight: FontWeight.w600,
                        color: red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
