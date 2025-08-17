import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

Future<void> saveBooking(Booking booking) async {
  await FirebaseFirestore.instance.collection('bookings').doc(booking.id).set({
    'startDate': booking.startDate.millisecondsSinceEpoch,
    'endDate': booking.endDate.millisecondsSinceEpoch,
    'service': booking.service.name,
    'pets': booking.pets.map((p) => p.toJson()).toList(),
    'status': booking.status.name,
    'userId': booking.userId,
  });
}