part of 'referral_program_request_bloc.dart';

class ReferralProgramRequestState extends Equatable {
  final Map<ReferralProgramRequestField, dynamic> fields;
  final Map<String, String?> errors;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;
  final List<ReferralVacancy> vacancies;
  final bool isVacanciesLoading;
  final String? vacanciesError;

  const ReferralProgramRequestState({
    required this.fields,
    required this.errors,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
    this.vacancies = const [],
    this.isVacanciesLoading = false,
    this.vacanciesError,
  });

  ReferralProgramRequestState copyWith({
    Map<ReferralProgramRequestField, dynamic>? fields,
    Map<String, String?>? errors,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
    List<ReferralVacancy>? vacancies,
    bool? isVacanciesLoading,
    String? vacanciesError,
  }) {
    return ReferralProgramRequestState(
      fields: fields ?? this.fields,
      errors: errors ?? this.errors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      vacancies: vacancies ?? this.vacancies,
      isVacanciesLoading: isVacanciesLoading ?? this.isVacanciesLoading,
      vacanciesError: vacanciesError ?? this.vacanciesError,
    );
  }

  @override
  List<Object?> get props => [
    fields,
    errors,
    isSubmitting,
    isSuccess,
    error,
    vacancies,
    isVacanciesLoading,
    vacanciesError,
  ];

  bool get isFormValid {
    final candidateName =
        fields[ReferralProgramRequestField.candidateName] as String? ?? '';
    final resumeLink =
        fields[ReferralProgramRequestField.resumeLink] as String? ?? '';
    final file = fields[ReferralProgramRequestField.file];
    final vacancy = fields[ReferralProgramRequestField.vacancy];
    final hasErrors = errors.values.any((e) => e != null && e.isNotEmpty);
    bool isLinkValid(String link) {
      const urlPattern = r'^(https?:\/\/)[\w\-]+(\.[\w\-]+)+[/#?]?.*$';
      final regExp = RegExp(urlPattern);
      return regExp.hasMatch(link.trim());
    }

    final hasFileOrValidLink =
        file != null ||
        (resumeLink.trim().isNotEmpty && isLinkValid(resumeLink));
    return vacancy != null &&
        candidateName.trim().isNotEmpty &&
        hasFileOrValidLink &&
        !hasErrors;
  }
}
