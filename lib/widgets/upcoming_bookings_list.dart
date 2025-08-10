import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../models/service_type.dart';
import '../localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingBookingsList extends StatelessWidget {
  final List<Booking> bookings;
  final void Function(Booking)? onTap;

  const UpcomingBookingsList({
    super.key,
    required this.bookings,
    this.onTap,
  });

  Widget _buildBookingTile(BuildContext context, Booking booking, String subtitle, String petNames) {
    return Card(
      child: ListTile(
        title: Text('${booking.service.localizedName(context)} ($petNames)'),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap != null ? () => onTap!(booking) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (bookings.isEmpty) {
      return Text(AppLocalizations.of(context, 'no_upcoming_bookings'));
    }

    final userIds = bookings.map((b) => b.userId).toSet().toList();

    return FutureBuilder<Map<String, Map<String, dynamic>>>(
      future: _fetchAllUserInfo(userIds),
      builder: (context, snapshot) {
        final allUserInfo = snapshot.data ?? {};

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final userInfo = allUserInfo[booking.userId] ?? {};
            final petNamesMap = userInfo['petNames'] as Map<String, String>? ?? {};
            final displayName = userInfo['displayName'] as String? ?? booking.userId;
            final petNames = booking.pets
                .map((petRef) => petNamesMap[petRef.uuid] ?? petRef.uuid)
                .join(', ');

            String subtitle = '${booking.startDate.toLocal().toString().split(' ')[0]}'
                '${booking.endDate.isAfter(booking.startDate) ? ' - ${booking.endDate.toLocal().toString().split(' ')[0]}' : ''} • ${booking.status}';

            if (booking.userId != auth.user?.uid && booking.userId.isNotEmpty) {
              subtitle += '\n${AppLocalizations.of(context, 'user')}: $displayName';
            }

            return _buildBookingTile(context, booking, subtitle, petNames);
          },
        );
      },
    );
  }

  // Helper to fetch displayName and pet names for each user
  Future<Map<String, Map<String, dynamic>>> _fetchAllUserInfo(List<String> userIds) async {
    final firestore = FirebaseFirestore.instance;
    Map<String, Map<String, dynamic>> result = {};
    for (final userId in userIds) {
      final doc = await firestore.collection('users').doc(userId).get();
      final pets = List<Map<String, dynamic>>.from(doc.data()?['animals'] ?? []);
      final displayName = doc.data()?['displayName'] ?? userId;
      result[userId] = {
        'displayName': displayName,
        'petNames': { for (var pet in pets) pet['uuid'] as String: pet['name'] as String }
      };
    }
    return result;
  }
}