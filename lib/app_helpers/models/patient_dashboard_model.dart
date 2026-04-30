import 'dart:convert';

class PatientDashboardModel {
  final bool? success;
  final String? message;
  final PatientData? data;

  PatientDashboardModel({
    this.success,
    this.message,
    this.data,
  });

  factory PatientDashboardModel.fromJson(String str) => PatientDashboardModel.fromMap(json.decode(str));

  factory PatientDashboardModel.fromMap(Map<String, dynamic> json) => PatientDashboardModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PatientData.fromMap(json["data"]),
  );
}

class PatientData {
  final String? id;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? dob;
  final String? mobile;
  final String? email;

  PatientData({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.dob,
    this.mobile,
    this.email,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory PatientData.fromMap(Map<String, dynamic> json) => PatientData(
    id: json["_id"],
    userId: json["userId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    gender: json["gender"],
    dob: json["dob"],
    mobile: json["mobile"],
    email: json["email"],
  );
}
