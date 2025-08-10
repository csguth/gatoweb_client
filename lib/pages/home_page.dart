import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_type.dart';
import '../providers/auth_provider.dart';
import '../models/booking.dart';
import '../config/price_config.dart' show priceConfig;
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

Future<List<Booking>> loadUpcomingBookings(String userId, {bool isAdmin = false}) async {
  QuerySnapshot<Map<String, dynamic>> snapshot;
  if (isAdmin) {
    snapshot = await FirebaseFirestore.instance.collection('bookings').get();
  } else {
    snapshot = await FirebaseFirestore.instance
      .collection('bookings')
      .where('userId', isEqualTo: userId)
      .get();
  }
  return snapshot.docs.map((doc) {
    final data = doc.data();
    return Booking(
      id: doc.id,
      startDate: DateTime.fromMillisecondsSinceEpoch(data['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(data['endDate']),
      service: ServiceType.values.firstWhere((e) => e.name == data['service']),
      petName: data['petName'],
      status: BookingStatus.values.firstWhere((e) => e.name == data['status']),
      userId: data['userId'] ?? '',
    );
  }).toList();
}

Future<void> saveBooking(Booking booking) async {
  await FirebaseFirestore.instance.collection('bookings').doc(booking.id).set({
    'startDate': booking.startDate.millisecondsSinceEpoch,
    'endDate': booking.endDate.millisecondsSinceEpoch,
    'service': booking.service.name,
    'petName': booking.petName,
    'status': booking.status.name,
    'userId': booking.userId,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Booking> upcomingBookings = [];
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
      await saveBooking(newBooking);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBlockedDates();
    _loadUpcomingBookings();
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

  Future<void> _loadUpcomingBookings() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isAdmin = auth.user?.uid == 'KFj4YEr9J9WFUGW2hFHSp8Zta063';
    final loaded = await loadUpcomingBookings(auth.user?.uid ?? '', isAdmin: isAdmin);
    setState(() {
      upcomingBookings = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
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
                FutureBuilder<Map<String, dynamic>?>(
                  future: auth.user != null
                      ? auth.fetchUserProfile(auth.user!.uid)
                      : Future.value(null),
                  builder: (context, snapshot) {
                    final userName = snapshot.data?['displayName'] ?? auth.user?.displayName ?? '';
                    return Text(
                      '${AppLocalizations.of(context, 'greeting')}, $userName!',
                      style: Theme.of(context).textTheme.titleMedium,
                    );
                  },
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