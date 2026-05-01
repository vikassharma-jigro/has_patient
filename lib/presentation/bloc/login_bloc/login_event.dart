part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

final class LoginSubmitted extends LoginEvent {
  final String userId;
  final String password;

  const LoginSubmitted({required this.userId, required this.password});

  @override
  List<Object> get props => [userId, password];
}

final class RegisterSubmitted extends LoginEvent {
   final String? firstName;
  final  String? gender;
   final String? lastName;
   final String? emailAddress;
   final String? dob;
  final  String? age;
  final  String? mobile;
   final String? address;
   final String? pincode;
   final String? state;
   final String? city;

  const RegisterSubmitted({required this.firstName,
    this.emailAddress,this.lastName,this.state,this.address,
    this.city,this.pincode,this.age,this.dob,this.gender,this.mobile


  });

  @override
  List<Object> get props => [];
}
final class Register1Submitted extends LoginEvent {
   String? IDProofNumber;
   String? IDProofType;
   String? insuranceNumber;
   String? allergy;
   String? infection;
   String? insuranceSchemeName;
   String? insuranceType;
   final int id;
   List<String>?seriousDiseases;

   Register1Submitted({required this.IDProofNumber,
    this.IDProofType,this.insuranceNumber,this.allergy,this.infection,
    this.insuranceSchemeName,this.insuranceType,required this.id,this.seriousDiseases


  });

  @override
  List<Object> get props => [];
}

final  class ForgotPasswordSubmitted extends LoginEvent {
  final String identifier;

  const ForgotPasswordSubmitted({required this.identifier});
  @override
  List<Object> get props => [identifier];
}

