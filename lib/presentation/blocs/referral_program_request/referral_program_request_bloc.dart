import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/requests/referral_program_request.dart';
import 'package:hr_tcc/domain/usecases/create_referral_program_request_usecase.dart';
import 'package:hr_tcc/domain/repositories/referral_program_request_repository.dart';
import 'dart:core';

part 'referral_program_request_event.dart';
part 'referral_program_request_state.dart';

class ReferralProgramRequestBloc
    extends Bloc<ReferralProgramRequestEvent, ReferralProgramRequestState> {
  final CreateReferralProgramRequestUseCase createUseCase;
  final ReferralProgramRequestRepository repository;

  ReferralProgramRequestBloc(this.createUseCase, this.repository)
    : super(
        const ReferralProgramRequestState(
          fields: {
            ReferralProgramRequestField.vacancy: null,
            ReferralProgramRequestField.candidateName: '',
            ReferralProgramRequestField.resumeLink: '',
            ReferralProgramRequestField.file: null,
            ReferralProgramRequestField.comment: '',
          },
          errors: {},
        ),
      ) {
    on<LoadVacancies>((event, emit) async {
      emit(state.copyWith(isVacanciesLoading: true, vacanciesError: null));
      try {
        final vacancies = await repository.getVacancies();
        emit(
          state.copyWith(
            vacancies: vacancies,
            isVacanciesLoading: false,
            vacanciesError: null,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            isVacanciesLoading: false,
            vacanciesError: e.toString(),
          ),
        );
      }
    });

    on<ReferralProgramFieldChanged>((event, emit) {
      final newFields = Map<ReferralProgramRequestField, dynamic>.from(
        state.fields,
      );
      newFields[event.field] = event.value;
      emit(state.copyWith(fields: newFields));
    });

    on<ReferralProgramRequestSubmit>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, error: null));
      final errors = <String, String?>{};
      final candidateName =
          state.fields[ReferralProgramRequestField.candidateName] as String? ??
          '';
      final resumeLink =
          state.fields[ReferralProgramRequestField.resumeLink] as String? ?? '';
      final file = state.fields[ReferralProgramRequestField.file];
      final vacancy = state.fields[ReferralProgramRequestField.vacancy];
      final comment =
          state.fields[ReferralProgramRequestField.comment] as String? ?? '';

      if (vacancy == null) {
        errors[ReferralProgramRequestField.vacancy.name] = 'Обязательное поле';
      }
      if (candidateName.trim().isEmpty) {
        errors[ReferralProgramRequestField.candidateName.name] =
            'Обязательное поле';
      }
      // Файл или ссылка — хотя бы одно обязательно
      bool isLinkValid(String link) {
        const urlPattern = r'^(https?:\/\/)[\w\-]+(\.[\w\-]+)+[/#?]?.*$';
        final regExp = RegExp(urlPattern);
        return regExp.hasMatch(link.trim());
      }

      if (file == null) {
        if (resumeLink.trim().isEmpty) {
          errors[ReferralProgramRequestField.resumeLink.name] =
              'Укажите ссылку или прикрепите файл';
          errors[ReferralProgramRequestField.file.name] =
              'Укажите ссылку или прикрепите файл';
        } else if (!isLinkValid(resumeLink)) {
          errors[ReferralProgramRequestField.resumeLink.name] =
              'Введите корректную ссылку (http/https)';
        }
      } else {
        // файл есть — ссылка может быть пустой или валидной
        if (resumeLink.trim().isNotEmpty && !isLinkValid(resumeLink)) {
          errors[ReferralProgramRequestField.resumeLink.name] =
              'Введите корректную ссылку (http/https)';
        }
      }
      // Если комментарий включён — он обязателен
      // (если нужно, добавить проверку на обязательность комментария)
      if (errors.isNotEmpty) {
        emit(state.copyWith(isSubmitting: false, errors: errors));
        return;
      }
      try {
        final request = ReferralProgramRequest(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          vacancy: vacancy,
          candidateName: candidateName,
          resumeLink: resumeLink,
          file: file,
          comment: comment.isNotEmpty ? comment : null,
          createdAt: DateTime.now(),
        );
        await createUseCase(request);
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } on Exception catch (e) {
        emit(state.copyWith(isSubmitting: false, error: e.toString()));
      }
    });

    on<ValidateField>((event, emit) {
      final errors = Map<String, String?>.from(state.errors);
      final field = event.field;
      final value = event.value;

      switch (field) {
        case ReferralProgramRequestField.vacancy:
          if (value == null) {
            errors[field.name] = 'Обязательное поле';
          } else {
            errors.remove(field.name);
          }
          break;
        case ReferralProgramRequestField.candidateName:
          if ((value as String?)?.trim().isEmpty ?? true) {
            errors[field.name] = 'Обязательное поле';
          } else {
            errors.remove(field.name);
          }
          break;
        case ReferralProgramRequestField.resumeLink:
          final str = value as String?;
          final file = state.fields[ReferralProgramRequestField.file];
          if ((str == null || str.isEmpty) && file == null) {
            errors[field.name] = 'Укажите ссылку или прикрепите файл';
          } else if (str != null && str.isNotEmpty) {
            const urlPattern = r'^(https?:\/\/)[\w\-]+(\.[\w\-]+)+[/#?]?.*$';
            final regExp = RegExp(urlPattern);
            if (!regExp.hasMatch(str.trim())) {
              errors[field.name] = 'Введите корректную ссылку (http/https)';
            } else {
              errors.remove(field.name);
            }
          } else {
            errors.remove(field.name);
          }
          break;
        case ReferralProgramRequestField.file:
          // Не валидируем отдельно, только в submit
          break;
        case ReferralProgramRequestField.comment:
          // Если комментарий обязателен — добавить проверку
          errors.remove(field.name);
          break;
      }
      emit(state.copyWith(errors: errors));
    });

    // Загружаем вакансии при инициализации
    add(const LoadVacancies());
  }
}
