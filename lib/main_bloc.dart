import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_bloc/data/storage/local_storage_service.dart';
import 'package:flutter_todo_bloc/ui/todo_list/todo_list_bloc.dart';

import 'data/repository/user_repository.dart';

/// Splash Event
abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class CheckUserStatus extends MainEvent {}

/// Splash State
abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainLoading extends MainState {}

class MainSuccess extends MainState {
  final bool isUserLoggedIn;

  const MainSuccess({required this.isUserLoggedIn});
  @override
  List<Object> get props => [isUserLoggedIn];
}

///Bloc
class MainBloc extends Bloc<MainEvent, MainState> {
  final UserRepository _userRepository;

  MainBloc(this._userRepository) : super(MainLoading()) {
    on<CheckUserStatus>(_onCheckUserStatus);
  }

  void _onCheckUserStatus(
      CheckUserStatus event, Emitter<MainState> emit) async {
    try {
      final result = await _userRepository.isUserLoggedIn();
      emit(MainSuccess(isUserLoggedIn: result));
    } on NoAuthTokenFoundException catch (_) {
      emit(const MainSuccess(isUserLoggedIn: false));
    }
  }
}
