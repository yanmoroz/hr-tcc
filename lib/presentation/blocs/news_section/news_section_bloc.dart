import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/models/news_card_model.dart';

part 'news_section_event.dart';
part 'news_section_state.dart';

class NewsSectionBloc extends Bloc<NewsSectionEvent, NewsSectionState> {
  NewsSectionBloc() : super(NewsSectionInitial()) {
    on<LoadNewsSection>(_onLoadNews);
  }

  Future<void> _onLoadNews(
    LoadNewsSection event,
    Emitter<NewsSectionState> emit,
  ) async {
    emit(NewsSectionLoading());
    try {
      await Future.delayed(
        const Duration(milliseconds: 200),
      ); // имитация загрузки

      final news = [
        NewsCardModel(
          id: 1,
          time: 'Сегодня в 08:20',
          title:
              'Архитектурный комитет утвердил Стандарт интеграции информационных систем',
          subtitle:
              'Стандарт интеграции информационных систем. Дорогие коллеги!​​​​​​​​9 апреля прошло заседание…',
          category: NewsCategory.s8News,
          imageUrl: 'https://placehold.co/600x400@2x.png',
          notRead: true,
        ),
        NewsCardModel(
          id: 2,
          time: 'Сегодня в 08:21',
          title:
              'Покупайте электронные лотерейные билеты «Столото» на Ozon и «Купер»',
          subtitle:
              'Стандарт интеграции информационных систем. Дорогие коллеги!​​​​​​​​9 апреля прошло заседание…',
          category: NewsCategory.s8News,
          notRead: false,
        ),
      ];

      emit(NewsSectionLoaded(news));
    } on Exception {
      emit(NewsSectionError('Ошибка загрузки новостей'));
    }
  }
}
