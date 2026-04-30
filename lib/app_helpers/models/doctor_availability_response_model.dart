import 'dart:convert';

class DoctorAvailabilityResponse {
  final bool? success;
  final AvailabilityData? data;

  DoctorAvailabilityResponse({
    this.success,
    this.data,
  });

  factory DoctorAvailabilityResponse.fromJson(String str) => DoctorAvailabilityResponse.fromMap(json.decode(str));

  factory DoctorAvailabilityResponse.fromMap(Map<String, dynamic> json) => DoctorAvailabilityResponse(
    success: json["success"],
    data: json["data"] == null ? null : AvailabilityData.fromMap(json["data"]),
  );
}

class AvailabilityData {
  final List<AvailableDay>? availableDays;
  final TimeSlotRange? timeSlot;

  AvailabilityData({
    this.availableDays,
    this.timeSlot,
  });

  factory AvailabilityData.fromMap(Map<String, dynamic> json) => AvailabilityData(
    availableDays: json["availableDays"] == null ? [] : List<AvailableDay>.from(json["availableDays"]!.map((x) => AvailableDay.fromMap(x))),
    timeSlot: json["timeSlot"] == null ? null : TimeSlotRange.fromMap(json["timeSlot"]),
  );
}

class AvailableDay {
  final String? day;
  final int? date;
  final String? fullDate;
  final DateTime? dateObj;
  final List<String>? availableSlots;

  AvailableDay({
    this.day,
    this.date,
    this.fullDate,
    this.dateObj,
    this.availableSlots,
  });

  factory AvailableDay.fromMap(Map<String, dynamic> json) => AvailableDay(
    day: json["day"],
    date: json["date"],
    fullDate: json["fullDate"],
    dateObj: json["dateObj"] == null ? null : DateTime.parse(json["dateObj"]),
    availableSlots: json["availableSlots"] == null ? [] : List<String>.from(json["availableSlots"]!.map((x) => x)),
  );
}

class TimeSlotRange {
  final String? from;
  final String? to;

  TimeSlotRange({
    this.from,
    this.to,
  });

  factory TimeSlotRange.fromMap(Map<String, dynamic> json) => TimeSlotRange(
    from: json["from"],
    to: json["to"],
  );
}
