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
    'confirm_details': {
      AppLanguage.nl: 'Controleer uw boeking',
      AppLanguage.en: 'Review your booking',
    },
    'service': {
      AppLanguage.nl: 'Service',
      AppLanguage.en: 'Service',
    },
    'cancel': {
      AppLanguage.nl: 'Annuleren',
      AppLanguage.en: 'Cancel',
    },
    'login': {
      AppLanguage.nl: 'Inloggen',
      AppLanguage.en: 'Login',
    },
    'register': {
      AppLanguage.nl: 'Registreren',
      AppLanguage.en: 'Register',
    },
    'email': {
      AppLanguage.nl: 'E-mail',
      AppLanguage.en: 'Email',
    },
    'password': {
      AppLanguage.nl: 'Wachtwoord',
      AppLanguage.en: 'Password',
    },
    'no_account_register': {
      AppLanguage.nl: 'Nog geen account? Registreer',
      AppLanguage.en: 'No account? Register',
    },
    'already_account_login': {
      AppLanguage.nl: 'Heb je al een account? Inloggen',
      AppLanguage.en: 'Already have an account? Login',
    },
    'greeting': {
      AppLanguage.nl: 'Welkom',
      AppLanguage.en: 'Welcome',
    },
    'logout': {
      AppLanguage.nl: 'Uitloggen',
      AppLanguage.en: 'Logout',
    },
    'blocked_dates': {
      AppLanguage.nl: 'Geblokkeerde data',
      AppLanguage.en: 'Blocked dates',
    },
    'add_blocked_date': {
      AppLanguage.nl: 'Datum blokkeren',
      AppLanguage.en: 'Add blocked date',
    },
    'no_blocked_dates': {
      AppLanguage.nl: 'Geen geblokkeerde data.',
      AppLanguage.en: 'No blocked dates.',
    },
    'user': {
      AppLanguage.nl: 'Gebruiker',
      AppLanguage.en: 'User',
    },
    'display_name': {
      AppLanguage.nl: 'Naam',
      AppLanguage.en: 'Display name',
    },
    'profile': {
      AppLanguage.nl: 'Profiel',
      AppLanguage.en: 'Profile',
    },
    'profile_saved': {
      AppLanguage.nl: 'Profiel opgeslagen',
      AppLanguage.en: 'Profile saved',
    },
    'your_animals': {
      AppLanguage.nl: 'Jouw dieren',
      AppLanguage.en: 'Your animals',
    },
    'add_animal': {
      AppLanguage.nl: 'Dier toevoegen',
      AppLanguage.en: 'Add animal',
    },
    'animal_name': {
      AppLanguage.nl: 'Naam',
      AppLanguage.en: 'Name',
    },
    'select_birth_date': {
      AppLanguage.nl: 'Selecteer geboortedatum',
      AppLanguage.en: 'Select birth date',
    },
    'photo_url': {
      AppLanguage.nl: 'Foto URL',
      AppLanguage.en: 'Photo URL',
    },
    'save': {
      AppLanguage.nl: 'Opslaan',
      AppLanguage.en: 'Save',
    },
    'pick_photo': {
      AppLanguage.nl: 'Foto kiezen',
      AppLanguage.en: 'Pick photo'
    },
    'select_pets': {
      AppLanguage.nl: 'Selecteer huisdieren',
      AppLanguage.en: 'Select pets',
    },
    'pets': {
      AppLanguage.nl: 'Huisdieren',
      AppLanguage.en: 'Pets',
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