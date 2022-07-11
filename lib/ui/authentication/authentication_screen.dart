import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_bloc/ui/authentication/registration_page.dart';
import 'package:flutter_todo_bloc/ui/todo_list/todo_list_screen.dart';
import 'bloc/login_page_bloc.dart';
import 'bloc/registration_page_bloc.dart';
import 'login_page.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late PageController _pageCtrl;
  int _currentPage = 0;
  late LoginBloc _loginBloc;
  late RegistrationBloc _registrationBloc;

  @override
  void initState() {
    _loginBloc = kiwi.KiwiContainer().resolve<LoginBloc>();
    _registrationBloc = kiwi.KiwiContainer().resolve<RegistrationBloc>();
    _loginBloc.add(CheckUserStatus());
    _pageCtrl = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _loginBloc.close();
    _registrationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => _loginBloc,
          ),
          BlocProvider(
            create: (context) => _registrationBloc,
          )
        ],
        child: BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
          if (state is LoginNotRequired) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TodoListScreen(),
              ),
            );
          }
        }, builder: (context, state) {
          if (state is LoginLoading) {
            return const CircularProgressIndicator();
          } else if (state is LoginInitial) {
            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageCtrl,
              children: const [
                LoginPage(),
                RegistrationPage(),
              ],
            );
          }
          return Container();
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (navItem) {
          setState(() {
            _currentPage = navItem;
            _pageCtrl.animateToPage(
              navItem,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: "Login",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: "Register",
          )
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: PageView(
  //       physics: const NeverScrollableScrollPhysics(),
  //       controller: _pageCtrl,
  //       children: [
  //         BlocProvider(
  //           create: (context) => _loginBloc,
  //           child: const LoginPage(),
  //         ),
  //         BlocProvider(
  //           create: (context) => _registrationBloc,
  //           child: const RegistrationPage(),
  //         )
  //       ],
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       currentIndex: _currentPage,
  //       selectedItemColor: Theme.of(context).primaryColor,
  //       onTap: (navItem) {
  //         setState(() {
  //           _currentPage = navItem;
  //           _pageCtrl.animateToPage(
  //             navItem,
  //             duration: const Duration(milliseconds: 500),
  //             curve: Curves.ease,
  //           );
  //         });
  //       },
  //       items: const [
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.login),
  //           label: "Login",
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.touch_app),
  //           label: "Register",
  //         )
  //       ],
  //     ),
  //   );
  // }
}
