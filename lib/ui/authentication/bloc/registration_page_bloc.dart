import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/network/exceptions.dart';
import '../../../data/network/rest_api_service.dart';
import '../../../data/repository/user_repository.dart';

/// Event classes
abstract class RegistrationEvent extends Equatable {}

class TriggerRegistration extends RegistrationEvent {
  final String username;
  final String password;
  final String email;
  final int age;

  TriggerRegistration(
      {required this.username,
      required this.password,
      required this.email,
      required this.age});

  @override
  List<Object?> get props => [username, password];
}

/// State classes
abstract class RegistrationState extends Equatable {}

class RegistrationInitial extends RegistrationState {
  @override
  List<Object?> get props => [];
}

class RegistrationLoading extends RegistrationState {
  @override
  List<Object?> get props => [];
}

class RegistrationSuccessful extends RegistrationState {
  @override
  List<Object?> get props => [];
}

class RegistrationFailed extends RegistrationState {
  final String errorMsg;
  RegistrationFailed(this.errorMsg);
  @override
  List<Object?> get props => [errorMsg];
}

///Bloc
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final UserRepository _userRepository;
  RegistrationBloc(this._userRepository) : super(RegistrationInitial()) {
    on<TriggerRegistration>(_onTriggerRegistration);
  }

  void _onTriggerRegistration(
      TriggerRegistration event, Emitter<RegistrationState> emit) async {
    try {
      emit(RegistrationLoading());
      await _userRepository.registerUser(
          username: event.username,
          password: event.password,
          email: event.email,
          age: event.age);
      emit(RegistrationSuccessful());
    } on RegistrationFailedException catch (e) {
      emit(RegistrationFailed(e.message));
    } on UserRegistrationError catch (e) {
      emit(RegistrationFailed(e.message));
    }
  }
}
