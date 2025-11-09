import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:task_manager/components/widgets/add_edit_bottomsheet.dart';
import 'package:task_manager/components/widgets/custom_header.dart';
import 'package:task_manager/components/widgets/empty_state.dart';
import 'package:task_manager/components/widgets/item_tile.dart';
import 'package:task_manager/core/bloc/task/task_cubit.dart';
import 'package:task_manager/core/bloc/theme/theme_cubit.dart';
import 'package:task_manager/core/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadTasks();
  }

  void _openBottomSheet({TaskModel? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddEditBottomSheet(task: task),
    );
  }

  void _deleteItem(TaskModel task) {
    final cubit = context.read<TaskCubit>();
    cubit.deleteTask(task.index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${task.name}"'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amber,
          onPressed: () => cubit.addTask(task),
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final isDark = themeState.themeMode == ThemeMode.dark;

    void toggleAction() {
      context.read<ThemeCubit>().toggleTheme();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            int count = 0;
            bool isLoading = false;
            if (state is TaskLoading) {
              isLoading = true;
            } else if (state is TaskLoaded) {
              count = state.tasks.length;
            }
            return CustomHeader(
              itemCount: count,
              isDarkTheme: isDark,
              onToggleTheme: toggleAction,
            );
          },
        ),
      ),
      body: AnimatedSwitcher(
        key: ValueKey(0),
        duration: const Duration(milliseconds: 500),
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return _buildSkeletonList();
            } else if (state is TaskLoaded) {
              final tasks = state.tasks;
              if (tasks.isEmpty) return EmptyState();

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ItemTile(
                      indexKey: task.index,
                      title: task.name,
                      onEdit: () => _openBottomSheet(task: task),
                      onDelete: () => _deleteItem(task),
                    ),
                  );
                },
              );
            } else if (state is TaskError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Something went wrong!'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openBottomSheet(),
        label: Text('Add Task'),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 2,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ListTile(
              title: Text('Loading item...'),
              trailing: Icon(Icons.edit),
            ),
          ),
        ),
      ),
    );
  }
}
