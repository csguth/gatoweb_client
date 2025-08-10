import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../localization/app_localizations.dart';

enum AnimalType { cat, dog, rodent, reptile, bird, other }

class AnimalDialog extends StatefulWidget {
  final Map<String, dynamic>? initial;
  const AnimalDialog({super.key, this.initial});

  @override
  State<AnimalDialog> createState() => _AnimalDialogState();
}

class _AnimalDialogState extends State<AnimalDialog> {
  final nameController = TextEditingController();
  DateTime? birthDate;
  AnimalType type = AnimalType.cat;
  String? photoUrl;
  PlatformFile? pickedImage;
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      nameController.text = widget.initial!['name'] ?? '';
      type = AnimalType.values.firstWhere(
        (t) => t.name == widget.initial!['type'],
        orElse: () => AnimalType.cat,
      );
      birthDate = widget.initial!['birthDate'] != null
          ? DateTime.tryParse(widget.initial!['birthDate'])
          : null;
      photoUrl = widget.initial!['photoUrl'];
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        pickedImage = result.files.single;
      });
    }
  }

  Future<String?> _uploadImage(PlatformFile image) async {
    setState(() { uploading = true; });
    final ref = FirebaseStorage.instance
        .ref('animal_photos/${DateTime.now().millisecondsSinceEpoch}_${image.name}');
    await ref.putData(image.bytes!);
    final url = await ref.getDownloadURL();
    setState(() { uploading = false; });
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context, 'add_animal')),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context, 'animal_name')),
            ),
            const SizedBox(height: 8),
            DropdownButton<AnimalType>(
              value: type,
              items: AnimalType.values.map((t) => DropdownMenuItem(
                value: t,
                child: Text(t.name),
              )).toList(),
              onChanged: (val) => setState(() => type = val!),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => birthDate = picked);
              },
              child: Text(birthDate == null
                  ? AppLocalizations.of(context, 'select_birth_date')
                  : birthDate!.toLocal().toString().split(' ')[0]),
            ),
            const SizedBox(height: 8),
            pickedImage != null
              ? Image.memory(
                  pickedImage!.bytes!,
                  height: 100,
                )
              : photoUrl != null
                ? Image.network(photoUrl!, height: 100)
                : const SizedBox.shrink(),
            TextButton.icon(
              icon: const Icon(Icons.photo),
              label: Text(AppLocalizations.of(context, 'pick_photo')),
              onPressed: _pickImage,
            ),
            if (uploading) const CircularProgressIndicator(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context, 'cancel')),
        ),
        ElevatedButton(
          onPressed: () async {
            String? finalPhotoUrl = photoUrl;
            if (pickedImage != null) {
              finalPhotoUrl = await _uploadImage(pickedImage!);
            }
            if (!mounted) return;
            Navigator.pop(context, {
              'name': nameController.text,
              'type': type.name,
              'birthDate': birthDate?.toIso8601String(),
              'photoUrl': finalPhotoUrl,
            });
          },
          child: Text(AppLocalizations.of(context, 'save')),
        ),
      ],
    );
  }
}