import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../models/service_type.dart';
import '../localization/app_localizations.dart';
import '../providers/auth_provider.dart';

class UpcomingBookingsList extends StatelessWidget {
  final List<Booking> bookings;
  final void Function(Booking)? onTap;

  const UpcomingBookingsList({
    super.key,
    required this.bookings,
    this.onTap,
  });

  Widget _buildBookingTile(BuildContext context, Booking booking, String subtitle) {
    return Card(
      child: ListTile(
        title: Text('${booking.service.localizedName(context)} (${booking.petName})'),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap != null ? () => onTap!(booking) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = auth.user?.uid ?? '';

    if (bookings.isEmpty) {
      return Text(AppLocalizations.of(context, 'no_upcoming_bookings'));
    }
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        String subtitle = '${booking.startDate.toLocal().toString().split(' ')[0]}'
            '${booking.endDate.isAfter(booking.startDate) ? ' - ${booking.endDate.toLocal().toString().split(' ')[0]}' : ''} • ${booking.status}';

        if (booking.userId != currentUserId && booking.userId.isNotEmpty) {
          return FutureBuilder<Map<String, dynamic>?>(
            future: auth.fetchUserProfile(booking.userId),
            builder: (context, snapshot) {
              final userName = snapshot.data?['displayName'] ?? snapshot.data?['email'] ?? booking.userId;
              final displaySubtitle = '$subtitle\n${AppLocalizations.of(context, 'user')}: $userName';
              return _buildBookingTile(context, booking, displaySubtitle);
            },
          );
        }

        return _buildBookingTile(context, booking, subtitle);
      },
    );
  }
}