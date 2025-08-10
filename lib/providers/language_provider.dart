import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { nl, en }

class LanguageProvider extends ChangeNotifier {
  static const _prefsKey = 'selected_language';
  AppLanguage _language = AppLanguage.nl;

  AppLanguage get language => _language;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langString = prefs.getString(_prefsKey);
    if (langString != null) {
      _language = AppLanguage.values.firstWhere(
        (e) => e.name == langString,
        orElse: () => AppLanguage.nl,
      );
      notifyListeners();
    }
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, lang.name);
  }
}