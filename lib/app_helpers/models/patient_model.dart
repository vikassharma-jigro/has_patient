class PatientProfile {
  String fullName;
  String dob;
  String age;
  String gender;
  String bloodGroup;
  String phone;
  String email;
  String address;
  String uhid;
  String doctor;
  String department;
  String registeredOn;
  String status;

  PatientProfile({
    required this.fullName,
    required this.dob,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.phone,
    required this.email,
    required this.address,
    required this.uhid,
    required this.doctor,
    required this.department,
    required this.registeredOn,
    required this.status,
  });

  PatientProfile copyWith({
    String? fullName,
    String? dob,
    String? age,
    String? gender,
    String? bloodGroup,
    String? phone,
    String? email,
    String? address,
    String? uhid,
    String? doctor,
    String? department,
    String? registeredOn,
    String? status,
  }) {
    return PatientProfile(
      fullName: fullName ?? this.fullName,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      uhid: uhid ?? this.uhid,
      doctor: doctor ?? this.doctor,
      department: department ?? this.department,
      registeredOn: registeredOn ?? this.registeredOn,
      status: status ?? this.status,
    );
  }
}
