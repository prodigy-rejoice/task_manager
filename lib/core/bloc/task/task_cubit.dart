import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/models/task_model.dart';
import 'package:task_manager/core/services/task_service.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskService _taskService;

  TaskCubit(this._taskService) : super(TaskInitial());

  Future<void> loadTasks() async {
    try {
      emit(TaskLoading());
      await Future.delayed(const Duration(milliseconds: 300));
      final tasks = _taskService.getAllTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _taskService.addTask(task);

      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        final updatedTasks = [...currentTasks, task];
        emit(TaskLoaded(updatedTasks));
      } else {
        final tasks = _taskService.getAllTasks();
        emit(TaskLoaded(tasks));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _taskService.editTask(task);

      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        final updatedTasks = currentTasks
            .map((t) => t.index == task.index ? task : t)
            .toList();
        emit(TaskLoaded(updatedTasks));
      } else {
        final tasks = _taskService.getAllTasks();
        emit(TaskLoaded(tasks));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // Future<void> deleteTask(int index) async {
  //   try {
  //     await _taskService.deleteTask(index);
  //     final tasks = _taskService.getAllTasks();
  //     emit(TaskLoaded(tasks));
  //   } catch (e) {
  //     emit(TaskError(e.toString()));
  //   }
  // }
  // core/bloc/task/task_cubit.dart

  // ... (other methods)

  Future<void> deleteTask(String index) async {
    if (state is TaskLoaded) {
      final currentTasks = (state as TaskLoaded).tasks;

      final updatedTasks = currentTasks
          .where((task) => task.index != index)
          .toList();
      emit(TaskLoaded(updatedTasks));

      try {
        await _taskService.deleteTask(index);
      } catch (e) {
        print('Error deleting task from service: $e');
        emit(TaskError(e.toString()));
      }
    }
  }
}
