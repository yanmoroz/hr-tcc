import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/config/localise/localise.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';

part 'more_page_event.dart';
part 'more_page_state.dart';

class MorePageBloc extends Bloc<MorePageEvent, MorePageState> {
  MorePageBloc() : super(MorePageLoading()) {
    on<LoadMenu>(_onLoadMenu);
    on<LoadMenuCounts>(_onLoadMenuCounts);

    add(LoadMenu());
  }

  Future<void> _onLoadMenu(LoadMenu event, Emitter<MorePageState> emit) async {
    // Карточки без счетчиков
    emit(
      MorePageLoaded([
        const MoreCardModel(id: MoreCardId.violations, title: 'Нарушения'),
        const MoreCardModel(
          id: MoreCardId.quickLinks,
          title: 'Быстрые ссылки',
          subTitle: 'Potok, Jira, Confluence, Ispring, Телеграм-канал S8',
        ),
        const MoreCardModel(id: MoreCardId.resale, title: 'Ресейл'),
        const MoreCardModel(id: MoreCardId.polls, title: 'Опросы'),
        const MoreCardModel(id: MoreCardId.news, title: 'Новости'),
        const MoreCardModel(
          id: MoreCardId.benefits,
          title: 'Льготы и возможности',
        ),
        const MoreCardModel(
          id: MoreCardId.addressBook,
          title: 'Адресная книга',
        ),
      ]),
    );

    // Загружаем данные о счетчиках
    add(LoadMenuCounts());
  }

  Future<void> _onLoadMenuCounts(
    LoadMenuCounts event,
    Emitter<MorePageState> emit,
  ) async {
    if (state is! MorePageLoaded) return;

    final currentCards = (state as MorePageLoaded).cards;

    // Эмуляция запроса
    await Future.delayed(const Duration(microseconds: 500));

    final updatedCards =
        currentCards.map((card) {
          switch (card.id) {
            case MoreCardId.violations:
              return card.copyWith(subTitle: getViolationsText(1));
            case MoreCardId.resale:
              return card.copyWith(subTitle: getViolationsText(1105));
            case MoreCardId.polls:
              return card.copyWith(
                badgeTitle: getPollsText(2),
                backgroundBageColor: AppColors.orange500,
              );
            case MoreCardId.news:
              return card.copyWith(
                badgeTitle: getNewsText(1),
                backgroundBageColor: AppColors.green500,
              );
            case MoreCardId.benefits:
              return card.copyWith(subTitle: '8');
            case MoreCardId.addressBook:
              return card.copyWith(subTitle: getStaffText(2208));
            default:
              return card;
          }
        }).toList();

    emit(MorePageLoaded(updatedCards));
  }
}
