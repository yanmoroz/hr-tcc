part of 'referral_program_request_view_bloc.dart';

class ReferralProgramRequestViewState extends Equatable {
  final ReferralProgramRequest? request;
  final bool isLoading;
  final String? error;

  const ReferralProgramRequestViewState({
    this.request,
    this.isLoading = false,
    this.error,
  });

  ReferralProgramRequestViewState copyWith({
    ReferralProgramRequest? request,
    bool? isLoading,
    String? error,
  }) {
    return ReferralProgramRequestViewState(
      request: request ?? this.request,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [request, isLoading, error];
}
