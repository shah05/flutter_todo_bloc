import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_bloc/data/network/rest_api_service.dart';
import 'package:flutter_todo_bloc/data/repository/user_repository.dart';
import 'package:flutter_todo_bloc/data/storage/local_storage_service.dart';
import 'package:flutter_todo_bloc/ui/authentication/bloc/login_page_bloc.dart';
import 'package:flutter_todo_bloc/ui/authentication/widgets/login_form.dart';
import 'package:flutter_todo_bloc/ui/todo_list/todo_list_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  @override
  void initState() {
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessful) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TodoListScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoginFailed) {
            return LoginForm(
              passwordCtrl: _passwordCtrl,
              emailCtrl: _emailCtrl,
              errorMsg: state.errorMsg,
            );
          } else if (state is LoginInitial) {
            return LoginForm(
              passwordCtrl: _passwordCtrl,
              emailCtrl: _emailCtrl,
            );
          }
          return Container();
        },
      ),
    );
  }
}
