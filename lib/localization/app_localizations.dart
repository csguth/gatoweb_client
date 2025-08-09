import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class AppLocalizations {
  static final Map<String, Map<AppLanguage, String>> localized = {
    'title': {
      AppLanguage.nl: 'Nieuwe Boeking',
      AppLanguage.en: 'New Booking',
    },
    'choose_service': {
      AppLanguage.nl: 'Kies een service:',
      AppLanguage.en: 'Choose a service:',
    },
    'pet_name': {
      AppLanguage.nl: 'Naam huisdier',
      AppLanguage.en: 'Pet name',
    },
    'choose_period': {
      AppLanguage.nl: 'Kies periode',
      AppLanguage.en: 'Choose period',
    },
    'period': {
      AppLanguage.nl: 'Periode',
      AppLanguage.en: 'Period',
    },
    'from': {
      AppLanguage.nl: 'van',
      AppLanguage.en: 'from',
    },
    'to': {
      AppLanguage.nl: 'tot',
      AppLanguage.en: 'to',
    },
    'starting_from': {
      AppLanguage.nl: 'vanaf',
      AppLanguage.en: 'starting from',
    },
    'confirm_booking': {
      AppLanguage.nl: 'Boeking bevestigen',
      AppLanguage.en: 'Confirm booking',
    },
    'fill_all_fields': {
      AppLanguage.nl: 'Vul alle velden in',
      AppLanguage.en: 'Please fill all fields',
    },
    'walk': {
      AppLanguage.nl: 'wandeling',
      AppLanguage.en: 'walk',
    },
    'extra_pet': {
      AppLanguage.nl: 'extra huisdier',
      AppLanguage.en: 'extra pet',
    },
    'day': {
      AppLanguage.nl: 'dag',
      AppLanguage.en: 'day',
    },
    'service_hondenUitlaatservice': {
      AppLanguage.nl: 'Hondenuitlaatservice',
      AppLanguage.en: 'Dog walking service',
    },
    'service_eenHuisbezoekPerDag': {
      AppLanguage.nl: 'Eén huisbezoek per dag',
      AppLanguage.en: 'One home visit per day',
    },
    'service_tweeHuisbezoekenPerDag': {
      AppLanguage.nl: 'Twee huisbezoeken per dag',
      AppLanguage.en: 'Two home visits per day',
    },
    'start_new_booking': {
      AppLanguage.nl: 'Start nieuwe boeking',
      AppLanguage.en: 'Start new booking',
    },
    'upcoming_bookings': {
      AppLanguage.nl: 'Aankomende boekingen',
      AppLanguage.en: 'Upcoming bookings',
    },
    'no_upcoming_bookings': {
      AppLanguage.nl: 'Geen aankomende boekingen.',
      AppLanguage.en: 'No upcoming bookings.',
    },
    'status_pending_confirmation': {
      AppLanguage.nl: 'In afwachting van bevestiging',
      AppLanguage.en: 'Pending confirmation',
    },
    'status_confirmed': {
      AppLanguage.nl: 'Bevestigd',
      AppLanguage.en: 'Confirmed',
    },
    'status_ongoing': {
      AppLanguage.nl: 'Lopend',
      AppLanguage.en: 'Ongoing',
    },
    'status_awaiting_payment': {
      AppLanguage.nl: 'Wacht op betaling',
      AppLanguage.en: 'Awaiting payment',
    },
    'status_concluded': {
      AppLanguage.nl: 'Afgerond',
      AppLanguage.en: 'Concluded',
    },
    'status_cancelled': {
      AppLanguage.nl: 'Geannuleerd',
      AppLanguage.en: 'Cancelled',
    },
  };

  static String t(String key, AppLanguage language) {
    return localized[key]?[language] ?? key;
  }

  static String of(BuildContext context, String key) {
    final language = Provider.of<LanguageProvider>(context, listen: true).language;
    return t(key, language);
  }
}