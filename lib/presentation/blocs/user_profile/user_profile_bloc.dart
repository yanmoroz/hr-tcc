import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/logout_usecase.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final LogoutUseCase _logoutUseCase;

  UserProfileBloc(this._logoutUseCase) : super(UserProfileInitial()) {
    on<UserProfileLogout>(_onLogout);
    on<LoadUserProfile>(_loadUserProfile);
  }

  Future<void> _loadUserProfile(
    LoadUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    ); // Эмуляция загрузки

    try {
      emit(
        UserProfileLoaded(
          name: 'Гребенников Владимир Александрович',
          photoUrl: 'https://placehold.co/600x400@2x.png',
          phoneMobile: '+7 985 999-00-00 (моб.)',
          phoneWork: '+7 985 999-00-00, 1234 (раб.)',
          email: 'vladimir.grebennikov@tccenter.ru',
          department: 'Управление развития',
          position: 'Руководитель\nпроектного офиса',
          quarterLabel: '2 квартал 2025 года',
          kpiProgress: 0.55,
          incomeTotal: '1 234 666 ₽',
          incomeSalary: '234 666 ₽',
          incomeBonus: '117 333 ₽',
          vacationDays: '13',
        ),
      );
    } on Exception {
      emit(UserProfileError('Ошибка загрузки профиля'));
    }
  }

  Future<void> _onLogout(
    UserProfileLogout event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      await _logoutUseCase();
      emit(UserProfileLoggedOut());
    } on Exception {
      emit(UserProfileError('Ошибка при выходе из системы'));
    }
  }
}
