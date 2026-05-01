import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hms_patient/app_helpers/network/api_base_helper.dart';
import 'package:hms_patient/app_helpers/network/api_error.dart';
import 'package:logger/logger.dart';

part 'patient_registration_event.dart';
part 'patient_registration_state.dart';

// FIX BUG 14: Logger replaces all print() calls.
final _log = Logger();

class PatientRegistrationBloc
    extends Bloc<PatientRegistrationEvent, PatientRegistrationState> {
  final ApiBaseHelper _api = ApiBaseHelper();

  PatientRegistrationBloc() : super(const PatientRegistrationState()) {
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
    on<JumpToStepEvent>(_onJumpToStep);
    on<UpdateFieldEvent>(_onUpdateField);
    on<SubmitBasicDetailsEvent>(_onSubmitBasicDetails);
    on<SubmitFullRegistrationEvent>(_onSubmitFullRegistration);
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _onNextStep(NextStepEvent _, Emitter<PatientRegistrationState> emit) {
    if (state.currentStep < 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void _onPreviousStep(
    PreviousStepEvent _,
    Emitter<PatientRegistrationState> emit,
  ) {
    if (state.currentStep > 0) {
      emit(
        state.copyWith(
          currentStep: state.currentStep - 1,
          status: PatientRegistrationStatus.initial,
        ),
      );
    }
  }

  void _onJumpToStep(
    JumpToStepEvent event,
    Emitter<PatientRegistrationState> emit,
  ) {
    emit(state.copyWith(currentStep: event.step));
  }

  // ── Field Update ───────────────────────────────────────────────────────────

  void _onUpdateField(
    UpdateFieldEvent event,
    Emitter<PatientRegistrationState> emit,
  ) {
    // FIX BUG 16: When hasInsurance is toggled OFF, clear all insurance data.
    if (event.hasInsurance == false) {
      emit(
        state.copyWith(
          hasInsurance: false,
          insuranceType: null, // sentinel: explicitly clear to null
          insuranceSchema: '',
          insuranceNumber: '',
          status: PatientRegistrationStatus.initial,
        ),
      );
      return;
    }

    // FIX BUG 17: When anyAllergy is toggled OFF, clear all allergy data.
    if (event.anyAllergy == false) {
      emit(
        state.copyWith(
          anyAllergy: false,
          allergyName: '',
          allergyDetail: '',
          status: PatientRegistrationStatus.initial,
        ),
      );
      return;
    }

    // FIX BUG 20 (State comment): idProofType change clears idProofNumber
    // so the validator re-evaluates against the new proof type.
    if (event.idProofType != null && event.idProofType != state.idProofType) {
      emit(
        state.copyWith(
          idProofType: event.idProofType,
          idProofNumber: '',
          status: PatientRegistrationStatus.initial,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
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
        idProofNumber: event.idProofNumber,
        isOPD: event.isOPD,
        hasInsurance: event.hasInsurance,
        insuranceType: event.clearInsuranceType ? null : event.insuranceType,
        insuranceSchema: event.insuranceSchema,
        insuranceNumber: event.insuranceNumber,
        anyInfection: event.anyInfection,
        anyAllergy: event.anyAllergy,
        allergyName: event.allergyName,
        allergyDetail: event.allergyDetail,
        isConfirmed: event.isConfirmed,
        status: PatientRegistrationStatus.initial,
      ),
    );
  }

  // ── Submit Step 1 ──────────────────────────────────────────────────────────

  Future<void> _onSubmitBasicDetails(
    SubmitBasicDetailsEvent _,
    Emitter<PatientRegistrationState> emit,
  ) async {
    _log.i('Submitting basic details: ${state.firstName} ${state.lastName}');
    emit(state.copyWith(status: PatientRegistrationStatus.loading));

    final result = await _api.registerApi(
      firstName: state.firstName,
      lastName: state.lastName,
      gender: state.gender,
      dob: _formatDateForBackend(state.dob),
      age: state.age,
      mobile: state.mobile,
      emailAddress: state.email,
      address: state.address,
      city: state.city,
      state: state.state,
      pincode: state.pincode,
    );

    switch (result) {
      case ApiSuccess(:final data):
        _log.i('Step 1 API success: $data');
        final patientId = data['patientId']?.toString() ?? '';
        emit(
          state.copyWith(
            status: PatientRegistrationStatus.step1Success,
            registeredId: patientId,
            currentStep: 1,
            successMessage: data['message'] as String?,
          ),
        );

      case ApiFailure(:final error):
        _log.e('Step 1 API failure: ${error.message}');
        emit(
          state.copyWith(
            status: PatientRegistrationStatus.failure,
            error: error,
          ),
        );
    }
  }

  // ── Submit Full Registration ───────────────────────────────────────────────

  Future<void> _onSubmitFullRegistration(
    SubmitFullRegistrationEvent _,
    Emitter<PatientRegistrationState> emit,
  ) async {
    // FIX BUG 15: Guard — user MUST confirm before submitting.
    if (!state.isConfirmed) {
      emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          error: const ApiError(
            message: 'Please confirm that all information is correct.',
            type: ApiErrorType.validation,
          ),
        ),
      );
      return;
    }

    // Guard — step 1 must have succeeded.
    if (state.registeredId.isEmpty) {
      emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          error: const ApiError(
            message: 'Registration ID missing. Please restart.',
            type: ApiErrorType.validation,
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(status: PatientRegistrationStatus.loading));
    _log.i('Submitting full registration for ID: ${state.registeredId}');

    final result = await _api.register1Api(
      IDProofNumber: state.idProofNumber,
      IDProofType: state.idProofType,
      insuranceNumber: state.insuranceNumber,
      allergy: state.anyAllergy ? state.allergyName : 'None',
      infection: state.anyInfection ? 'Yes' : 'No',
      insuranceSchemeName: state.insuranceSchema,
      insuranceType: state.insuranceType ?? 'None',
      id: state.registeredId,
      seriousDiseases: const [],
    );

    switch (result) {
      case ApiSuccess(:final data):
        _log.i('Full registration success');
        emit(
          state.copyWith(
            status: PatientRegistrationStatus.success,
            successMessage:
                data['message']?.toString() ??
                'Registration completed successfully.',
          ),
        );

      case ApiFailure(:final error):
        _log.e('Full registration failure: ${error.message}');
        emit(
          state.copyWith(
            status: PatientRegistrationStatus.failure,
            error: error,
          ),
        );
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// "DD/MM/YYYY" → "YYYY-MM-DD" for backend.
  String _formatDateForBackend(String dob) {
    try {
      final parts = dob.split('/');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
      }
    } catch (_) {}
    return dob;
  }
}
