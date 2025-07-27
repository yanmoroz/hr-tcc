part of 'absence_request_bloc.dart';

class AbsenceRequestState {
  final Map<AbsenceRequestField, dynamic> fields;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;
  final Map<AbsenceRequestField, String?> errors;

  AbsenceRequestState({
    required this.fields,
    required this.isSubmitting,
    required this.isSuccess,
    this.error,
    this.errors = const {},
  });

  factory AbsenceRequestState.initial() => AbsenceRequestState(
    fields: {AbsenceRequestField.type: AbsenceType.earlyLeave},
    isSubmitting: false,
    isSuccess: false,
    error: null,
    errors: const {},
  );

  AbsenceRequestState copyWith({
    Map<AbsenceRequestField, dynamic>? fields,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
    Map<AbsenceRequestField, String?>? errors,
  }) {
    return AbsenceRequestState(
      fields: fields ?? this.fields,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      errors: errors ?? this.errors,
    );
  }

  bool get isFormValid {
    final type =
        fields[AbsenceRequestField.type] as AbsenceType? ??
        AbsenceType.earlyLeave;
    if (type == AbsenceType.earlyLeave) {
      if (fields[AbsenceRequestField.date] == null) return false;
      if (fields[AbsenceRequestField.time] == null) return false;
      if ((fields[AbsenceRequestField.reason] as String?)?.trim().isEmpty ??
          true) {
        return false;
      }
    } else if (type == AbsenceType.lateArrival) {
      if (fields[AbsenceRequestField.date] == null) return false;
      if (fields[AbsenceRequestField.time] == null) return false;
      if ((fields[AbsenceRequestField.reason] as String?)?.trim().isEmpty ??
          true) {
        return false;
      }
    } else if (type == AbsenceType.workSchedule) {
      if (fields[AbsenceRequestField.period] == null) return false;
      if (fields[AbsenceRequestField.timeRangeStart] == null) return false;
      if (fields[AbsenceRequestField.timeRangeEnd] == null) return false;
      if ((fields[AbsenceRequestField.reason] as String?)?.trim().isEmpty ??
          true) {
        return false;
      }
      final start = fields[AbsenceRequestField.timeRangeStart] as TimeOfDay?;
      final end = fields[AbsenceRequestField.timeRangeEnd] as TimeOfDay?;
      if (start != null && end != null) {
        final startMinutes = start.hour * 60 + start.minute;
        final endMinutes = end.hour * 60 + end.minute;
        if (endMinutes <= startMinutes) return false;
      }
    } else if (type == AbsenceType.other) {
      if (fields[AbsenceRequestField.date] == null) return false;
      if (fields[AbsenceRequestField.timeRangeStart] == null) return false;
      if (fields[AbsenceRequestField.timeRangeEnd] == null) return false;
      if ((fields[AbsenceRequestField.reason] as String?)?.trim().isEmpty ??
          true) {
        return false;
      }
      final start = fields[AbsenceRequestField.timeRangeStart] as TimeOfDay?;
      final end = fields[AbsenceRequestField.timeRangeEnd] as TimeOfDay?;
      if (start != null && end != null) {
        final startMinutes = start.hour * 60 + start.minute;
        final endMinutes = end.hour * 60 + end.minute;
        if (endMinutes <= startMinutes) return false;
      }
    }
    return true;
  }
}
