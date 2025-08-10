import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/auth_provider.dart';
import '../localization/app_localizations.dart';
import '../widgets/animal_dialog.dart';
import '../widgets/animal_list.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final displayNameController = TextEditingController();
  List<Map<String, dynamic>> animals = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.user?.uid;
    if (userId == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    displayNameController.text = doc.data()?['displayName'] ?? '';
    animals = List<Map<String, dynamic>>.from(doc.data()?['animals'] ?? []);
    setState(() {
      loading = false;
    });
  }

  Future<void> _saveProfile() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.user?.uid;
    if (userId == null) return;
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'displayName': displayNameController.text,
      'animals': animals,
    }, SetOptions(merge: true));
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(AppLocalizations.of(context, 'profile_saved'))),
    // );
  }

  Future<void> _addAnimal() async {
    final newAnimal = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AnimalDialog(),
    );
    if (newAnimal != null) {
      setState(() {
        animals.add(newAnimal);
      });
      await _saveProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context, 'profile')),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: displayNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context, 'display_name'),
              ),
            ),
            const SizedBox(height: 24),
            AnimalList(
              animals: animals,
              onEdit: (index, updatedAnimal) async {
                setState(() {
                  animals[index] = updatedAnimal;
                });
                await _saveProfile();
              },
              onDelete: (index) async {
                setState(() {
                  animals.removeAt(index);
                });
                await _saveProfile();
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _addAnimal,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context, 'add_animal')),
            ),
          ],
        ),
      ),
    );
  }
}

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
            final uuidValue = widget.initial?['uuid'] ?? const Uuid().v4(); // <-- Generate uuid if missing
            Navigator.pop(context, {
              'uuid': uuidValue,
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