import 'dart:convert';

import 'package:flutter_todo_bloc/data/repository/user_repository.dart';
import 'package:http/http.dart' as http;

import '../model/todo.dart';
import '../model/user.dart';
import 'exceptions.dart';

class RestApiService {
  static const String baseLink = "https://api-nodejs-todolist.herokuapp.com";
  static const headers = {'Content-Type': 'application/json'};

  /// API call for new user registration
  /// Used in [UserRepository]
  Future<User> registerNewUser(
      String name, String email, String password, int age) async {
    final response = await http.post(
      Uri.parse('$baseLink/user/register'),
      headers: headers,
      body: jsonEncode(
        {"name": name, "email": email, "password": password, "age": age},
      ),
    );

    if (response.statusCode == 201) {
      final raw = jsonDecode(response.body);
      return User.fromJson(raw);
    } else {
      //Todo: To implement logic for catching duplicated user registration error.
      throw UserRegistrationError("API Error user registration.");
    }
  }

  /// API call for authenticating existing user
  /// Used in [UserRepository]
  Future<User> loginExistingUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseLink/user/login'),
      headers: headers,
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final raw = jsonDecode(response.body);
      return User.fromJson(raw);
    } else {
      throw UserLoginError('API Error Logging in user');
    }
  }

  Future<List<Todo>> getAllTodos(String token) async {
    final response = await http.get(
      Uri.parse('$baseLink/task'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final List raw = jsonDecode(response.body)['data'];
      List<Todo> todos = raw.map((data) => Todo.fromJson(data)).toList();
      return todos;
    } else {
      throw GetAllTodosError('API Error getting all todos');
    }
  }

  Future<Todo> addNewTodos(String token, String description) async {
    final response = await http.post(
      Uri.parse('$baseLink/task'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{"description": description}),
    );

    if (response.statusCode == 201) {
      final raw = jsonDecode(response.body)['data'];
      return Todo.fromJson(raw);
    } else {
      throw AddTodoError('API Error add new todo');
    }
  }
}
