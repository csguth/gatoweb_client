import '../models/service_type.dart';
import '../models/booking.dart';

final List<Booking> upcomingBookingsMock = [
  Booking(
    id: '1',
    startDate: DateTime.now().add(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 1)),
    service: ServiceType.hondenUitlaatservice,
    petName: 'Max',
    status: 'Bevestigd',
  ),
  Booking(
    id: '2',
    startDate: DateTime.now().add(const Duration(days: 3)),
    endDate: DateTime.now().add(const Duration(days: 5)),
    service: ServiceType.eenHuisbezoekPerDag,
    petName: 'Bella',
    status: 'In afwachting',
  ),
];