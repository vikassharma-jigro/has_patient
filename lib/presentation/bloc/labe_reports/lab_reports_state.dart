part of 'lab_reports_bloc.dart';

sealed class LabReportsState extends Equatable {
  const LabReportsState();
}

final class LabReportsInitial extends LabReportsState {
  @override
  List<Object> get props => [];
}
final class LabReportsLoading extends LabReportsState {
  @override
  List<Object> get props => [];
}
final class LabReportsSuccess extends LabReportsState {
  final List<dynamic> data;
  final Pagination pagination;
  const LabReportsSuccess(this.data, this.pagination);
  @override
  List<Object> get props => [data, pagination];
}
final class LabReportsFailure extends LabReportsState {
  final ApiError error;
  const LabReportsFailure(this.error);
  @override
  List<Object> get props => [error];
}

final class UploadReportLoading extends LabReportsState {
  @override
  List<Object> get props => [];
}

final class UploadReportSuccess extends LabReportsState {
  final String message;
  const UploadReportSuccess(this.message);
  @override
  List<Object> get props => [message];
}

final class UploadReportFailure extends LabReportsState {
  final ApiError error;
  const UploadReportFailure(this.error);
  @override
  List<Object> get props => [error];
}
