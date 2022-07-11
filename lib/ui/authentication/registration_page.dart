import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_bloc/ui/authentication/bloc/registration_page_bloc.dart';
import 'package:flutter_todo_bloc/ui/authentication/widgets/registration_form.dart';
import 'package:flutter_todo_bloc/ui/todo_list/todo_list_screen.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late TextEditingController _usernameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _ageCtrl;

  @override
  void initState() {
    _usernameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _ageCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _emailCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccessful) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TodoListScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is RegistrationInitial) {
            return RegistrationForm(
                passwordCtrl: _passwordCtrl,
                usernameCtrl: _usernameCtrl,
                ageCtrl: _ageCtrl,
                emailCtrl: _emailCtrl);
          } else if (state is RegistrationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is RegistrationFailed) {
            return RegistrationForm(
                passwordCtrl: _passwordCtrl,
                usernameCtrl: _usernameCtrl,
                ageCtrl: _ageCtrl,
                emailCtrl: _emailCtrl,
                errorMsg: state.errorMsg);
          }
          return Container();
        },
      ),
    );
  }
}
