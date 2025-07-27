import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/models/models.dart';

import '../../cubits/snackbar/snackbar_cubit.dart';
import '../../pages/helpers/helpers.dart';

part 'resale_detail_page_event.dart';
part 'resale_detail_page_state.dart';

class ResaleDetailPageBloc
    extends Bloc<ResaleDetailPageEvent, ResaleDetailPageState> {
  final SnackBarCubit snackBarCubit;
  final FeatchLinkContentUseCase linkContentUse;

  ResaleDetailPageBloc({
    required this.snackBarCubit,
    required this.linkContentUse,
  }) : super(ResaleDetailPageState.initial()) {
    on<LoadResaleDetailPage>(_onLoadResaleDetail);
    on<ToggleLockResaleDetailPage>(_onToggleLockStatus);
    on<OnTapResaleDownloadButton>(_onTapResaleDownloadButton);
  }

  void _onLoadResaleDetail(
    LoadResaleDetailPage event,
    Emitter<ResaleDetailPageState> emit,
  ) {
    emit(
      state.copyWith(
        imagePaths: List.generate(
          5,
          (_) => 'https://placehold.co/600x400@2x.png',
        ),
        bookingsHistory: [
          ResailDetailBookingCellModel(
            badgeModel: OnSaleBadgeModel.fromStatus(SaleStatus.reserved),
            dateTime: DateTime(2025, 11, 28, 9, 0),
            namePerson: 'Иванов Иван',
          ),
          ResailDetailBookingCellModel(
            badgeModel: OnSaleBadgeModel.fromStatus(SaleStatus.onSale),
            dateTime: DateTime(2025, 11, 29, 10, 30),
            namePerson: 'Петров Петр',
          ),
        ],
        price: '1 900 000 ₽',
        title: 'Audi A6',
        fileName: 'Автотека Ауди 380.pdf',
        fileURL:
            'https://officeprotocoldoc.z19.web.core.windows.net/files/MS-DOCX/%5bMS-DOCX%5d-250218.docx',
        messagesCount: 208,
        lastStatusChangeText: 'Вчера в 21:08',
        details: [
          ('Тип', 'Автомобиль'),
          ('Ответственный', 'Александров Дмитрий'),
          ('Расположение', 'Авилон-Плаза, паркинг'),
          (
            'Описание',
            '''
2018 г.в.
Марка: AUDI
Модель: A6
VIN: WAUZZZ4G2JN098362
Объем двигателя: 2,0л
Тип двигателя: бензиновый
Мощность: 249 л.с.
2-1 комплект колесной резины: есть
Отметки о состоянии ТС:
Лакокрасочное покрытие: на фото
Остекление ТС: без замечаний
Оптические приборы: без замечаний
Экстерьер: без замечаний
''',
          ),
        ],
      ),
    );
  }

  void _onToggleLockStatus(
    ToggleLockResaleDetailPage event,
    Emitter<ResaleDetailPageState> emit,
  ) {
    emit(state.copyWith(isLocked: !state.isLocked));
  }

  void _onTapResaleDownloadButton(
    OnTapResaleDownloadButton event,
    Emitter<ResaleDetailPageState> emit,
  ) {
    LinkActionHelper.onLinkTap(snackBarCubit, event.fileURL, linkContentUse);
  }
}
