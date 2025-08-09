import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class PetNameInput extends StatelessWidget {
  final TextEditingController controller;

  const PetNameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context, 'pet_name'),
        border: const OutlineInputBorder(),
      ),
    );
  }
}