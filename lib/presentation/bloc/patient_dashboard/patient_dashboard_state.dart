part of 'patient_dashboard_bloc.dart';

sealed class PatientDashboardState extends Equatable {
  const PatientDashboardState();
  
  @override
  List<Object?> get props => [];
}

final class PatientDashboardInitial extends PatientDashboardState {}

final class PatientDashboardLoading extends PatientDashboardState {}

final class PatientDashboardSuccess extends PatientDashboardState {
  final PatientData data;
  const PatientDashboardSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

final class PatientDashboardFailure extends PatientDashboardState {
  final ApiError error;
  const PatientDashboardFailure(this.error);

  @override
  List<Object?> get props => [error];
}
