import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Services/Services.dart';
import '../../models/TodoItem.dart';

part 'task_screen_state.dart';

class TaskScreenCubit extends Cubit<TaskScreenState> {
  TaskScreenCubit() : super(TaskScreenInitial());
  final services = Services();
  Future fetchTasks() async {
    emit(TaskScreenLoading());
    try {
      String? token = await services.refreshAccessToken();
      var headers = {'Authorization': 'Bearer $token'};
      var response = await http.get(
          Uri.parse('https://todo.iraqsapp.com/todos?page=1'),
          headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          final tasks=responseData
              .map((item) => TodoItem.fromJson(item as Map<String, dynamic>))
              .toList() ;
          emit(TaskScreenLoaded(tasks:tasks));

        } else {
          emit(TaskScreenFailure(error: response.body));
        }
      } else {
        emit(TaskScreenFailure(error: response.reasonPhrase.toString()));
      }
    } catch (e) {
      emit(TaskScreenFailure(error: e.toString()));
      rethrow;
    }
  }
}
