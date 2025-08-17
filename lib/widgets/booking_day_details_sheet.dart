import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';
import '../models/service_type.dart';
import 'booking_status_wizard.dart';
import '../services/booking_service.dart';

class BookingDayDetailsSheet extends StatefulWidget {
  final List<Booking> bookings;
  final void Function(Booking)? onTap;
  final VoidCallback? onStatusChanged;

  const BookingDayDetailsSheet({
    super.key,
    required this.bookings,
    this.onTap,
    this.onStatusChanged,
  });

  @override
  State<BookingDayDetailsSheet> createState() => _BookingDayDetailsSheetState();
}

class _BookingDayDetailsSheetState extends State<BookingDayDetailsSheet> {
  late List<Booking> _bookings;

  @override
  void initState() {
    super.initState();
    _bookings = List<Booking>.from(widget.bookings);
  }

  Future<Map<String, dynamic>> _fetchUserInfo(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data() ?? {};
    final displayName = data['displayName'] ?? userId;
    final pets = List<Map<String, dynamic>>.from(data['animals'] ?? []);
    final petNamesMap = { for (var pet in pets) pet['uuid'] as String: pet['name'] as String };
    return {
      'displayName': displayName,
      'petNamesMap': petNamesMap,
    };
  }

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pendingConfirmation:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.blue.shade200;
      case BookingStatus.ongoing:
        return Colors.blue;
      case BookingStatus.awaitingPayment:
        return Colors.yellow;
      case BookingStatus.cancelled:
        return Colors.grey;
      case BookingStatus.concluded:
        return Colors.green;
      default:
        return Colors.redAccent;
    }
  }

  void _updateBookingStatusLocal(int index, BookingStatus newStatus) async {
    final booking = _bookings[index];
    final updatedBooking = Booking(
      id: booking.id,
      startDate: booking.startDate,
      endDate: booking.endDate,
      service: booking.service,
      pets: booking.pets,
      status: newStatus,
      userId: booking.userId,
    );
    await saveBooking(updatedBooking);
    setState(() {
      _bookings[index] = updatedBooking;
    });
    if (widget.onStatusChanged != null) {
      widget.onStatusChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final booking = _bookings[index];
        return FutureBuilder<Map<String, dynamic>>(
          future: _fetchUserInfo(booking.userId),
          builder: (context, snapshot) {
            final userInfo = snapshot.data ?? {};
            final displayName = userInfo['displayName'] ?? booking.userId;
            final petNamesMap = userInfo['petNamesMap'] as Map<String, String>? ?? {};
            final petNames = booking.pets.map((petRef) => petNamesMap[petRef.uuid] ?? petRef.uuid).join(', ');
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _statusColor(booking.status),
                  ),
                  title: Text(displayName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.service.localizedName(context)),
                      Text(petNames),
                      Text(
                        '${booking.startDate.toLocal().toString().split(' ')[0]} - '
                        '${booking.endDate.toLocal().toString().split(' ')[0]} '
                        '(${booking.endDate.difference(booking.startDate).inDays + 1} days)',
                      ),
                    ],
                  ),
                  onTap: widget.onTap != null ? () => widget.onTap!(booking) : null,
                ),
                BookingStatusWizard(
                  booking: booking,
                  onStatusChange: (newStatus) async {
                    _updateBookingStatusLocal(index, newStatus);
                  },
                ),
                const Divider(),
              ],
            );
          },
        );
      },
    );
  }
}