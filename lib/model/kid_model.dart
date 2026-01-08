// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:absensi_bkr/model/attendance_model.dart';

class Kid {
  String? id;
  String? name;
  String? birthdate;
  String? parentName;
  String? mobile;
  String? address;
  String? school;
  String? grade;
  List<AttendanceKids>? attendance;
  bool? isDataComplete;
  bool? isDelivered;
  bool? isPrinted;
  String? updatedAt;
  String? createdAt;

  Kid({
    required this.id,
    required this.name,
    required this.birthdate,
    required this.parentName,
    required this.mobile,
    required this.address,
    required this.school,
    required this.grade,
    required this.attendance,
    required this.isDataComplete,
    required this.isDelivered,
    required this.isPrinted,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Kid.fromJson(Map<String, dynamic> json) {
    return Kid(
      id: json['_id'],
      name: json['name'],
      birthdate: json['birthDate'],
      parentName: json['parents'],
      mobile: json['mobile'],
      address: json['address'],
      school: json['school'],
      grade: json['grade'],
      attendance: (json['attendance'] as List<dynamic>?)
          ?.map((item) => AttendanceKids.fromJson(item as Map<String, dynamic>))
          .toList(),
      isDataComplete: json['isDataComplete'],
      isDelivered: json['isDelivered'],
      isPrinted: json['isPrinted'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
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
      'school': school,
      'grade': grade,
      'attendance': attendance?.map((item) => item.toJson()).toList(),
      'isDataComplete': isDataComplete,
      'isDelivered': isDelivered,
      'isPrinted': isPrinted,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'Kid(id: $id, name: $name, birthdate: $birthdate, parentName: $parentName, mobile: $mobile, address: $address, school: $school, grade: $grade, attendance: $attendance, isDataComplete: $isDataComplete, isDelivered: $isDelivered, isPrinted: $isPrinted, updatedAt: $updatedAt, createdAt: $createdAt)';
  }
}
