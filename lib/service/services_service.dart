// ignore_for_file: constant_identifier_names
import 'package:absensi_bkr/helper/format_date.dart';
import 'package:absensi_bkr/model/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String SERVICE_COLLECTION_REF = 'services';

class ServicesService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _servicesRef;

  ServicesService() {
    _servicesRef = _firestore
        .collection(SERVICE_COLLECTION_REF)
        .withConverter<Service>(
          fromFirestore: (snapshots, _) => Service.fromJson(snapshots.data()!),
          toFirestore: (service, _) => service.toJson(),
        );
  }

  Future<List<Service>> ambilSemuaDataKegiatan() async {
    try {
      final snapshot = await _servicesRef.get();
      var services = snapshot.docs.map((doc) {
        var service = doc.data() as Service;
        return service;
      }).toList();

      // Pagination: Mengambil data sesuai dengan halaman dan limit
      var filteredDocs = services.toList();

      // Sort berdasarkan waktu kegiatan
      filteredDocs.sort((a, b) {
        DateTime dateTimeA = DateTime.parse('${a.date} ${a.time}');
        DateTime dateTimeB = DateTime.parse('${b.date} ${b.time}');
        return dateTimeB.compareTo(dateTimeA);
      });

      // Sort attendance jika ada
      filteredDocs = filteredDocs.map((service) {
        if (service.attendance != null) {
          service.attendance!.sort((a, b) {
            DateTime timestampA = formatYYYYMMDDHHMMSS(a.timestamp!);
            DateTime timestampB = formatYYYYMMDDHHMMSS(b.timestamp!);
            return timestampB.compareTo(timestampA);
          });
        }
        if (service.date != null) {
          service.date = formatTanggalEEEEDDMMMMYYYYIndonesia(service.date!);
        }
        return service;
      }).toList();

      return filteredDocs;
    } catch (e) {
      throw Exception('Gagal mengambil data kegiatan: $e');
    }
  }

  Future<List<Service>> ambilDataKegiatan({
    int? page,
    int? limit,
  }) async {
    try {
      page ??= 1;
      limit ??= 10;
      int skip = (page - 1) * limit;

      final snapshot = await _servicesRef.get();
      var services = snapshot.docs.map((doc) {
        var service = doc.data() as Service;
        return service;
      }).toList();

      // Pagination: Mengambil data sesuai dengan halaman dan limit
      var filteredDocs = services.skip(skip).take(limit).toList();

      // Sort berdasarkan waktu kegiatan
      filteredDocs.sort((a, b) {
        DateTime dateTimeA = DateTime.parse('${a.date} ${a.time}');
        DateTime dateTimeB = DateTime.parse('${b.date} ${b.time}');
        return dateTimeB.compareTo(dateTimeA);
      });

      // Sort attendance jika ada
      filteredDocs = filteredDocs.map((service) {
        if (service.attendance != null) {
          service.attendance!.sort((a, b) {
            DateTime timestampA = formatYYYYMMDDHHMMSS(a.timestamp!);
            DateTime timestampB = formatYYYYMMDDHHMMSS(b.timestamp!);
            return timestampB.compareTo(timestampA);
          });
        }
        if (service.date != null) {
          service.date = formatTanggalEEEEDDMMMMYYYYIndonesia(service.date!);
        }
        return service;
      }).toList();

      return filteredDocs;
    } catch (e) {
      throw Exception('Gagal mengambil data kegiatan: $e');
    }
  }

  Future<int> ambilTotalJumlahDataKegiatan() async {
    try {
      final aggregateQuery = await _servicesRef.count().get();
      return aggregateQuery.count!;
    } catch (e) {
      throw Exception('Gagal mengambil jumlah total data kegiatan: $e');
    }
  }

  Future<bool> tambahDataKegiatan(Map<String, dynamic> newData) async {
    try {
      await _servicesRef.doc(newData["_id"]).set(Service.fromJson(newData));
      return true;
    } catch (e) {
      throw Exception('Gagal menambahkan data kegiatan baru: $e');
    }
  }

  Future<List<Service>> ambilDataKegiatanHariIni(String todayDate) async {
    try {
      final snapshot =
          await _servicesRef.where('date', isEqualTo: todayDate).get();

      var services = snapshot.docs.map((doc) {
        var service = doc.data() as Service;
        return service;
      }).toList();

      services.sort((a, b) {
        DateTime dateTimeA = DateTime.parse('${a.date} ${a.time}');
        DateTime dateTimeB = DateTime.parse('${b.date} ${b.time}');

        return dateTimeA.compareTo(dateTimeB);
      });

      return services;
    } catch (e) {
      throw Exception('Gagal mengambil data kegiatan hari ini: $e');
    }
  }

  Future<bool> tambahAbsenDocsKegiatan(
      String serviceID, Map<String, dynamic> updatedData) async {
    try {
      await _servicesRef.doc(serviceID).update({
        'attendance': FieldValue.arrayUnion([updatedData]),
      });
      return true;
    } catch (e) {
      throw Exception('Gagal mengambil absen sisi kegiatan: $e');
    }
  }

  Future<Service> ambilDataKegiatanDariId(String serviceId) async {
    try {
      final snapshot = await _servicesRef.doc(serviceId).get();

      if (snapshot.exists) {
        var service = snapshot.data() as Service;

        if (service.attendance != null) {
          service.attendance!.sort((a, b) {
            DateTime timestampA = formatYYYYMMDDHHMMSS(a.timestamp!);
            DateTime timestampB = formatYYYYMMDDHHMMSS(b.timestamp!);
            return timestampB.compareTo(timestampA);
          });
        }

        if (service.date != null) {
          service.date = formatTanggalEEEEDDMMMMYYYYIndonesia(service.date!);
        }

        return service;
      } else {
        throw Exception('Tidak ada data anak dengan id: $serviceId');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data anak: $e');
    }
  }

  Future<bool> hapusAbsenDocsKegiatan(
    String serviceId,
    String attendanceId,
  ) async {
    try {
      final snapshot = await _servicesRef.doc(serviceId).get();
      if (snapshot.exists) {
        List<dynamic> attendanceList = snapshot.get('attendance');
        final toRemove = attendanceList.firstWhere(
          (entry) => entry is Map && entry['_id'] == attendanceId,
          orElse: () => null,
        );
        if (toRemove != null) {
          await _servicesRef.doc(serviceId).update({
            'attendance': FieldValue.arrayRemove([toRemove]),
          });
        }
      }

      return true;
    } catch (e) {
      throw Exception('Gagal menghapus absen anak sisi kegiatan: $e');
    }
  }
}
