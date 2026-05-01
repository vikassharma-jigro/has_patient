part of 'patient_registration_bloc.dart';

sealed class PatientRegistrationEvent extends Equatable {
  const PatientRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class NextStepEvent extends PatientRegistrationEvent {
  const NextStepEvent();
}

class PreviousStepEvent extends PatientRegistrationEvent {
  const PreviousStepEvent();
}

class JumpToStepEvent extends PatientRegistrationEvent {
  final int step;
  const JumpToStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

final class UpdateFieldEvent extends PatientRegistrationEvent {
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
    this.idProofNumber,
    this.isOPD,
    this.hasInsurance,
    this.insuranceType,
    this.clearInsuranceType = false, // sentinel to explicitly clear nullable
    this.insuranceSchema,
    this.insuranceNumber,
    this.anyInfection,
    this.anyAllergy,
    this.allergyName,
    this.allergyDetail,
    this.seriousDiseases,
    this.isConfirmed,
  });

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
  final String? idProofNumber;
  final bool? isOPD;
  final bool? hasInsurance;
  final String? insuranceType;
  final bool clearInsuranceType;
  final String? insuranceSchema;
  final String? insuranceNumber;
  final bool? anyInfection;
  final bool? anyAllergy;
  final String? allergyName;
  final String? allergyDetail;
  final List<String>? seriousDiseases;
  final bool? isConfirmed;

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
        idProofNumber,
        isOPD,
        hasInsurance,
        insuranceType,
        clearInsuranceType,
        insuranceSchema,
        insuranceNumber,
        anyInfection,
        anyAllergy,
        allergyName,
        allergyDetail,
        seriousDiseases,
        isConfirmed,
      ];
}

class SubmitBasicDetailsEvent extends PatientRegistrationEvent {
  const SubmitBasicDetailsEvent();
}

class SubmitFullRegistrationEvent extends PatientRegistrationEvent {
  const SubmitFullRegistrationEvent();
}
