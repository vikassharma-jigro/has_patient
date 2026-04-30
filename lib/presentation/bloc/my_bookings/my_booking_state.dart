part of 'my_booking_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sub-states — one per tab, fully independent
// ─────────────────────────────────────────────────────────────────────────────

sealed class BookingSubState extends Equatable {
  const BookingSubState();
}

final class BookingSubInitial extends BookingSubState {
  @override List<Object> get props => [];
}

final class BookingSubLoading extends BookingSubState {
  @override List<Object> get props => [];
}

final class BookingSubSuccess extends BookingSubState {
  final List<BookDetails> data;
  final Pagination pagination;
  const BookingSubSuccess(this.data, this.pagination);
  @override List<Object> get props => [data, pagination];
}

final class BookingSubFailure extends BookingSubState {
  final ApiError error;
  const BookingSubFailure(this.error);
  @override List<Object> get props => [error];
}

// ─────────────────────────────────────────────────────────────────────────────

sealed class InvoiceSubState extends Equatable {
  const InvoiceSubState();
}

final class InvoiceSubInitial extends InvoiceSubState {
  @override List<Object> get props => [];
}

final class InvoiceSubLoading extends InvoiceSubState {
  @override List<Object> get props => [];
}

final class InvoiceSubSuccess extends InvoiceSubState {
  final List<BookDetails> data;
  final Pagination pagination;
  const InvoiceSubSuccess(this.data, this.pagination);
  @override List<Object> get props => [data, pagination];
}

final class InvoiceSubFailure extends InvoiceSubState {
  final ApiError error;
  const InvoiceSubFailure(this.error);
  @override List<Object> get props => [error];
}

// ─────────────────────────────────────────────────────────────────────────────
// Root state — composes both sub-states into a single BLoC state
// ─────────────────────────────────────────────────────────────────────────────

final class MyBookingState extends Equatable {
  final BookingSubState bookings;
  final InvoiceSubState invoices;

  const MyBookingState({
    required this.bookings,
    required this.invoices,
  });

  /// Initial state — both tabs idle.
   MyBookingState.initial()
      : bookings = BookingSubInitial(),
        invoices = InvoiceSubInitial();

  /// Copies the root state, replacing only the changed sub-state.
  /// The unchanged tab keeps its current data untouched.
  MyBookingState copyWith({
    BookingSubState? bookings,
    InvoiceSubState? invoices,
  }) =>
      MyBookingState(
        bookings: bookings ?? this.bookings,
        invoices: invoices ?? this.invoices,
      );

  @override
  List<Object> get props => [bookings, invoices];
}