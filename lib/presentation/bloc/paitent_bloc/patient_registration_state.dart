part of 'patient_registration_bloc.dart';

const _kUnset = Object();

enum PatientRegistrationStatus {
  initial,
  loading,
  step1Success,
  success,
  failure,
}

class PatientRegistrationState extends Equatable {
  const PatientRegistrationState({
    this.status = PatientRegistrationStatus.initial,
    this.error,
    this.successMessage,
    this.registeredId = '',
    this.currentStep = 0,
    this.isOPD = true,
    // Step 1 — Basic Details
    this.firstName = '',
    this.lastName = '',
    this.gender = '',
    this.dob = '',
    this.age = '',
    this.mobile = '',
    this.email = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.idProofType = '',
    this.idProofNumber = '',
    // Step 2 — Insurance & Medical
    this.hasInsurance = false,
    this.insuranceType,
    this.insuranceSchema = '',
    this.insuranceNumber = '',
    this.anyInfection = false,
    this.anyAllergy = false,
    this.allergyName = '',
    this.allergyDetail = '',
    // Step 3 — Review
    this.isConfirmed = false,
  });

  final PatientRegistrationStatus status;
  final ApiError? error;
  final String? successMessage;
  final String registeredId;
  final int currentStep;
  final bool isOPD;

  // Step 1
  final String firstName;
  final String lastName;
  final String gender;
  final String dob;
  final String age;
  final String mobile;
  final String email;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String idProofType;
  final String idProofNumber;

  // Step 2
  final bool hasInsurance;
  final String? insuranceType; // nullable — user may not select
  final String insuranceSchema;
  final String insuranceNumber;
  final bool anyInfection;
  final bool anyAllergy;
  final String allergyName;
  final String allergyDetail;

  // Step 3
  final bool isConfirmed;

  // FIX BUG 19: insuranceType uses sentinel so it can be cleared to null.
  PatientRegistrationState copyWith({
    PatientRegistrationStatus? status,
    ApiError? error,
    String? successMessage,
    String? registeredId,
    int? currentStep,
    bool? isOPD,
    String? firstName,
    String? lastName,
    String? gender,
    String? dob,
    String? age,
    String? mobile,
    String? email,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? idProofType,
    String? idProofNumber,
    bool? hasInsurance,
    Object? insuranceType = _kUnset, // sentinel default
    String? insuranceSchema,
    String? insuranceNumber,
    bool? anyInfection,
    bool? anyAllergy,
    String? allergyName,
    String? allergyDetail,
    bool? isConfirmed,
  }) {
    return PatientRegistrationState(
      status: status ?? this.status,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
      registeredId: registeredId ?? this.registeredId,
      currentStep: currentStep ?? this.currentStep,
      isOPD: isOPD ?? this.isOPD,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      idProofType: idProofType ?? this.idProofType,
      idProofNumber: idProofNumber ?? this.idProofNumber,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      // Sentinel: _kUnset means "don't change"; null means "clear to null"
      insuranceType: identical(insuranceType, _kUnset)
          ? this.insuranceType
          : insuranceType as String?,
      insuranceSchema: insuranceSchema ?? this.insuranceSchema,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      anyInfection: anyInfection ?? this.anyInfection,
      anyAllergy: anyAllergy ?? this.anyAllergy,
      allergyName: allergyName ?? this.allergyName,
      allergyDetail: allergyDetail ?? this.allergyDetail,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  @override
  List<Object?> get props => [
    status,
    error,
    successMessage,
    registeredId,
    currentStep,
    isOPD,
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
    hasInsurance,
    insuranceType,
    insuranceSchema,
    insuranceNumber,
    anyInfection,
    anyAllergy,
    allergyName,
    allergyDetail,
    isConfirmed,
  ];
}
