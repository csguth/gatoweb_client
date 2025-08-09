import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/service_type.dart';
import '../localization/app_localizations.dart';

class UpcomingBookingsList extends StatelessWidget {
  final List<Booking> bookings;
  final void Function(Booking)? onTap;

  const UpcomingBookingsList({
    super.key,
    required this.bookings,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Text(AppLocalizations.of(context, 'no_upcoming_bookings'));
    }
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          child: ListTile(
            title: Text('${booking.service.localizedName(context)} (${booking.petName})'),
            subtitle: Text(
              '${booking.startDate.toLocal().toString().split(' ')[0]}'
              '${booking.endDate.isAfter(booking.startDate) ? ' - ${booking.endDate.toLocal().toString().split(' ')[0]}' : ''} • ${booking.status}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap != null ? () => onTap!(booking) : null,
          ),
        );
      },
    );
  }
}