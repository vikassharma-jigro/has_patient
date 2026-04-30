import 'dart:convert';

class DoctorsAvailablityModel {
  final bool? success;
  final String? message;
  final List<DoctorDetails>? data;
  final Pagination? pagination;

  DoctorsAvailablityModel({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  DoctorsAvailablityModel copyWith({
    bool? success,
    String? message,
    List<DoctorDetails>? data,
    Pagination? pagination,
  }) =>
      DoctorsAvailablityModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory DoctorsAvailablityModel.fromJson(String str) => DoctorsAvailablityModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DoctorsAvailablityModel.fromMap(Map<String, dynamic> json) => DoctorsAvailablityModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<DoctorDetails>.from(json["data"]!.map((x) => DoctorDetails.fromMap(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromMap(json["pagination"]),
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "pagination": pagination?.toMap(),
  };
}

class DoctorDetails {
  final String? id;
  final HospitalId? hospitalId;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final List<String>? availableDays;
  final Documents? documents;
  final String? primarySpecialization;
  final String? qualification;
  final int? totalExperience;
  final AvailableTimeSlot? availableTimeSlot;
  final int? consultationFee;

  DoctorDetails({
    this.id,
    this.hospitalId,
    this.userId,
    this.firstName,
    this.lastName,
    this.availableDays,
    this.documents,
    this.primarySpecialization,
    this.qualification,
    this.totalExperience,
    this.availableTimeSlot,
    this.consultationFee,
  });

  DoctorDetails copyWith({
    String? id,
    HospitalId? hospitalId,
    String? userId,
    String? firstName,
    String? lastName,
    List<String>? availableDays,
    Documents? documents,
    String? primarySpecialization,
    String? qualification,
    int? totalExperience,
    AvailableTimeSlot? availableTimeSlot,
    int? consultationFee,
  }) =>
      DoctorDetails(
        id: id ?? this.id,
        hospitalId: hospitalId ?? this.hospitalId,
        userId: userId ?? this.userId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        availableDays: availableDays ?? this.availableDays,
        documents: documents ?? this.documents,
        primarySpecialization: primarySpecialization ?? this.primarySpecialization,
        qualification: qualification ?? this.qualification,
        totalExperience: totalExperience ?? this.totalExperience,
        availableTimeSlot: availableTimeSlot ?? this.availableTimeSlot,
        consultationFee: consultationFee ?? this.consultationFee,
      );

  factory DoctorDetails.fromJson(String str) => DoctorDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DoctorDetails.fromMap(Map<String, dynamic> json) => DoctorDetails(
    id: json["_id"],
    hospitalId: json["hospitalId"] == null ? null : HospitalId.fromMap(json["hospitalId"]),
    userId: json["userId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    availableDays: json["availableDays"] == null ? [] : List<String>.from(json["availableDays"]!.map((x) => x)),
    documents: json["documents"] == null ? null : Documents.fromMap(json["documents"]),
    primarySpecialization: json["primarySpecialization"],
    qualification: json["qualification"],
    totalExperience: json["totalExperience"],
    availableTimeSlot: json["availableTimeSlot"] == null ? null : AvailableTimeSlot.fromMap(json["availableTimeSlot"]),
    consultationFee: json["consultationFee"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "hospitalId": hospitalId?.toMap(),
    "userId": userId,
    "firstName": firstName,
    "lastName": lastName,
    "availableDays": availableDays == null ? [] : List<dynamic>.from(availableDays!.map((x) => x)),
    "documents": documents?.toMap(),
    "primarySpecialization": primarySpecialization,
    "qualification": qualification,
    "totalExperience": totalExperience,
    "availableTimeSlot": availableTimeSlot?.toMap(),
    "consultationFee": consultationFee,
  };
}

class AvailableTimeSlot {
  final String? from;
  final String? to;

  AvailableTimeSlot({
    this.from,
    this.to,
  });

  AvailableTimeSlot copyWith({
    String? from,
    String? to,
  }) =>
      AvailableTimeSlot(
        from: from ?? this.from,
        to: to ?? this.to,
      );

  factory AvailableTimeSlot.fromJson(String str) => AvailableTimeSlot.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AvailableTimeSlot.fromMap(Map<String, dynamic> json) => AvailableTimeSlot(
    from: json["from"],
    to: json["to"],
  );

  Map<String, dynamic> toMap() => {
    "from": from,
    "to": to,
  };
}

class Documents {
  final List<String>? photo;

  Documents({
    this.photo,
  });

  Documents copyWith({
    List<String>? photo,
  }) =>
      Documents(
        photo: photo ?? this.photo,
      );

  factory Documents.fromJson(String str) => Documents.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Documents.fromMap(Map<String, dynamic> json) => Documents(
    photo: json["photo"] == null ? [] : List<String>.from(json["photo"]!.map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "photo": photo == null ? [] : List<dynamic>.from(photo!.map((x) => x)),
  };
}

class HospitalId {
  final String? id;
  final String? hospitalName;

  HospitalId({
    this.id,
    this.hospitalName,
  });

  HospitalId copyWith({
    String? id,
    String? hospitalName,
  }) =>
      HospitalId(
        id: id ?? this.id,
        hospitalName: hospitalName ?? this.hospitalName,
      );

  factory HospitalId.fromJson(String str) => HospitalId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HospitalId.fromMap(Map<String, dynamic> json) => HospitalId(
    id: json["_id"],
    hospitalName: json["hospitalName"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "hospitalName": hospitalName,
  };
}

class Pagination {
  final int? total;
  final String? page;
  final String? limit;
  final int? totalPages;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  Pagination copyWith({
    int? total,
    String? page,
    String? limit,
    int? totalPages,
  }) =>
      Pagination(
        total: total ?? this.total,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        totalPages: totalPages ?? this.totalPages,
      );

  factory Pagination.fromJson(String str) => Pagination.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toMap() => {
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}
