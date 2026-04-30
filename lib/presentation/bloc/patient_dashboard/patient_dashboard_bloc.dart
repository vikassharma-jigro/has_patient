import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hms_patient/app_helpers/network/api_base_helper.dart';
import 'package:hms_patient/app_helpers/network/api_error.dart';
import 'package:hms_patient/app_helpers/models/patient_dashboard_model.dart';

part 'patient_dashboard_event.dart';
part 'patient_dashboard_state.dart';

class PatientDashboardBloc extends Bloc<PatientDashboardEvent, PatientDashboardState> {
  final ApiBaseHelper api;

  PatientDashboardBloc({required this.api}) : super(PatientDashboardInitial()) {
    on<FetchPatientDashboard>(_onFetchPatientDashboard);
  }

  Future<void> _onFetchPatientDashboard(
    FetchPatientDashboard event,
    Emitter<PatientDashboardState> emit,
  ) async {
    emit(PatientDashboardLoading());
    final result = await api.getPatientDashboard();

    if (result is ApiSuccess<Map<String, dynamic>>) {
      final model = PatientDashboardModel.fromMap(result.data);
      if (model.data != null) {
        emit(PatientDashboardSuccess(model.data!));
      } else {
        emit(const PatientDashboardFailure(ApiError(type : ApiErrorType.notFound, message: 'No data found')));
      }
    } else if (result is ApiFailure<Map<String, dynamic>>) {
      emit(PatientDashboardFailure(result.error));
    }
  }
}
