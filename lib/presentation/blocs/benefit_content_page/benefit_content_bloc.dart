import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/pages/benefit_content_page/components/components.dart';

import '../../cubits/snackbar/snackbar_cubit.dart';
import '../../pages/helpers/helpers.dart';

part 'benefit_content_event.dart';
part 'benefit_content_state.dart';

class BenefitContentBloc
    extends Bloc<BenefitContentEvent, BenefitContentState> {
  BenefitContentBloc({
    required this.linkContentUse,
    required this.snackBarCubit,
  }) : super(BenefitContentInitial()) {
    on<LoadBenefitContent>(_onLoadContent);
    on<LikePressed>(_onLikePressed);
  }

  final FeatchLinkContentUseCase linkContentUse;
  final SnackBarCubit snackBarCubit;

  Future<void> _onLoadContent(
    LoadBenefitContent event,
    Emitter<BenefitContentState> emit,
  ) async {
    emit(BenefitContentLoading());
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final mockWidgets = <Widget>[
        const SizedBox(height: 8),
        const BenefitsBadgeWithTime(
          badgeText: 'Бессрочно',
          timeText: 'Вчера в 21:08',
        ),
        const SizedBox(height: 16),
        const BenefitsPublicationAuthor(
          imageUrl: 'https://placehold.co/600x400@2x.png',
          title: 'Публикация',
          name: 'Гребенников Владимир',
        ),
        const SizedBox(height: 12),
        BenefitsTextBlock(
          title: 'Оформление полиса ДМС для членов семьи',
          body:
              'В рамках страхования вам доступно оформление полиса ДМС для членов семьи '
              '(супруги, дети, родители, усыновлённые, усыновители) по корпоративным тарифам при условии '
              'возмещения полной стоимости такого полиса из личных средств:\n\n'
              '1) Сотрудники, чей полис действует с 1 января 2025 г., могут прикрепить родственника '
              'к программе ДМС в течение двух месяцев после начала действия договора, то есть не позднее 28 февраля.\n\n'
              '2) Для новых сотрудников, трудоустроенных в течение года, срок подачи заявления на прикрепление '
              'родственника к корпоративному договору ДМС — не позднее 14 календарных дней от даты начала действия полиса ДМС.\n\n'
              'Взрослый родственник принимается на страхование только по варианту корпоративной программы ДМС, по которой '
              'застрахован сотрудник. Для детей действуют детские программы.',
          titleStyle: AppTypography.title2Bold.copyWith(color: AppColors.white),
          bodyStyle: AppTypography.text1Regular.copyWith(
            color: AppColors.white,
          ),
          spacing: 12,
        ),
        const SizedBox(height: 16),
        BenefitsFileDownloadButton(
          iconAsset: Assets.icons.benefitContent.dowenloadDocButton.path,
          fileName: 'Программы для детей 2025.docx',
          onTap:
              () => LinkActionHelper.onLinkTap(
                snackBarCubit,
                'https://officeprotocoldoc.z19.web.core.windows.net/files/MS-DOCX/%5bMS-DOCX%5d-250218.docx',
                linkContentUse,
              ),
        ),
        const SizedBox(height: 16),
        BenefitsTextBlock(
          title: 'Для оформления страхового полиса необходимо:',
          body:
              'Для оформления страхового полиса необходимо заполнить медицинскую анкету:',
          titleStyle: AppTypography.title3Semibold.copyWith(
            color: AppColors.white,
          ),
          bodyStyle: AppTypography.text1Regular.copyWith(
            color: AppColors.white,
          ),
          spacing: 16,
        ),
        const SizedBox(height: 16),
      ];

      // Список ссылок с текстом
      final linkTexts = ['для взрослых', 'для детей'];

      for (final text in linkTexts) {
        mockWidgets.add(
          BenefitsPrefixLinkText(
            text: text,
            onTap:
                () => LinkActionHelper.onLinkTap(
                  snackBarCubit,
                  'http://google.com/search?client=safari&rls=en&q=$text',
                  linkContentUse,
                ),
          ),
        );
        mockWidgets.add(const SizedBox(height: 16));
      }

      emit(
        BenefitContentLoaded(
          widgets: mockWidgets,
          commentCount: 1500,
          isLiked: false,
          likeCount: 1500,
          phone: '911',
          email: 'test@mail.ru',
        ),
      );
    } on Exception catch (e) {
      emit(BenefitContentError('Не удалось загрузить данные: $e'));
    }
  }

  Future<void> _onLikePressed(
    LikePressed event,
    Emitter<BenefitContentState> emit,
  ) async {
    snackBarCubit.showSnackBar('Отправляем лайк...');

    await Future.delayed(const Duration(seconds: 1)); // симуляция сети

    final currentState = state;
    if (currentState is BenefitContentLoaded) {
      final newLiked = !currentState.isLiked;
      final newLikeCount =
          newLiked ? currentState.likeCount + 1 : currentState.likeCount - 1;

      emit(
        currentState.copyWith(
          widgets: currentState.widgets,
          isLiked: newLiked,
          likeCount: newLikeCount,
        ),
      );

      snackBarCubit.showSnackBar(newLiked ? 'Лайк поставлен!' : 'Лайк убран!');
    }
  }
}
