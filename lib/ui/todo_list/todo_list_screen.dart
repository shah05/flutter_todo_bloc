import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_bloc/ui/todo_list/todo_list_bloc.dart';
import 'package:flutter_todo_bloc/ui/todo_list/todo_listview.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late TodoListBloc _todoListBloc;
  late TextEditingController _todoCtrl;

  @override
  void initState() {
    _todoListBloc = kiwi.KiwiContainer().resolve<TodoListBloc>();
    _todoListBloc.add(FetchAllTodos());
    _todoCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _todoListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _todoListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Todos'),
        ),
        body: const TodoListView(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text('Add new Todo'),
                          TextField(
                            controller: _todoCtrl,
                            decoration: const InputDecoration(
                              label: Text('Write something'),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                            ),
                            onPressed: () {
                              _todoListBloc.add(
                                AddNewTodo(_todoCtrl.text),
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Add'),
                          )
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
