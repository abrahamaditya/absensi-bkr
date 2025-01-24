import 'package:absensi_bkr/model/attendance_model.dart';

class Kid {
  String? id;
  String? name;
  String? birthdate;
  String? parentName;
  String? mobile;
  String? address;
  String? grade;
  List<AttendanceKids>? attendance;

  Kid({
    required this.id,
    required this.name,
    required this.birthdate,
    required this.parentName,
    required this.mobile,
    required this.address,
    required this.grade,
    required this.attendance,
  });

  factory Kid.fromJson(Map<String, dynamic> json) {
    return Kid(
      id: json['_id'],
      name: json['name'],
      birthdate: json['birthDate'],
      parentName: json['parents'],
      mobile: json['mobile'],
      address: json['address'],
      grade: json['grade'],
      attendance: (json['attendance'] as List<dynamic>?)
          ?.map((item) => AttendanceKids.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'birthDate': birthdate,
      'parents': parentName,
      'mobile': mobile,
      'address': address,
      'grade': grade,
      'attendance': attendance?.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Kid(id: $id, name: $name, birthdate: $birthdate, parentName: $parentName, phoneNumber: $mobile, address: $address, grade: $grade, attendance: $attendance)';
  }
}
