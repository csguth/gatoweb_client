import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import 'animal_dialog.dart';

class AnimalList extends StatelessWidget {
  final List<Map<String, dynamic>> animals;
  final Future<void> Function(int, Map<String, dynamic>) onEdit;
  final Future<void> Function(int) onDelete;

  const AnimalList({
    super.key,
    required this.animals,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context, 'your_animals'), style: Theme.of(context).textTheme.titleMedium),
        ...animals.asMap().entries.map((entry) {
          final index = entry.key;
          final animal = entry.value;
          return ListTile(
            leading: animal['photoUrl'] != null
                ? CircleAvatar(backgroundImage: NetworkImage(animal['photoUrl']))
                : const CircleAvatar(child: Icon(Icons.pets)),
            title: Text(animal['name'] ?? ''),
            subtitle: Text('${animal['type'] ?? ''} • ${animal['birthDate'] ?? ''}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updatedAnimal = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) => AnimalDialog(initial: animal),
                    );
                    if (updatedAnimal != null) {
                      await onEdit(index, updatedAnimal);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await onDelete(index);
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}