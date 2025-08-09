import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../localization/app_localizations.dart';
import 'service_type.dart';

enum BookingStatus {
  pendingConfirmation,
  confirmed,
  ongoing,
  awaitingPayment,
  concluded,
  cancelled,
}

extension BookingStatusExtension on BookingStatus {
  String localizedName(BuildContext context) {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    switch (this) {
      case BookingStatus.pendingConfirmation:
        return AppLocalizations.t('status_pending_confirmation', language);
      case BookingStatus.confirmed:
        return AppLocalizations.t('status_confirmed', language);
      case BookingStatus.ongoing:
        return AppLocalizations.t('status_ongoing', language);
      case BookingStatus.awaitingPayment:
        return AppLocalizations.t('status_awaiting_payment', language);
      case BookingStatus.concluded:
        return AppLocalizations.t('status_concluded', language);
      case BookingStatus.cancelled:
        return AppLocalizations.t('status_cancelled', language);
    }
  }
}

class Booking {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final ServiceType service;
  final String petName;
  final BookingStatus status;

  Booking({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.service,
    required this.petName,
    required this.status,
  });
}