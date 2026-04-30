import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hms_patient/app_helpers/models/doctor_availability_response_model.dart';
import 'package:hms_patient/app_helpers/models/doctors_avaliablity_model.dart';
import 'package:hms_patient/app_helpers/network/api_base_helper.dart';
import 'package:hms_patient/app_helpers/network/api_error.dart';

part 'new_booking_event.dart';
part 'new_booking_state.dart';

class NewBookingBloc extends Bloc<NewBookingEvent, NewBookingState> {
  final ApiBaseHelper _api = ApiBaseHelper();

  NewBookingBloc() : super(NewBookingInitial()) {
    on<FetchDoctors>(_onFetchDoctors);
    on<SelectDoctor>(_onSelectDoctor);
    on<CreateAppointment>(_onCreateAppointment);
  }

  Future<void> _onFetchDoctors(
    FetchDoctors event,
    Emitter<NewBookingState> emit,
  ) async {
    final currentState = state;
    int pageToFetch = 1;
    List<DoctorDetails> currentDoctors = [];

    if (!event.isRefresh && currentState is FetchDoctorsSuccess) {
      final totalPages = currentState.pagination.totalPages ?? 1;
      final currentPage = int.tryParse(currentState.pagination.page ?? '1') ?? 1;
      if (currentPage >= totalPages) return;
      pageToFetch = currentPage + 1;
      currentDoctors = List.from(currentState.doctors);
    } else {
      emit(NewBookingLoading());
    }

    try {
      final result = await _api.getBookingDoctors(queryParameters: {'page': pageToFetch});

      switch (result) {
        case ApiSuccess(:final data):
          final model = DoctorsAvailablityModel.fromMap(data);
          final newDoctors = model.data ?? [];
          emit(
            FetchDoctorsSuccess(
              doctors: event.isRefresh ? newDoctors : [...currentDoctors, ...newDoctors],
              pagination: model.pagination ?? Pagination(),
            ),
          );

        case ApiFailure(:final error):
          emit(FetchDoctorsFailure(error));
      }
    } catch (e) {
      emit(
        FetchDoctorsFailure(ApiError(type: ApiErrorType.unknown, message: e.toString())),
      );
    }
  }

  Future<void> _onSelectDoctor(
    SelectDoctor event,
    Emitter<NewBookingState> emit,
  ) async {
    if (state is FetchDoctorsSuccess) {
      final currentState = state as FetchDoctorsSuccess;
      emit(currentState.copyWith(isFetchingAvailability: true));

      final result = await _api.getDoctorAvailability(event.doctorId);

      switch (result) {
        case ApiSuccess(:final data):
          final availability = AvailabilityData.fromMap(data['data']);
          emit(currentState.copyWith(
            selectedDoctorAvailability: availability,
            isFetchingAvailability: false,
          ));
        case ApiFailure(:final error):
          emit(currentState.copyWith(isFetchingAvailability: false));
        // You might want to handle error more explicitly here
      }
    }
  }

  Future<void> _onCreateAppointment(
    CreateAppointment event,
    Emitter<NewBookingState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FetchDoctorsSuccess) return;

    emit(CreateAppointmentLoading(
      doctors: currentState.doctors,
      pagination: currentState.pagination,
      selectedDoctorAvailability: currentState.selectedDoctorAvailability,
    ));

    final result = await _api.createAppointment(
      doctor: event.doctor,
      time: event.time,
      bookingType: event.bookingType,
      consultantMode: event.consultantMode,
      department: event.department,
      doctorFee: event.doctorFee,
      opdDate: event.opdDate,
    );

    switch (result) {
      case ApiSuccess(:final data):
        emit(CreateAppointmentSuccess(
          appointmentID: data['appointmentID'],
          data: data['data'],
          doctors: currentState.doctors,
          pagination: currentState.pagination,
          selectedDoctorAvailability: currentState.selectedDoctorAvailability,
        ));
      case ApiFailure(:final error):
        emit(CreateAppointmentFailure(
          error,
          doctors: currentState.doctors,
          pagination: currentState.pagination,
          selectedDoctorAvailability: currentState.selectedDoctorAvailability,
        ));
    }
  }
}
