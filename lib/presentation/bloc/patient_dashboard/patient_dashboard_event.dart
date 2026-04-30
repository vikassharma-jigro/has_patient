part of 'patient_dashboard_bloc.dart';

sealed class PatientDashboardEvent extends Equatable {
  const PatientDashboardEvent();

  @override
  List<Object> get props => [];
}

final class FetchPatientDashboard extends PatientDashboardEvent {
  const FetchPatientDashboard();
}
