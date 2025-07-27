import '../../domain/entities/current_user.dart';
import '../../domain/repositories/current_user_repository.dart';
import '../datasources/current_user_local_data_source.dart';

class CurrentUserRepositoryImpl implements CurrentUserRepository {
  final CurrentUserLocalDataSource currentUserLocalDataSource;

  CurrentUserRepositoryImpl({required this.currentUserLocalDataSource});

  @override
  Future<CurrentUser?> getCurrentUser() async {
    return await currentUserLocalDataSource.getCurrentUser();
  }

  @override
  Future<bool> deleteCurrentUser() async {
    return await currentUserLocalDataSource.deleteCurrentUser();
  }

  @override
  Future<bool> updateCurrentUser(CurrentUser currentUser) async {
    return await currentUserLocalDataSource.updateCurrentUser(currentUser);
  }
}
