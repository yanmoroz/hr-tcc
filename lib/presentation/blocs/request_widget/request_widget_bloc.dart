import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/navigation/app_route.dart';

part 'request_widget_event.dart';
part 'request_widget_state.dart';

class RequestsWidgetBloc
    extends Bloc<RequestsWidgetEvent, RequestsWidgetState> {
  RequestsWidgetBloc() : super(RequestsWidgetState.initial()) {
    on<RequestsWidgetLoad>(_onLoad);
  }

  Future<void> _onLoad(
    RequestsWidgetLoad event,
    Emitter<RequestsWidgetState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final items = [
      RequestWidgetItemModel(
        iconPath: Assets.icons.requests.requestPass.path,
        title: 'Пропуск',
        route: AppRoute.passRequestCreate.path,
      ),
      RequestWidgetItemModel(
        iconPath: Assets.icons.requests.requestAbsence.path,
        title: 'Отсутствие',
        route: AppRoute.absenceRequestCreate.path,
      ),
      RequestWidgetItemModel(
        iconPath: Assets.icons.requests.requestCourier.path,
        title: 'Курьерская доставка',
        route: AppRoute.courierRequestCreate.path,
      ),
    ];

    emit(state.copyWith(isLoading: false, items: items));
  }
}
