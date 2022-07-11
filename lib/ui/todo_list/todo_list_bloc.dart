import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_bloc/data/network/exceptions.dart';
import 'package:flutter_todo_bloc/data/repository/todo_repository.dart';

import '../../data/model/todo.dart';

///Events
abstract class TodoListEvent extends Equatable {}

class FetchAllTodos extends TodoListEvent {
  @override
  List<Object?> get props => [];
}

class AddNewTodo extends TodoListEvent {
  final String description;

  AddNewTodo(this.description);

  @override
  List<Object?> get props => [description];
}

///States
abstract class TodoListState extends Equatable {}

class TodoListLoading extends TodoListState {
  @override
  List<Object?> get props => [];
}

class TodoListSuccessful extends TodoListState {
  final List<Todo> todos;

  TodoListSuccessful(this.todos);

  @override
  List<Object?> get props => [todos];
}

class TodoListFailed extends TodoListState {
  final String errorMsg;

  TodoListFailed(this.errorMsg);

  @override
  List<Object?> get props => [];
}

///Bloc
class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoRepository _todoRepository;

  TodoListBloc(this._todoRepository) : super(TodoListLoading()) {
    on<FetchAllTodos>(_onFetchAllTodos);
    on<AddNewTodo>(_onAddNewTodo);
  }

  void _onFetchAllTodos(
      FetchAllTodos event, Emitter<TodoListState> emit) async {
    try {
      final result = await _todoRepository.getMyTodos();
      emit(
        TodoListSuccessful(result),
      );
    } on GetAllTodosError catch (e) {
      emit(
        TodoListFailed(e.message),
      );
    }
  }

  void _onAddNewTodo(AddNewTodo event, Emitter<TodoListState> emit) async {
    try {
      emit(
        TodoListLoading(),
      );
      await _todoRepository.addNewTodo(event.description);
      final result = await _todoRepository.getMyTodos();
      emit(
        TodoListSuccessful(result),
      );
    } on GetAllTodosError catch (e) {
      emit(
        TodoListFailed(e.message),
      );
    }
  }
}
