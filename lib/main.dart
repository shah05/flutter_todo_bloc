import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_bloc/injection_container.dart';
import 'package:flutter_todo_bloc/ui/authentication/authentication_screen.dart';

void main() {
  initKiwi();
  runApp(const MyApp());
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final
//   @override
//   void initState() {
//
//     super.initState();
//   }
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => _mainBloc,
//       child: MaterialApp(
//         title: 'Flutter Todo',
//         theme: ThemeData(
//           primarySwatch: Colors.deepOrange,
//         ),
//         home: const AuthenticationScreen(),
//       ),
//     );
//   }
// }


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const AuthenticationScreen(),
    );
  }
}