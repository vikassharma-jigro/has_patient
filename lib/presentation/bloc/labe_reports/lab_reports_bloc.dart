import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hms_patient/app_helpers/network/api_base_helper.dart';
import 'package:hms_patient/app_helpers/network/api_error.dart';
import 'package:hms_patient/app_helpers/models/lab_reports_model.dart';

part 'lab_reports_event.dart';
part 'lab_reports_state.dart';

class LabReportsBloc extends Bloc<LabReportsEvent, LabReportsState> {
  final ApiBaseHelper api;

  LabReportsBloc({required this.api}) : super(LabReportsInitial()) {
    on<FetchLabReports>(_onFetchLabReports);
    on<UploadLabReport>(_onUploadLabReport);
  }

  Future<void> _onUploadLabReport(
    UploadLabReport event,
    Emitter<LabReportsState> emit,
  ) async {
    emit(UploadReportLoading());
    final result = await api.uploadDocument(
      documentName: event.documentName,
      filePath: event.filePath,
    );

    if (result is ApiSuccess<Map<String, dynamic>>) {
      emit(UploadReportSuccess(result.data['message'] ?? "Document uploaded successfully"));
      add(const FetchLabReports(isRefresh: true));
    } else if (result is ApiFailure<Map<String, dynamic>>) {
      emit(UploadReportFailure(result.error));
    }
  }

  Future<void> _onFetchLabReports(
    FetchLabReports event,
    Emitter<LabReportsState> emit,
  ) async {
    final currentState = state;
    int pageToFetch = 1;
    List<dynamic> currentData = [];

    if (!event.isRefresh && currentState is LabReportsSuccess) {
      if (currentState.pagination.page != null &&
          currentState.pagination.pages != null &&
          currentState.pagination.page! >= currentState.pagination.pages!) {
        return; // No more pages
      }
      pageToFetch = (currentState.pagination.page ?? 1) + 1;
      currentData = List.from(currentState.data);
    } else {
      emit(LabReportsLoading());
    }

    final result = await api.getLabReports(
      queryParameters: {
        'page': pageToFetch,
        'limit': 10,
        'type': 'lab',
      },
    );

    if (result is ApiSuccess<Map<String, dynamic>>) {
      final model = LabReportsModel.fromMap(result.data);
      final newData = model.data ?? [];
      
      if (model.pagination != null) {
        emit(LabReportsSuccess(
          event.isRefresh ? newData : [...currentData, ...newData],
          model.pagination!,
        ));
      } else {
        emit(LabReportsSuccess(
          event.isRefresh ? newData : [...currentData, ...newData],
          Pagination(total: 0, page: pageToFetch, limit: 10, pages: 1),
        ));
      }
    } else if (result is ApiFailure<Map<String, dynamic>>) {
      emit(LabReportsFailure(result.error));
    }
  }
}
