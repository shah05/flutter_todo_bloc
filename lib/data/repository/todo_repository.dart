import 'package:flutter_todo_bloc/data/network/rest_api_service.dart';
import 'package:flutter_todo_bloc/data/repository/base_repository.dart';

import '../model/todo.dart';
import '../storage/local_storage_service.dart';

class TodoRepository extends BaseRepository {
  final RestApiService _restApiService;
  final LocalStorageService _localStorageService;

  TodoRepository(this._restApiService, this._localStorageService);

  late String? _token;
  late bool _isConnected;

  List<Todo> _todoCache = [];

  Future<List<Todo>> getMyTodos() async {
    if (_todoCache.isNotEmpty) return _todoCache;
    _isConnected = await isConnectedToInternet();
    if (!_isConnected) throw NoInternetConnectionException();

    _token = await _localStorageService.getAuthToken();
    if (_token == null) throw NoAuthTokenFoundException();
    final result = await _restApiService.getAllTodos(_token!);
    _todoCache = result;
    return result;
  }

  Future<Todo> addNewTodo(String description) async {
    _isConnected = await isConnectedToInternet();
    if (!_isConnected) throw NoInternetConnectionException();
    _token = await _localStorageService.getAuthToken();
    if (_token == null) throw NoAuthTokenFoundException();
    final result = await _restApiService.addNewTodos(_token!, description);
    _todoCache.add(result);
    return result;
  }
}
