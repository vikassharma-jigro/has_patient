part of 'my_booking_bloc.dart';

sealed class MyBookingEvent extends Equatable {
  const MyBookingEvent();
}

final class MyBookingFetch extends MyBookingEvent {
  const MyBookingFetch();
  @override
  List<Object> get props => [];
}

final class PatientInvoicesFetch extends MyBookingEvent {
  const PatientInvoicesFetch();
  @override
  List<Object> get props => [];
}