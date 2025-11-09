import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/core/bloc/task/task_cubit.dart';
import 'package:task_manager/core/services/task_service.dart';
import 'package:task_manager/screens/home/home_screen.dart';

import 'core/bloc/theme/theme_cubit.dart';
import 'core/bloc/theme/theme_state.dart';

late Box<bool> themeBox;
const String _themeBoxName = 'settingsBox';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final taskService = TaskService();
  await taskService.initializeHive();

  themeBox = await Hive.openBox<bool>(_themeBoxName);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TaskCubit(taskService)..loadTasks()),
        BlocProvider(create: (_) => ThemeCubit(themeBox)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: themeState.themeMode,
          debugShowCheckedModeBanner: false,
          title: 'Task Manager',
          home: HomeScreen(),
        );
      },
    );
  }
}
