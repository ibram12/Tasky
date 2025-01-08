
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Widget/TaskItem.dart';
import '../cubits/TaskScreen_cubit/task_screen_cubit.dart';
import '../models/TodoItem.dart';
class TaskList extends StatefulWidget {
  final String filter;

  const TaskList({required this.filter});

  @override
  _TaskListState createState() => _TaskListState();
}
class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TaskScreenCubit, TaskScreenState>(
      listener: (context, state) {
        if (state is TaskScreenFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        if (state is TaskScreenLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TaskScreenEmpty) {
          return Center(child: Text('No tasks available'));
        } else if (state is TaskScreenLoaded) {
          List<TodoItem> filteredTasks = state.tasks;
          if (widget.filter != 'All') {
            filteredTasks = filteredTasks
                .where((task) => task.status.toLowerCase() == widget.filter.toLowerCase())
                .toList();
          }
          return ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              return TaskItem(task: filteredTasks[index]);
            },
          );
        } else {
          return Center(child: Text('Unexpected state'));
        }
      },
    );

  }
}
