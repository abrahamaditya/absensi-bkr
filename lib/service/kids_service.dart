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

  Future<List<Kid>> ambilSemuaDataAnakPlusQuery({
    String? searchNameQuery,
  }) async {
    try {
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

      return kidsSearched;
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

  // Future<bool> updateDataAnak(
  //     String kidId, Map<String, dynamic> updatedData) async {
  //   try {
  //     await _kidsRef.doc(kidId).update(updatedData);
  //     return true;
  //   } catch (e) {
  //     throw Exception('Gagal memperbaharui data anak: $e');
  //   }
  // }

  // Metode 2: // Metode 1: Multi update data via service
  Future<bool> updateDataAnak(
      String kidId, Map<String, dynamic> updatedData) async {
    // 1. Buat batch untuk menjalankan beberapa update sekaligus
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      // --- PROSES 1: UPDATE KOLEKSI 'kids' ---
      DocumentReference kidRef = _kidsRef.doc(kidId);
      batch.update(kidRef, updatedData);

      // Kita hanya perlu update koleksi lain jika ada perubahan pada field 'name'
      if (updatedData.containsKey('name')) {
        String newName = updatedData['name'];

        // --- PROSES 2: UPDATE KOLEKSI 'global-attendance' ---
        // Cari semua dokumen yang punya kidId ini
        QuerySnapshot globalAttQuery = await FirebaseFirestore.instance
            .collection('global-attendance')
            .where('kidId', isEqualTo: kidId)
            .get();

        for (var doc in globalAttQuery.docs) {
          batch.update(doc.reference, {'kidName': newName});
        }

        // --- PROSES 3: UPDATE KOLEKSI 'services' ---
        // Karena 'attendance' adalah Array Map, kita harus ambil dokumennya,
        // edit list-nya di memori, lalu update balik ke Firestore.
        QuerySnapshot servicesQuery = await FirebaseFirestore.instance
            .collection('services')
            // Tips: Filter dokumen yang attendance-nya kemungkinan berisi kidId ini
            .get();

        for (var doc in servicesQuery.docs) {
          List<dynamic> attendanceList = List.from(doc.get('attendance') ?? []);
          bool isAnyKidUpdated = false;

          for (var i = 0; i < attendanceList.length; i++) {
            if (attendanceList[i]['kidId'] == kidId) {
              attendanceList[i]['kidName'] = newName;
              isAnyKidUpdated = true;
            }
          }

          // Hanya masukkan ke batch jika ada data anak yang ditemukan di dalam array ini
          if (isAnyKidUpdated) {
            batch.update(doc.reference, {'attendance': attendanceList});
          }
        }
      }

      // 2. Eksekusi semua perubahan secara bersamaan
      await batch.commit();
      return true;
    } catch (e) {
      throw Exception('Gagal memperbaharui data di semua koleksi: $e');
    }
  }

  Future<bool> deleteDataAnak(String kidId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      // 1. Referensi Dokumen Utama di 'kids'
      DocumentReference kidRef = _kidsRef.doc(kidId);
      batch.delete(kidRef);

      // 2. Hapus semua data di 'global-attendance' yang berhubungan dengan anak ini
      QuerySnapshot globalAttQuery = await FirebaseFirestore.instance
          .collection('global-attendance')
          .where('kidId', isEqualTo: kidId)
          .get();

      for (var doc in globalAttQuery.docs) {
        batch.delete(doc.reference);
      }

      // 3. Update koleksi 'services'
      // Kita harus menghapus object anak ini dari dalam array 'attendance'
      QuerySnapshot servicesQuery = await FirebaseFirestore.instance
          .collection('services')
          // Kita ambil dokumen yang di dalam array attendance-nya ada kidId ini
          // Catatan: Jika data sudah sangat banyak, disarankan menggunakan field bantuan 'kidIds' (array string)
          .get();

      for (var doc in servicesQuery.docs) {
        List<dynamic> attendanceList = List.from(doc.get('attendance') ?? []);
        bool isChanged = false;

        // Hapus item dari list jika kidId cocok
        attendanceList.removeWhere((element) => element['kidId'] == kidId);

        // Jika panjang list berubah, berarti ada data yang dihapus
        if (attendanceList.length != (doc.get('attendance') as List).length) {
          isChanged = true;
        }

        if (isChanged) {
          batch.update(doc.reference, {'attendance': attendanceList});
        }
      }

      // Eksekusi semua perintah hapus dan update sekaligus
      await batch.commit();
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Gagal menghapus data anak dan riwayat kehadirannya: $e');
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

  Future<bool> hapusAbsenDocsAnak(
    String kidId,
    String attendanceId,
  ) async {
    try {
      final snapshot = await _kidsRef.doc(kidId).get();
      if (snapshot.exists) {
        List<dynamic> attendanceList = snapshot.get('attendance');
        final toRemove = attendanceList.firstWhere(
          (entry) => entry is Map && entry['_id'] == attendanceId,
          orElse: () => null,
        );
        if (toRemove != null) {
          await _kidsRef.doc(kidId).update({
            'attendance': FieldValue.arrayRemove([toRemove]),
          });
        }
      }

      return true;
    } catch (e) {
      throw Exception('Gagal menghapus absen anak sisi anak: $e');
    }
  }
}
