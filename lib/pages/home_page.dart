import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/booking.dart';
import '../config/price_config.dart' show priceConfig;
import '../mock/upcoming_bookings.dart';
import '../localization/app_localizations.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/upcoming_bookings_list.dart';
import 'new_booking_page.dart';

final List<DateTime> blockedDates = [
  DateTime(2025, 8, 15),
  DateTime(2025, 8, 20),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Booking> upcomingBookings = List.from(upcomingBookingsMock);

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