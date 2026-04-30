import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'patient_registration_event.dart';
part 'patient_registration_state.dart';

class PatientRegistrationBloc extends Bloc<PatientRegistrationEvent, PatientRegistrationState> {
  PatientRegistrationBloc() : super(const PatientRegistrationState()) {
    on<NextStepEvent>((event, emit) {
      if (state.currentStep < 3) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });

    on<PreviousStepEvent>((event, emit) {
      if (state.currentStep > 0) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<JumpToStepEvent>((event, emit) {
      emit(state.copyWith(currentStep: event.step));
    });

    on<UpdateFieldEvent>((event, emit) {
      emit(state.copyWith(
        firstName: event.firstName,
        lastName: event.lastName,
        gender: event.gender,
        dob: event.dob,
        age: event.age,
        mobile: event.mobile,
        email: event.email,
        address: event.address,
        city: event.city,
        state: event.state,
        pincode: event.pincode,
        idProofType: event.idProofType,
        isOPD: event.isOPD,
        hasInsurance: event.hasInsurance,
        insuranceType: event.insuranceType,
        insuranceSchema: event.insuranceSchema,
        insuranceNumber: event.insuranceNumber,
        anyInfection: event.anyInfection,
        anyAllergy: event.anyAllergy,
        allergyName: event.allergyName,
        allergyDetail: event.allergyDetail,
        selectedDisease: event.selectedDisease,
        isConfirmed: event.isConfirmed,
      ));
    });
  }
}
