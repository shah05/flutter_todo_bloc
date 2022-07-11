import 'package:flutter_todo_bloc/data/network/rest_api_service.dart';
import 'package:flutter_todo_bloc/data/repository/base_repository.dart';
import 'package:flutter_todo_bloc/data/storage/local_storage_service.dart';

class UserRepository extends BaseRepository {
  final RestApiService _restApiService;
  final LocalStorageService _localStorageService;

  late String _token;
  late bool _isConnected;
  UserRepository(this._restApiService, this._localStorageService);

  Future<void> authenticateUser(
      {required String username, required String password}) async {
    _isConnected = await isConnectedToInternet();
    if (!_isConnected) throw NoInternetConnectionException();

    final result = await _restApiService.loginExistingUser(username, password);
    if (result.authToken == null) {
      throw AuthenticateFailedException("User Login failed. No token found.");
    }
    _localStorageService.saveAuthToken(result.authToken!);
  }

  Future<void> registerUser(
      {required String username,
      required String email,
      required String password,
      required int age}) async {
    _isConnected = await isConnectedToInternet();
    if (!_isConnected) throw NoInternetConnectionException();

    final result =
        await _restApiService.registerNewUser(username, email, password, age);
    if (result.authToken == null) {
      throw RegistrationFailedException("User Registration failed.");
    }
    _localStorageService.saveAuthToken(result.authToken!);
  }

  Future<bool> isUserLoggedIn() async {
    final result = await _localStorageService.getAuthToken();
    if (result == null) {
      return false;
    } else {
      return true;
    }
  }
}

class AuthenticateFailedException implements Exception {
  final String message;
  AuthenticateFailedException(this.message);
}

class RegistrationFailedException implements Exception {
  final String message;
  RegistrationFailedException(this.message);
}
