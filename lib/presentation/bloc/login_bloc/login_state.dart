part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
}

final class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginSuccess extends LoginState {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> user;

  const LoginSuccess({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object> get props => [accessToken, refreshToken, user];
}

final class LoginFailure extends LoginState {
  final ApiError error;
  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class ForgotPasswordLoading extends LoginState {
  @override
  List<Object> get props => [];
}

final class ForgotPasswordSuccess extends LoginState {
  final String message;

  const ForgotPasswordSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class ForgotPasswordFailure extends LoginState {
  final ApiError error;

  const ForgotPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}
