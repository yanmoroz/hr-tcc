import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/current_user.dart';

abstract class CurrentUserLocalDataSource {
  Future<CurrentUser?> getCurrentUser();
  Future<bool> deleteCurrentUser();
  Future<bool> updateCurrentUser(CurrentUser currentUser);
}

class CurrentUserLocalDataSourceImpl implements CurrentUserLocalDataSource {
  final SharedPreferences sharedPreferences;

  CurrentUserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<CurrentUser?> getCurrentUser() async {
    final jsonString = sharedPreferences.getString(AppConstants.currentUserKey);
    if (jsonString == null) {
      return null;
    }
    return CurrentUser.fromJson(json.decode(jsonString));
  }

  @override
  Future<bool> deleteCurrentUser() async {
    return sharedPreferences.remove(AppConstants.currentUserKey);
  }

  @override
  Future<bool> updateCurrentUser(CurrentUser currentUser) async {
    return sharedPreferences.setString(
      AppConstants.currentUserKey,
      json.encode(currentUser.toJson()),
    );
  }
}
