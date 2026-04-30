import 'dart:convert';

class LabReportsModel {
  final bool? success;
  final String? message;
  final List<dynamic>? data;
  final Pagination? pagination;

  LabReportsModel({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  LabReportsModel copyWith({
    bool? success,
    String? message,
    List<dynamic>? data,
    Pagination? pagination,
  }) =>
      LabReportsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory LabReportsModel.fromJson(String str) => LabReportsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LabReportsModel.fromMap(Map<String, dynamic> json) => LabReportsModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
    pagination: json["pagination"] == null ? null : Pagination.fromMap(json["pagination"]),
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    "pagination": pagination?.toMap(),
  };
}

class Pagination {
  final int? total;
  final int? page;
  final int? limit;
  final int? pages;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.pages,
  });

  Pagination copyWith({
    int? total,
    int? page,
    int? limit,
    int? pages,
  }) =>
      Pagination(
        total: total ?? this.total,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        pages: pages ?? this.pages,
      );

  factory Pagination.fromJson(String str) => Pagination.fromMap(json.decode(str));

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
