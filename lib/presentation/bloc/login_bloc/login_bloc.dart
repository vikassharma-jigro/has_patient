import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_patient/app_helpers/network/api_base_helper.dart';
import 'package:hms_patient/app_helpers/network/api_error.dart';
import 'package:hms_patient/app_helpers/network/token_storage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiBaseHelper _api = ApiBaseHelper();
  final TokenStorage _tokenStorage = TokenStorage();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<ForgotPasswordSubmitted>(_forgotPasswordSubmitted);
    on<Register1Submitted>(_onRegister1Submitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await _api.login(
      userId: event.userId,
      password: event.password,
    );

    switch (result) {
      case ApiSuccess(:final data):
        final inner = data['data'] as Map<String, dynamic>? ?? data;

        final accessToken = inner['accessToken'] as String? ?? '';
        final refreshToken = inner['refreshToken'] as String? ?? '';
        final user = inner['user'] as Map<String, dynamic>? ?? {};

        await _tokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        await _tokenStorage.setLoggedIn(true);

        emit(
          LoginSuccess(
            accessToken: accessToken,
            refreshToken: refreshToken,
            user: user,
          ),
        );

      case ApiFailure(:final error):
        emit(LoginFailure(error));
    }
  }
Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await _api.registerApi(
      firstName: event.firstName.toString(),
      lastName: event.lastName??"",
      state: event.state??"",
      city: event.city??"",
      pincode: event.pincode??"",
      address: event.address??"",
      dob: event.dob??"",
      age: event.age??"",
      emailAddress: event.emailAddress??"",
      gender: event.gender??"",
      mobile: event.mobile??""

    );

    switch (result) {
      case ApiSuccess(:final data):
        final inner = data['data'] as Map<String, dynamic>? ?? data;
        print("heeeee>>>${inner}");
        // final accessToken = inner['accessToken'] as String? ?? '';
        // final refreshToken = inner['refreshToken'] as String? ?? '';
        // final user = inner['user'] as Map<String, dynamic>? ?? {};
        //
        // await _tokenStorage.saveTokens(
        //   accessToken: accessToken,
        //   refreshToken: refreshToken,
        // );

        //await _tokenStorage.setLoggedIn(true);

        emit(
          RegisterSuccess(
            message: inner["message"]
            // accessToken: accessToken,
            // refreshToken: refreshToken,
            // user: user,
          ),
        );

      case ApiFailure(:final error):
        emit(LoginFailure(error));
    }
  }
Future<void> _onRegister1Submitted(
    Register1Submitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await _api.register1Api(
      IDProofNumber: event.IDProofNumber??"",
      allergy: event.allergy??"",
      IDProofType: event.IDProofType??"",
      infection: event.infection??"",
      insuranceNumber: event.insuranceNumber??"",
      insuranceSchemeName: event.insuranceSchemeName??"",
      insuranceType: event.insuranceType??"",
      seriousDiseases: event.seriousDiseases??[],
      id: event.id,

    );

    switch (result) {
      case ApiSuccess(:final data):
        final inner = data['data'] as Map<String, dynamic>? ?? data;

        // final accessToken = inner['accessToken'] as String? ?? '';
        // final refreshToken = inner['refreshToken'] as String? ?? '';
        // final user = inner['user'] as Map<String, dynamic>? ?? {};
        //
        // await _tokenStorage.saveTokens(
        //   accessToken: accessToken,
        //   refreshToken: refreshToken,
        // );

        //await _tokenStorage.setLoggedIn(true);

        emit(
          RegisterSuccess(
            message: inner["message"]
            // accessToken: accessToken,
            // refreshToken: refreshToken,
            // user: user,
          ),
        );

      case ApiFailure(:final error):
        emit(LoginFailure(error));
    }
  }

  Future<void> _forgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    final result = await _api.forgotPassword(identifier: event.identifier);
    switch (result) {
      case ApiSuccess(:final data):
        final inner = data['data'] as Map<String, dynamic>? ?? data;
        final message = inner['message'] as String? ?? '';
        emit(ForgotPasswordSuccess(message));
      case ApiFailure(:final error):
        emit(ForgotPasswordFailure(error));
    }
  }
}
