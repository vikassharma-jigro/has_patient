part of 'patient_registration_bloc.dart';

class PatientRegistrationState extends Equatable {
  final int currentStep;
  final bool isOPD;
  
  // Step 1: Basic Details
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

  // Step 2: Insurance
  final bool hasInsurance;
  final String? insuranceType;
  final String insuranceSchema;
  final String insuranceNumber;
  final bool anyInfection;
  final bool anyAllergy;
  final String allergyName;
  final String allergyDetail;

  // Step 3: Disease
  final String? selectedDisease;

  // Step 4: Review
  final bool isConfirmed;

  const PatientRegistrationState({
    this.currentStep = 0,
    this.isOPD = true,
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
    this.hasInsurance = false,
    this.insuranceType,
    this.insuranceSchema = '',
    this.insuranceNumber = '',
    this.anyInfection = false,
    this.anyAllergy = false,
    this.allergyName = '',
    this.allergyDetail = '',
    this.selectedDisease,
    this.isConfirmed = false,
  });

  PatientRegistrationState copyWith({
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
    bool? hasInsurance,
    String? insuranceType,
    String? insuranceSchema,
    String? insuranceNumber,
    bool? anyInfection,
    bool? anyAllergy,
    String? allergyName,
    String? allergyDetail,
    String? selectedDisease,
    bool? isConfirmed,
  }) {
    return PatientRegistrationState(
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
      hasInsurance: hasInsurance ?? this.hasInsurance,
      insuranceType: insuranceType ?? this.insuranceType,
      insuranceSchema: insuranceSchema ?? this.insuranceSchema,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      anyInfection: anyInfection ?? this.anyInfection,
      anyAllergy: anyAllergy ?? this.anyAllergy,
      allergyName: allergyName ?? this.allergyName,
      allergyDetail: allergyDetail ?? this.allergyDetail,
      selectedDisease: selectedDisease ?? this.selectedDisease,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  @override
  List<Object?> get props => [
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
