// ignore_for_file: constant_identifier_names
import 'package:absensi_bkr/model/kid_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String KID_COLLECTION_REF = 'kids';

class KidsService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _kidsRef;

  KidsService() {
    _kidsRef = _firestore.collection(KID_COLLECTION_REF).withConverter<Kid>(
          fromFirestore: (snapshots, _) => Kid.fromJson(snapshots.data()!),
          toFirestore: (kids, _) => kids.toJson(),
        );
  }

  Future<Map<String, dynamic>> ambilDataAnak({
    int? page,
    int? limit,
    String? searchNameQuery,
  }) async {
    try {
      // Default nilai page dan limit jika tidak ada nilai yang diberikan
      page ??= 1;
      limit ??= 20;
      int skip = (page - 1) * limit;

      // Mengambil semua data dari Firestore
      final snapshot = await _kidsRef.orderBy('name').get();
      var kidsRaw = snapshot.docs.map((doc) {
        var kid = doc.data() as Kid;
        return kid;
      }).toList();

      var kidsSearched = kidsRaw;

      // Jika ada query pencarian, filter berdasarkan nama
      if (searchNameQuery != null && searchNameQuery.isNotEmpty) {
        kidsSearched = kidsSearched.where((kid) {
          // Cek jika name tidak null sebelum melakukan pencarian
          bool matchesName =
              kid.name?.toLowerCase().contains(searchNameQuery.toLowerCase()) ??
                  false;
          return matchesName;
        }).toList();
      }
      final totalData = kidsRaw.length;
      int totalDataforCalcPagination;
      List<Kid> rawDocs;
      List<Kid> filteredDocs;

      if (searchNameQuery != null && searchNameQuery.isNotEmpty) {
        totalDataforCalcPagination = kidsSearched.length;
        filteredDocs = kidsSearched.skip(skip).take(limit).toList();
      } else {
        totalDataforCalcPagination = kidsRaw.length;
        rawDocs = kidsRaw.skip(skip).take(limit).toList();
        filteredDocs = rawDocs;
      }

      return {
        'data': filteredDocs,
        'totalData': totalData,
        'totalPages': (totalDataforCalcPagination / limit).ceil(),
      };
    } catch (e) {
      throw Exception('Gagal mengambil data anak: $e');
    }
  }

  Future<Kid> ambilDataAnakDariId(String kidId) async {
    try {
      final snapshot = await _kidsRef.doc(kidId).get();

      if (snapshot.exists) {
        var kid = snapshot.data() as Kid;
        return kid;
      } else {
        throw Exception('Tidak ada data anak dengan id: $kidId');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data anak: $e');
    }
  }

  Future<List<Kid>> ambilSemuaDataAnak() async {
    try {
      final snapshot = await _kidsRef.orderBy('name').get();

      var kids = snapshot.docs.map((doc) {
        var kid = doc.data() as Kid;
        return kid;
      }).toList();

      return kids;
    } catch (e) {
      throw Exception('Gagal mengambil semua data anak: $e');
    }
  }

  Future<bool> tambahDataAnak(Map<String, dynamic> newData) async {
    try {
      await _kidsRef.doc(newData["_id"]).set(Kid.fromJson(newData));
      return true;
    } catch (e) {
      throw Exception('Gagal menambahkan data anak baru: $e');
    }
  }

  Future<bool> updateDataAnak(
      String kidId, Map<String, dynamic> updatedData) async {
    try {
      await _kidsRef.doc(kidId).update(updatedData);
      return true;
    } catch (e) {
      throw Exception('Gagal memperbaharui data anak: $e');
    }
  }

  Future<bool> tambahAbsenDocsAnak(
      String kidId, Map<String, dynamic> updatedData) async {
    try {
      await _kidsRef.doc(kidId).update({
        'attendance': FieldValue.arrayUnion([updatedData]),
      });
      return true;
    } catch (e) {
      throw Exception('Gagal mengambil absen sisi anak: $e');
    }
  }
}
