import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../localization/app_localizations.dart';
import 'package:flutter/widgets.dart';

enum ServiceType {
  hondenUitlaatservice,
  eenHuisbezoekPerDag,
  tweeHuisbezoekenPerDag,
}

extension ServiceTypeExtension on ServiceType {
  String get displayName {
    switch (this) {
      case ServiceType.hondenUitlaatservice:
        return 'Hondenuitlaatservice';
      case ServiceType.eenHuisbezoekPerDag:
        return 'Eén huisbezoek per dag';
      case ServiceType.tweeHuisbezoekenPerDag:
        return 'Twee huisbezoeken per dag';
    }
  }

  String localizedName(BuildContext context) {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    switch (this) {
      case ServiceType.hondenUitlaatservice:
        return AppLocalizations.t('service_hondenUitlaatservice', language);
      case ServiceType.eenHuisbezoekPerDag:
        return AppLocalizations.t('service_eenHuisbezoekPerDag', language);
      case ServiceType.tweeHuisbezoekenPerDag:
        return AppLocalizations.t('service_tweeHuisbezoekenPerDag', language);
    }
  }
}