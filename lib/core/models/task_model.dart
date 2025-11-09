import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String index;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final bool isCompleted;

  TaskModel({
    required this.index,
    required this.name,
    required this.isCompleted,
  });
}
