import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_page_bloc.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final String? errorMsg;
  const LoginForm(
      {Key? key,
      required this.passwordCtrl,
      required this.emailCtrl,
      this.errorMsg})
      : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Login to Todoey",
          style: TextStyle(fontSize: 30.0),
        ),
        const SizedBox(
          height: 30.0,
        ),
        TextField(
          controller: widget.emailCtrl,
          decoration: const InputDecoration(
            icon: Icon(Icons.email),
            label: Text('Email'),
          ),
        ),
        TextField(
          controller: widget.passwordCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.lock),
            label: Text('Password'),
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        ElevatedButton(
          onPressed: () async {
            BlocProvider.of<LoginBloc>(context).add(
              TriggerLogin(
                  username: widget.emailCtrl.text,
                  password: widget.passwordCtrl.text),
            );
          },
          child: const Text('Login'),
        ),
        const SizedBox(
          height: 20.0,
        ),
        widget.errorMsg == null ? Container() : Text(widget.errorMsg!)
      ],
    );
  }
}
