// ignore_for_file: constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:absensi_bkr/model/attendance_model.dart';

const String GLOBAL_ATTENDANCE_COLLECTION_REF = 'global-attendance';

class GlobalAttendanceService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _globalAttendanceRef;

  GlobalAttendanceService() {
    _globalAttendanceRef = _firestore
        .collection(GLOBAL_ATTENDANCE_COLLECTION_REF)
        .withConverter<GlobalAttendance>(
          fromFirestore: (snapshots, _) =>
              GlobalAttendance.fromJson(snapshots.data()!),
          toFirestore: (globalAttendance, _) => globalAttendance.toJson(),
        );
  }

  Future<bool> tambahAbsenDocsGlobalAttendance(
      Map<String, dynamic> newData) async {
    try {
      await _globalAttendanceRef
          .doc(newData["_id"])
          .set(GlobalAttendance.fromJson(newData));
      return true;
    } catch (e) {
      throw Exception('Gagal mengambil absen sisi global attendance: $e');
    }
  }

  Future<bool> hapusAbsenDocsGlobalAttendance(String attendanceId) async {
    try {
      await _globalAttendanceRef.doc(attendanceId).delete();
      return true;
    } catch (e) {
      throw Exception('Gagal menghapus absen sisi global attendance: $e');
    }
  }
}
