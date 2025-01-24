class AttendanceService {
  String? id;
  String? kidsId;
  String? kidsName;
  String? method;
  String? timestamp;

  AttendanceService({
    required this.id,
    required this.kidsId,
    required this.kidsName,
    required this.method,
    required this.timestamp,
  });

  factory AttendanceService.fromJson(Map<String, dynamic> json) {
    return AttendanceService(
      id: json['_id'],
      kidsId: json['kidId'],
      kidsName: json['kidName'],
      method: json['method'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'kidId': kidsId,
      'kidName': kidsName,
      'method': method,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() =>
      'Absence(id: $id, kidId: $kidsId, kidName: $kidsName, method: $method, timestamp: $timestamp)';
}

class AttendanceKids {
  String? id;
  String? serviceId;
  String? serviceName;
  String? serviceDate;
  String? serviceTime;
  String? method;
  String? timestamp;

  AttendanceKids({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceDate,
    required this.serviceTime,
    required this.method,
    required this.timestamp,
  });

  factory AttendanceKids.fromJson(Map<String, dynamic> json) {
    return AttendanceKids(
      id: json['_id'],
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      serviceDate: json['serviceDate'],
      serviceTime: json['serviceTime'],
      method: json['method'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceDate': serviceDate,
      'serviceTime': serviceTime,
      'method': method,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'AttendanceKids(id: $id, serviceId: $serviceId, serviceName: $serviceName, serviceDate: $serviceDate, serviceTime: $serviceTime, method: $method, timestamp: $timestamp)';
  }
}

class GlobalAttendance {
  String? id;
  String? kidId;
  String? kidName;
  String? serviceId;
  String? serviceName;
  String? serviceDate;
  String? serviceTime;
  String? method;
  String? timestamp;

  GlobalAttendance({
    required this.id,
    required this.kidId,
    required this.kidName,
    required this.serviceId,
    required this.serviceName,
    required this.serviceDate,
    required this.serviceTime,
    required this.method,
    required this.timestamp,
  });

  factory GlobalAttendance.fromJson(Map<String, dynamic> json) {
    return GlobalAttendance(
      id: json['_id'],
      kidId: json['kidId'],
      kidName: json['kidName'],
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      serviceDate: json['serviceDate'],
      serviceTime: json['serviceTime'],
      method: json['method'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'kidId': kidId,
      'kidName': kidName,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceDate': serviceDate,
      'serviceTime': serviceTime,
      'method': method,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'AttendanceKids(id: $id, kidId: $kidId, kidName: $kidName, serviceId: $serviceId, serviceName: $serviceName, serviceDate: $serviceDate, serviceTime: $serviceTime, method: $method, timestamp: $timestamp)';
  }
}
