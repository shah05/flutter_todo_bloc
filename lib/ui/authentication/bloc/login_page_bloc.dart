import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/network/exceptions.dart';
import '../../../data/network/rest_api_service.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/storage/local_storage_service.dart';

/// Event classes
abstract class LoginEvent extends Equatable {}

class TriggerLogin extends LoginEvent {
  final String username;
  final String password;

  TriggerLogin({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class CheckUserStatus extends LoginEvent {
  @override
  List<Object?> get props => [];
}

/// State classes
abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccessful extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginFailed extends LoginState {
  final String errorMsg;
  LoginFailed(this.errorMsg);
  @override
  List<Object?> get props => [errorMsg];
}

class LoginNotRequired extends LoginState {
  @override
  List<Object?> get props => [];
}

///Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;
  LoginBloc(this._userRepository) : super(LoginLoading()) {
    on<TriggerLogin>(_onTriggerLogin);
    on<CheckUserStatus>(_onCheckUserStatus);
  }

  void _onTriggerLogin(TriggerLogin event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoading());
      await _userRepository.authenticateUser(
          username: event.username, password: event.password);
      emit(LoginSuccessful());
    } on AuthenticateFailedException catch (e) {
      emit(LoginFailed(e.message));
    } on UserLoginError catch (e) {
      emit(LoginFailed(e.message));
    }
  }

  void _onCheckUserStatus(
      CheckUserStatus event, Emitter<LoginState> emit) async {
    try {
      await _userRepository.isUserLoggedIn();
      emit(LoginNotRequired());
    } on NoAuthTokenFoundException catch (_) {
      emit(LoginInitial());
    }
  }
}
