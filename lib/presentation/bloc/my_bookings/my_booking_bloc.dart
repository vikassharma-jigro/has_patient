import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_patient/app_helpers/models/paitent_bookings_models.dart';
import 'package:hms_patient/app_helpers/network/api_base_helper.dart';
import 'package:hms_patient/app_helpers/network/api_error.dart';

part 'my_booking_event.dart';
part 'my_booking_state.dart';

class MyBookingBloc extends Bloc<MyBookingEvent, MyBookingState> {
  final ApiBaseHelper _api;

  MyBookingBloc({required ApiBaseHelper api})
    : _api = api,
      super(MyBookingState.initial()) {
    on<MyBookingFetch>(_onBookingFetch);
    on<PatientInvoicesFetch>(_onInvoicesFetch);
  }

  // ── Tab 1: Bookings ────────────────────────────────────────────────────────

  Future<void> _onBookingFetch(
    MyBookingFetch event,
    Emitter<MyBookingState> emit,
  ) async {
    // Only update the bookings sub-state — invoices sub-state is untouched.
    emit(state.copyWith(bookings: BookingSubLoading()));

    final result = await _api.getMyBookings();

    switch (result) {
      case ApiSuccess(:final data):
        final list = _parseBookings(data);
        final pagination = _parsePagination(data);
        emit(state.copyWith(bookings: BookingSubSuccess(list, pagination)));

      case ApiFailure(:final error):
        emit(state.copyWith(bookings: BookingSubFailure(error)));
    }
  }

  // ── Tab 2: Invoices ────────────────────────────────────────────────────────

  Future<void> _onInvoicesFetch(
    PatientInvoicesFetch event,
    Emitter<MyBookingState> emit,
  ) async {
    // Only update the invoices sub-state — bookings sub-state is untouched.
    emit(state.copyWith(invoices: InvoiceSubLoading()));

    final result = await _api.getInvoices();

    switch (result) {
      case ApiSuccess(:final data):
        final list = _parseBookings(data);
        final pagination = _parsePagination(data);
        emit(state.copyWith(invoices: InvoiceSubSuccess(list, pagination)));

      case ApiFailure(:final error):
        emit(state.copyWith(invoices: InvoiceSubFailure(error)));
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  List<BookDetails> _parseBookings(Map<String, dynamic> data) {
    if (data['data'] == null) return [];
    return List<BookDetails>.from(
      (data['data'] as List).map(
        (x) => BookDetails.fromMap(x as Map<String, dynamic>),
      ),
    );
  }

  Pagination _parsePagination(Map<String, dynamic> data) {
    if (data['pagination'] == null) return Pagination();
    return Pagination.fromMap(data['pagination'] as Map<String, dynamic>);
  }
}
