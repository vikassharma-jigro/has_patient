part of 'patient_registration_bloc.dart';

sealed class PatientRegistrationEvent extends Equatable {
  const PatientRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class NextStepEvent extends PatientRegistrationEvent {}

class PreviousStepEvent extends PatientRegistrationEvent {}

class JumpToStepEvent extends PatientRegistrationEvent {
  final int step;
  const JumpToStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

class UpdateFieldEvent extends PatientRegistrationEvent {
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? dob;
  final String? age;
  final String? mobile;
  final String? email;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? idProofType;
  final bool? isOPD;
  final bool? hasInsurance;
  final String? insuranceType;
  final String? insuranceSchema;
  final String? insuranceNumber;
  final bool? anyInfection;
  final bool? anyAllergy;
  final String? allergyName;
  final String? allergyDetail;
  final String? selectedDisease;
  final bool? isConfirmed;

  const UpdateFieldEvent({
    this.firstName,
    this.lastName,
    this.gender,
    this.dob,
    this.age,
    this.mobile,
    this.email,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.idProofType,
    this.isOPD,
    this.hasInsurance,
    this.insuranceType,
    this.insuranceSchema,
    this.insuranceNumber,
    this.anyInfection,
    this.anyAllergy,
    this.allergyName,
    this.allergyDetail,
    this.selectedDisease,
    this.isConfirmed,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        gender,
        dob,
        age,
        mobile,
        email,
        address,
        city,
        state,
        pincode,
        idProofType,
        isOPD,
        hasInsurance,
        insuranceType,
        insuranceSchema,
        insuranceNumber,
        anyInfection,
        anyAllergy,
        allergyName,
        allergyDetail,
        selectedDisease,
        isConfirmed,
      ];
}
