part of 'new_booking_bloc.dart';

sealed class NewBookingState extends Equatable {
  const NewBookingState();
}

final class NewBookingInitial extends NewBookingState {
  @override
  List<Object> get props => [];
}

final class NewBookingLoading extends NewBookingState {
  @override
  List<Object> get props => [];
}

final class FetchDoctorsSuccess extends NewBookingState {
  final List<DoctorDetails> doctors;
  final Pagination pagination;
  final AvailabilityData? selectedDoctorAvailability;
  final bool isFetchingAvailability;

  const FetchDoctorsSuccess({
    required this.doctors,
    required this.pagination,
    this.selectedDoctorAvailability,
    this.isFetchingAvailability = false,
  });

  FetchDoctorsSuccess copyWith({
    List<DoctorDetails>? doctors,
    Pagination? pagination,
    AvailabilityData? selectedDoctorAvailability,
    bool? isFetchingAvailability,
  }) {
    return FetchDoctorsSuccess(
      doctors: doctors ?? this.doctors,
      pagination: pagination ?? this.pagination,
      selectedDoctorAvailability: selectedDoctorAvailability ?? this.selectedDoctorAvailability,
      isFetchingAvailability: isFetchingAvailability ?? this.isFetchingAvailability,
    );
  }

  @override
  List<Object?> get props => [doctors, pagination, selectedDoctorAvailability, isFetchingAvailability];
}

final class FetchDoctorsFailure extends NewBookingState {
  final ApiError error;
  const FetchDoctorsFailure(this.error);
  @override
  List<Object> get props => [error];
}

final class CreateAppointmentLoading extends NewBookingState {
  final List<DoctorDetails> doctors;
  final Pagination pagination;
  final AvailabilityData? selectedDoctorAvailability;

  const CreateAppointmentLoading({
    required this.doctors,
    required this.pagination,
    this.selectedDoctorAvailability,
  });

  @override
  List<Object?> get props => [doctors, pagination, selectedDoctorAvailability];
}

final class CreateAppointmentSuccess extends NewBookingState {
  final String appointmentID;
  final Map<String, dynamic> data;
  final List<DoctorDetails> doctors;
  final Pagination pagination;
  final AvailabilityData? selectedDoctorAvailability;

  const CreateAppointmentSuccess({
    required this.appointmentID,
    required this.data,
    required this.doctors,
    required this.pagination,
    this.selectedDoctorAvailability,
  });

  @override
  List<Object?> get props => [appointmentID, data, doctors, pagination, selectedDoctorAvailability];
}

final class CreateAppointmentFailure extends NewBookingState {
  final ApiError error;
  final List<DoctorDetails> doctors;
  final Pagination pagination;
  final AvailabilityData? selectedDoctorAvailability;

  const CreateAppointmentFailure(
    this.error, {
    required this.doctors,
    required this.pagination,
    this.selectedDoctorAvailability,
  });

  @override
  List<Object?> get props => [error, doctors, pagination, selectedDoctorAvailability];
}
