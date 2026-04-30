part of 'lab_reports_bloc.dart';

sealed class LabReportsEvent extends Equatable {
  const LabReportsEvent();
}
final class FetchLabReports extends LabReportsEvent {
  final bool isRefresh;
  const FetchLabReports({this.isRefresh = false});
  @override
  List<Object> get props => [isRefresh];
}

final class UploadLabReport extends LabReportsEvent {
  final String documentName;
  final String filePath;

  const UploadLabReport({
    required this.documentName,
    required this.filePath,
  });

  @override
  List<Object> get props => [documentName, filePath];
}
