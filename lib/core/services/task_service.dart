import 'package:hive/hive.dart';
import 'package:task_manager/core/models/task_model.dart';

class TaskService {
  static const String boxName = 'tasksBox';
  late Box<TaskModel> _taskBox;

  Future<void> initializeHive() async {
    if (!Hive.isAdapterRegistered(TaskModelAdapter().typeId)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    _taskBox = await Hive.openBox<TaskModel>(boxName);
  }

  Future<void> addTask(TaskModel task) async {
    await _taskBox.put(task.index, task);
  }

  List<TaskModel> getAllTasks() {
    return _taskBox.values.toList();
  }

  Future<void> deleteTask(String index) async {
    await _taskBox.delete(index);
  }

  Future<void> editTask(TaskModel task) async {
    await _taskBox.put(task.index, task);
  }
}
