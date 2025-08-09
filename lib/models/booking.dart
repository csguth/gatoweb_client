import 'service_type.dart';

class Booking {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final ServiceType service;
  final String petName;
  final String status;

  Booking({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.service,
    required this.petName,
    required this.status,
  });
}