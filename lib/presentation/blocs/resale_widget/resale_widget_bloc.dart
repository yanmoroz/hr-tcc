import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';

part 'resale_widget_event.dart';
part 'resale_widget_state.dart';

// ResaleBloc
class ResaleWidgetBloc extends Bloc<ResaleWidgetEvent, ResaleWidgetState> {
  ResaleWidgetBloc() : super(const ResaleWidgetInitial()) {
    on<LoadResaleWidgetItems>(_onLoad);
    on<ToggleLockResaleWidgetStatus>(_onToggleLock);
  }

  Future<void> _onLoad(
    LoadResaleWidgetItems event,
    Emitter<ResaleWidgetState> emit,
  ) async {
    emit(const ResaleWidgetLoading());

    await Future.delayed(const Duration(milliseconds: 500)); // симуляция API

    final items = [
      ResaleItemModel(
        id: '1',
        imageUrl: 'https://placehold.co/600x400@2x.png',
        price: '2 900 000 ₽',
        title: 'Audi A2',
        type: 'Автомобиль',
        status: SaleStatus.onSale,
        authorName: 'Александров Дмитрий',
        createdAt: DateTime.now(),
      ),
      ResaleItemModel(
        id: '2',
        imageUrl: 'https://placehold.co/600x400@2x.png',
        price: '1 900 000 ₽',
        title: 'Audi A6',
        type: 'Автомобиль',
        status: SaleStatus.reserved,
        authorName: 'Игнатьева Оксана',
        createdAt: DateTime.now(),
      ),
    ];

    emit(ResaleWidgetLoaded(items));
  }

  Future<void> _onToggleLock(
    ToggleLockResaleWidgetStatus event,
    Emitter<ResaleWidgetState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ResaleWidgetLoaded) return;

    final index = currentState.items.indexWhere((i) => i.id == event.itemId);
    if (index == -1) return;

    final updatedItems = [...currentState.items];
    final currentItem = updatedItems[index];

    if (currentItem.status == SaleStatus.removedFromSale) return;

    final newStatus =
        currentItem.status == SaleStatus.onSale
            ? SaleStatus.reserved
            : SaleStatus.onSale;

    await Future.delayed(
      const Duration(milliseconds: 300),
    ); // эмуляция обращения к сети

    updatedItems[index] = currentItem.copyWith(status: newStatus);

    emit(
      ResaleWidgetLoaded(
        updatedItems,
        title: 'Товар добавлен в забронированные',
        subTitle: 'Забронированные',
        icon: Assets.icons.resale.statusOk.path,
      ),
    );
  }
}
