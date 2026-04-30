part of 'new_booking_bloc.dart';

sealed class NewBookingEvent extends Equatable {
  const NewBookingEvent();
}
final class FetchDoctors extends NewBookingEvent {
  final bool isRefresh;
  const FetchDoctors({this.isRefresh = true});
  @override
  List<Object?> get props => [isRefresh];
}

final class SelectDoctor extends NewBookingEvent {
  final String doctorId;
  const SelectDoctor(this.doctorId);
  @override
  List<Object?> get props => [doctorId];
}

final class CreateAppointment extends NewBookingEvent {
  final String doctor;
  final String time;
  final String bookingType;
  final String consultantMode;
  final String department;
  final int doctorFee;
  final String opdDate;

  const CreateAppointment({
    required this.doctor,
    required this.time,
    required this.bookingType,
    required this.consultantMode,
    required this.department,
    required this.doctorFee,
    required this.opdDate,
  });

  @override
  List<Object?> get props => [
        doctor,
        time,
        bookingType,
        consultantMode,
        department,
        doctorFee,
        opdDate,
      ];
}

