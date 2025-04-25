import 'package:intl/intl.dart';

DateTime now = DateTime.now();
String dateNow = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);

String formatTanggalEEEEDDMMMMYYYYIndonesia(String? date) {
  try {
    final parsedDate = DateTime.parse(date!);
    final formatter = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    return formatter.format(parsedDate);
  } catch (e) {
    return "Tanggal tidak valid";
  }
}

String formatJadiHHMMSSDariString(String timestamp) {
  return timestamp.split(', ')[1];
}

String formatJadiDDMMMMYYYYIndonesia(String? dateString) {
  try {
    if (dateString == null) {
      return "-";
    }
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  } catch (e) {
    return "Tanggal tidak valid";
  }
}

String formatJadiYYYYMMDD(String? formattedDate) {
  try {
    // Menyusun format yang sesuai dengan input yang Anda terima
    final formatter = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    final date = formatter.parse(formattedDate!);

    // Mengembalikan tanggal dalam format YYYY-MM-DD
    final dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  } catch (e) {
    return "Tanggal tidak valid";
  }
}

String ambilWaktuSekarang() {
  final now = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd, HH:mm:ss');
  return formatter.format(now);
}

DateTime formatYYYYMMDDHHMMSS(String timestamp) {
  List<String> dateTimeParts = timestamp.split(', ');
  String datePart = dateTimeParts[0]; // "YYYY-MM-DD"
  String timePart = dateTimeParts[1]; // "HH:MM:SS"

  List<String> dateParts = datePart.split('-');
  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);

  List<String> timeParts = timePart.split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  int second = int.parse(timeParts[2]);

  return DateTime(year, month, day, hour, minute, second);
}

DateTime formatTimestamp(String date, String time) {
  // Format asli dari element.date
  final DateFormat originalDateFormat =
      DateFormat("EEEE, dd MMMM yyyy", "id_ID");

  final DateTime parsedDate = originalDateFormat.parse(date);

  // Parse waktu (formatnya sudah benar, jadi bisa langsung dipecah)
  final List<String> timeParts = time.split(":");
  final int hour = int.parse(timeParts[0]);
  final int minute = int.parse(timeParts[1]);

  return DateTime(
      parsedDate.year, parsedDate.month, parsedDate.day, hour, minute);
}

String formatAwalanAngka(String dateString) {
  DateTime date = DateFormat("EEEE, dd MMMM y", "id_ID").parse(dateString);
  return DateFormat("EEEE, d MMMM y", "id_ID").format(date);
}
