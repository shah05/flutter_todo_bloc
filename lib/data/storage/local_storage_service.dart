import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const sharedPrefTokenKey = 'token';
  static const sharedFirstTimeKey = 'isFirstTime';
  static const sharedEmailKey = 'email';
  static const sharedPasswordKey = 'password';

  //Todo: revisit this implementation to return bool value based on save result (true/false).
  Future<bool> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(sharedPrefTokenKey, token);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString(sharedPrefTokenKey);
    return authToken;
  }

  Future<bool> deleteAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(sharedPrefTokenKey);
  }
}

class NoAuthTokenFoundException implements Exception {}
