import 'package:flutter_todo_bloc/data/network/rest_api_service.dart';
import 'package:flutter_todo_bloc/data/repository/user_repository.dart';
import 'package:flutter_todo_bloc/data/storage/local_storage_service.dart';
import 'package:flutter_todo_bloc/main_bloc.dart';
import 'package:flutter_todo_bloc/ui/authentication/bloc/login_page_bloc.dart';
import 'package:flutter_todo_bloc/ui/authentication/bloc/registration_page_bloc.dart';
import 'package:flutter_todo_bloc/ui/todo_list/todo_list_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import 'data/repository/todo_repository.dart';

///Initialize Kiwi and register Network/Data Provider (Services), Data Handler (Repository), and Blocs
///Network/Data Provider and Data Handler are registered as Singleton.
///The same instances are used for API calls or data management within the app.
///
/// Blocs are registered as Factory.
/// A new instance is created as needed within a screen and destroyed(close) when widgets are disposed.
void initKiwi() {
  final container = kiwi.KiwiContainer();

  ///Register Network/Data provider as singleton.
  container.registerSingleton((c) => RestApiService());
  container.registerSingleton((c) => LocalStorageService());

  ///Register Data Handler as singleton.
  container.registerSingleton(
    (c) => UserRepository(
      c.resolve<RestApiService>(),
      c.resolve<LocalStorageService>(),
    ),
  );

  container.registerSingleton(
    (c) => TodoRepository(
      c.resolve<RestApiService>(),
      c.resolve<LocalStorageService>(),
    ),
  );

  ///Register Blocs for each feature.
  container.registerFactory(
        (c) => MainBloc(
      c.resolve<UserRepository>(),
    ),
  );

  container.registerFactory(
    (c) => LoginBloc(
      c.resolve<UserRepository>(),
    ),
  );

  container.registerFactory(
    (c) => RegistrationBloc(
      c.resolve<UserRepository>(),
    ),
  );

  container.registerFactory(
    (c) => TodoListBloc(
      c.resolve<TodoRepository>(),
    ),
  );
}
