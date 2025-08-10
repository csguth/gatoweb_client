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

class PetRef {
  final String uuid;
  PetRef({required this.uuid});

  Map<String, dynamic> toJson() => {'uuid': uuid};

  static PetRef fromJson(Map<String, dynamic> json) => PetRef(uuid: json['uuid']);
}

class Booking {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final ServiceType service;
  final List<PetRef> pets; // <-- Strongly typed array of PetRef
  final BookingStatus status;
  final String userId;

  Booking({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.service,
    required this.pets, // <-- Strongly typed
    required this.status,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'startDate': startDate.millisecondsSinceEpoch,
    'endDate': endDate.millisecondsSinceEpoch,
    'service': service.name,
    'pets': pets.map((p) => p.toJson()).toList(), // <-- Serialize PetRef
    'status': status.name,
    'userId': userId,
  };

  static Booking fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'],
    startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate']),
    endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']),
    service: ServiceType.values.firstWhere((e) => e.name == json['service']),
    pets: (json['pets'] as List<dynamic>? ?? [])
        .map((p) => PetRef.fromJson(p as Map<String, dynamic>))
        .toList(), // <-- Deserialize PetRef
    status: BookingStatus.values.firstWhere((e) => e.name == json['status']),
    userId: json['userId'],
  );
}