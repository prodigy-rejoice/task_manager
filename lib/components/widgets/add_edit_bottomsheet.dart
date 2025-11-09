import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/bloc/task/task_cubit.dart';
import 'package:task_manager/core/models/task_model.dart';

class AddEditBottomSheet extends StatefulWidget {
  final TaskModel? task;

  const AddEditBottomSheet({super.key, this.task});

  @override
  State<AddEditBottomSheet> createState() => _AddEditBottomSheetState();
}

class _AddEditBottomSheetState extends State<AddEditBottomSheet> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.task?.name ?? '');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final cubit = context.read<TaskCubit>();

    if (widget.task != null) {
      final updatedTask = TaskModel(
        index: widget.task!.index,
        name: text,
        isCompleted: widget.task!.isCompleted,
      );
      cubit.updateTask(updatedTask);
    } else {
      final newIndexKey = DateTime.now().millisecondsSinceEpoch.toString();
      final newTask = TaskModel(
        index: newIndexKey,
        name: text,
        isCompleted: false,
      );
      cubit.addTask(newTask);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing ? 'Edit Task' : 'Add Task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Save Changes' : 'Add Task'),
                onPressed: _save,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
