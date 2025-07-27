import '../entities/current_user.dart';

abstract class CurrentUserRepository {
  Future<CurrentUser?> getCurrentUser();
  Future<bool> deleteCurrentUser();
  Future<bool> updateCurrentUser(CurrentUser currentUser);
}
