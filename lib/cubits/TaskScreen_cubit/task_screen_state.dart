part of 'task_screen_cubit.dart';

@immutable
sealed class TaskScreenState {}

final class TaskScreenInitial extends TaskScreenState {}
final class TaskScreenLoading extends TaskScreenState {}
final class TaskScreenLoaded  extends TaskScreenState {
  final List<TodoItem> tasks;
  TaskScreenLoaded({required this.tasks});
}
final class TaskScreenEmpty extends TaskScreenState {}
class TaskScreenFailure extends TaskScreenState {
  final String error;
  TaskScreenFailure({required this.error});
}