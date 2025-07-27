import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/logging/app_logger.dart';
import '../../../models/models.dart';

part 'user_navigation_bar_event.dart';
part 'user_navigation_bar_state.dart';

class UserNavigationBarBloc
    extends Bloc<NavigationBarOnMainEvent, UserNavigationBarState> {
  final AppLogger _logger = GetIt.I<AppLogger>();

  UserNavigationBarBloc() : super(UserNavigationBarInitial()) {
    on<UserNavigationBarLoad>(_onLoadNavigationBarOnMain);
    on<NavigationBarOnMainTapOnBell>(_tapOnNotificationBell);
  }

  Future<void> _onLoadNavigationBarOnMain(
    UserNavigationBarLoad event,
    Emitter<UserNavigationBarState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // MOCK
    final user = UserNavigationBarModel(
      userName: 'Гребенников В.А.',
      userRole: 'Руководитель проектного офиса',
      avatarUrl: 'https://placehold.co/600x400@2x.png',
    );

    emit(UserNavigationBarLoaded(user: user));
  }

  void _tapOnNotificationBell(
    NavigationBarOnMainTapOnBell event,
    Emitter<UserNavigationBarState> emit,
  ) {
    _logger.i('TapOnNotificationBell');
  }
}
