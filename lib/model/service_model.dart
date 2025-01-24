import 'package:absensi_bkr/model/attendance_model.dart';

class Service {
  String? id;
  List<AttendanceService>? attendance;
  String? date;
  String? name;
  String? time;

  Service({
    required this.id,
    required this.attendance,
    required this.date,
    required this.name,
    required this.time,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      attendance: (json['attendance'] as List<dynamic>?)
          ?.map((item) =>
              AttendanceService.fromJson(item as Map<String, dynamic>))
          .toList(),
      date: json['date'],
      name: json['name'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'attendance': attendance?.map((item) => item.toJson()).toList(),
      'date': date,
      'name': name,
      'time': time,
    };
  }

  @override
  String toString() {
    return 'Service(id: $id, attendance: $attendance, date: $date, name: $name, time: $time)';
  }
}
