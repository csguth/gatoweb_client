import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return DropdownButton<AppLanguage>(
      value: languageProvider.language,
      underline: const SizedBox(),
      items: const [
        DropdownMenuItem(
          value: AppLanguage.nl,
          child: Text('Nederlands'),
        ),
        DropdownMenuItem(
          value: AppLanguage.en,
          child: Text('English'),
        ),
      ],
      onChanged: (lang) {
        if (lang != null) languageProvider.setLanguage(lang);
      },
    );
  }
}