part of 'referral_program_request_view_bloc.dart';

abstract class ReferralProgramRequestViewEvent extends Equatable {
  const ReferralProgramRequestViewEvent();
  @override
  List<Object?> get props => [];
}

class LoadReferralProgramRequest extends ReferralProgramRequestViewEvent {
  final String id;
  const LoadReferralProgramRequest(this.id);
  @override
  List<Object?> get props => [id];
}
