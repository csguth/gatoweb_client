import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../models/booking.dart';
import '../config/price_config.dart' show priceConfig;
import '../mock/upcoming_bookings.dart';
import '../localization/app_localizations.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/upcoming_bookings_list.dart';
import 'new_booking_page.dart';
import 'blocked_dates_page.dart';

Future<List<DateTime>> loadBlockedDates() async {
  final doc = await FirebaseFirestore.instance.collection('settings').doc('blockedDates').get();
  final dates = (doc.data()?['dates'] as List<dynamic>? ?? [])
      .map((ts) => DateTime.fromMillisecondsSinceEpoch(ts))
      .toList();
  return dates;
}

Future<void> saveBlockedDates(List<DateTime> dates) async {
  await FirebaseFirestore.instance.collection('settings').doc('blockedDates').set({
    'dates': dates.map((d) => d.millisecondsSinceEpoch).toList(),
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Booking> upcomingBookings = List.from(upcomingBookingsMock);
  List<DateTime> blockedDates = [];

  void _startNewBooking() async {
    final newBooking = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewBookingPage(
          priceConfig: priceConfig,
          blockedDates: blockedDates,
        ),
      ),
    );
    if (newBooking != null && newBooking is Booking) {
      setState(() {
        upcomingBookings.add(newBooking);
        upcomingBookings.sort((a, b) => a.startDate.compareTo(b.startDate));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBlockedDates();
  }

  Future<void> _loadBlockedDates() async {
    final loaded = await loadBlockedDates();
    setState(() {
      blockedDates = loaded;
    });
  }

  void _updateBlockedDates(List<DateTime> dates) async {
    setState(() {
      blockedDates = dates;
    });
    await saveBlockedDates(dates);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final userName = auth.user?.displayName ?? auth.user?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: const [
          LanguageDropdown(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${AppLocalizations.of(context, 'greeting')}, $userName!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.event_busy),
                  label: Text(AppLocalizations.of(context, 'blocked_dates')),
                  onPressed: () async {
                    final result = await Navigator.push<List<DateTime>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlockedDatesPage(
                          blockedDates: blockedDates,
                          onChanged: _updateBlockedDates,
                        ),
                      ),
                    );
                    if (result != null) {
                      _updateBlockedDates(result);
                    }
                  },
                ),
                TextButton.icon(
                  onPressed: () async {
                    await auth.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(AppLocalizations.of(context, 'logout')),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _startNewBooking,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context, 'start_new_booking')),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context, 'upcoming_bookings'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: upcomingBookings.isEmpty
                  ? Text(AppLocalizations.of(context, 'no_upcoming_bookings'))
                  : UpcomingBookingsList(bookings: upcomingBookings),
            ),
          ],
        ),
      ),
    );
  }
}