import 'dart:convert';

class PaitentBookings {
  final bool? success;
  final String? message;
  final List<BookDetails>? data;
  final Pagination? pagination;

  PaitentBookings({this.success, this.message, this.data, this.pagination});

  PaitentBookings copyWith({
    bool? success,
    String? message,
    List<BookDetails>? data,
    Pagination? pagination,
  }) => PaitentBookings(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    pagination: pagination ?? this.pagination,
  );

  factory PaitentBookings.fromJson(String str) =>
      PaitentBookings.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaitentBookings.fromMap(Map<String, dynamic> json) => PaitentBookings(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<BookDetails>.from(
            json["data"]!.map((x) => BookDetails.fromMap(x)),
          ),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromMap(json["pagination"]),
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "pagination": pagination?.toMap(),
  };
}

class BookDetails {
  final String? id;
  final String? userId;
  final DateTime? opdDate;
  final String? time;
  final String? department;
  final PatientBookingDoctor? doctor;
  final String? status;

  BookDetails({
    this.id,
    this.userId,
    this.opdDate,
    this.time,
    this.department,
    this.doctor,
    this.status,
  });

  BookDetails copyWith({
    String? id,
    String? userId,
    DateTime? opdDate,
    String? time,
    String? department,
    PatientBookingDoctor? doctor,
    String? status,
  }) => BookDetails(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    opdDate: opdDate ?? this.opdDate,
    time: time ?? this.time,
    department: department ?? this.department,
    doctor: doctor ?? this.doctor,
    status: status ?? this.status,
  );

  factory BookDetails.fromJson(String str) =>
      BookDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BookDetails.fromMap(Map<String, dynamic> json) => BookDetails(
    id: json["_id"],
    userId: json["userId"],
    opdDate: json["opdDate"] == null ? null : DateTime.parse(json["opdDate"]),
    time: json["time"],
    department: json["department"],
    doctor: json["doctor"] == null ? null : PatientBookingDoctor.fromMap(json["doctor"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "userId": userId,
    "opdDate": opdDate?.toIso8601String(),
    "time": time,
    "department": department,
    "doctor": doctor?.toMap(),
    "status": status,
  };
}

class PatientBookingDoctor {
  final String? id;
  final String? userId;
  final String? firstName;
  final String? lastName;

  PatientBookingDoctor({this.id, this.userId, this.firstName, this.lastName});

  PatientBookingDoctor copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
  }) => PatientBookingDoctor(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
  );

  factory PatientBookingDoctor.fromJson(String str) => PatientBookingDoctor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PatientBookingDoctor.fromMap(Map<String, dynamic> json) => PatientBookingDoctor(
    id: json["_id"],
    userId: json["userId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "userId": userId,
    "firstName": firstName,
    "lastName": lastName,
  };
}

class Pagination {
  final int? total;
  final int? page;
  final int? limit;
  final int? pages;

  Pagination({this.total, this.page, this.limit, this.pages});

  Pagination copyWith({int? total, int? page, int? limit, int? pages}) =>
      Pagination(
        total: total ?? this.total,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        pages: pages ?? this.pages,
      );

  factory Pagination.fromJson(String str) =>
      Pagination.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    pages: json["pages"],
  );

  Map<String, dynamic> toMap() => {
    "total": total,
    "page": page,
    "limit": limit,
    "pages": pages,
  };
}
