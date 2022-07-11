import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_bloc/ui/todo_list/todo_list_bloc.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({Key? key}) : super(key: key);

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (context, state) {
        if (state is TodoListLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TodoListSuccessful) {
          return ListView.separated(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete this task ?'),
                        content: Text(state.todos[index].description),
                        actions: [
                          TextButton(
                              onPressed: () {
                                //Todo: implement add Delete even to todolistbloc
                              },
                              child: const Text('Yes')),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          )
                        ],
                      );
                    },
                  );
                },
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const Text('Delete');
                      });
                },
                child: CheckboxListTile(
                  title: Text(
                    state.todos[index].description,
                    style: TextStyle(
                        decoration: state.todos[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  subtitle: Text(state.todos[index].createdAt.toString()),
                  value: state.todos[index].isCompleted,
                  onChanged: (bool? value) {},
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        } else if (state is TodoListFailed) {
          return Center(
            child: Text(state.errorMsg),
          );
        }
        return Container();
      },
    );
  }
}
