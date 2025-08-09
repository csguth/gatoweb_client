import 'package:flutter/material.dart';

enum AppLanguage { nl, en }

class LanguageProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.nl;

  AppLanguage get language => _language;

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }
}