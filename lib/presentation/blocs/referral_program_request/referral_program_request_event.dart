part of 'referral_program_request_bloc.dart';

abstract class ReferralProgramRequestEvent extends Equatable {
  const ReferralProgramRequestEvent();
  @override
  List<Object?> get props => [];
}

class ReferralProgramFieldChanged extends ReferralProgramRequestEvent {
  final ReferralProgramRequestField field;
  final dynamic value;

  const ReferralProgramFieldChanged(this.field, this.value);

  @override
  List<Object?> get props => [field, value];
}

class ReferralProgramRequestSubmit extends ReferralProgramRequestEvent {}

class LoadVacancies extends ReferralProgramRequestEvent {
  const LoadVacancies();
  @override
  List<Object?> get props => [];
}

class ValidateField extends ReferralProgramRequestEvent {
  final ReferralProgramRequestField field;
  final dynamic value;
  const ValidateField(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}
