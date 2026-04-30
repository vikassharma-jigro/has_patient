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

final  class ForgotPasswordSubmitted extends LoginEvent {
  final String identifier;

  const ForgotPasswordSubmitted({required this.identifier});
  @override
  List<Object> get props => [identifier];
}

