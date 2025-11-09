import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final int itemCount;
  final bool isDarkTheme;
  final VoidCallback onToggleTheme;

  const CustomHeader({
    super.key,
    required this.itemCount,
    required this.isDarkTheme,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'My Task List',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$itemCount ${itemCount == 1 ? 'task' : 'tasks'}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),

          IconButton(
            icon: Icon(
              isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: onToggleTheme,
          ),
        ],
      ),
    );
  }
}
