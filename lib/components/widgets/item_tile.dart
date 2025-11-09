import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final String indexKey;
  final String title;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItemTile({
    super.key,
    required this.indexKey,
    required this.title,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(indexKey),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          title: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueGrey),
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }
}
