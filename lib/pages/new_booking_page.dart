import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_type.dart';
import '../models/price_config.dart';
import '../models/booking.dart';
import '../localization/app_localizations.dart';
import '../widgets/service_selection.dart';
import '../widgets/date_range_picker_tile.dart';
import '../widgets/confirm_booking_button.dart';
import '../widgets/booking_confirmation_drawer.dart';
import '../providers/auth_provider.dart';

class NewBookingPage extends StatefulWidget {
  final PriceConfig priceConfig;
  final List<DateTime> blockedDates;
  const NewBookingPage({super.key, required this.priceConfig, required this.blockedDates});

  @override
  State<NewBookingPage> createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ServiceType? selectedService;
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController petNameController = TextEditingController();
  List<Map<String, dynamic>> userPets = [];
  List<String> selectedPetUuids = []; // <-- Store selected pet UUIDs

  @override
  void initState() {
    super.initState();
    _loadUserPets();
  }

  Future<void> _loadUserPets() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.user?.uid;
    if (userId == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      userPets = List<Map<String, dynamic>>.from(doc.data()?['animals'] ?? []);
    });
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
      builder: (context, child) {
        return child!;
      },
      selectableDayPredicate: (date, start, end) {
        if (widget.blockedDates.any((blocked) =>
            blocked.year == date.year &&
            blocked.month == date.month &&
            blocked.day == date.day)) {
          return false;
        }

        if (start != null && end == null) {
          for (var d = start;
              !d.isAfter(date);
              d = d.add(const Duration(days: 1))) {
            if (widget.blockedDates.any((blocked) =>
                blocked.year == d.year &&
                blocked.month == d.month &&
                blocked.day == d.day)) {
              return false;
            }
          }
        }

        return true;
      },
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  void _submitBooking() {
    if (selectedService == null || startDate == null || endDate == null || selectedPetUuids.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context, 'fill_all_fields'))),
      );
      return;
    }
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context, 'title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            ServiceSelection(
              selectedService: selectedService,
              onChanged: (val) => setState(() => selectedService = val),
              priceConfig: widget.priceConfig,
              startDate: startDate,
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context, 'select_pets'), style: Theme.of(context).textTheme.titleMedium),
                ...userPets.map((pet) {
                  final uuid = pet['uuid'] as String;
                  final isSelected = selectedPetUuids.contains(uuid);
                  return ListTile(
                    leading: pet['photoUrl'] != null
                        ? CircleAvatar(backgroundImage: NetworkImage(pet['photoUrl']))
                        : const CircleAvatar(child: Icon(Icons.pets)),
                    title: Text(pet['name'] ?? ''),
                    subtitle: Text('${pet['type'] ?? ''} • ${pet['birthDate'] ?? ''}'),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedPetUuids.add(uuid);
                          } else {
                            selectedPetUuids.remove(uuid);
                          }
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
            DateRangePickerTile(
              startDate: startDate,
              endDate: endDate,
              onTap: _pickDateRange,
            ),
            const SizedBox(height: 24),
            ConfirmBookingButton(onPressed: _submitBooking),
          ],
        ),
      ),
      endDrawer: BookingConfirmationDrawer(
        selectedService: selectedService,
        pets: userPets.where((pet) => selectedPetUuids.contains(pet['uuid'])).toList(), // Pass selected pets
        startDate: startDate,
        endDate: endDate,
        onConfirm: () {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          final booking = Booking(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            startDate: startDate!,
            endDate: endDate!,
            service: selectedService!,
            pets: selectedPetUuids
              .map((uuid) => PetRef(uuid: uuid))
              .toList(), // Store as PetRef list
            status: BookingStatus.pendingConfirmation,
            userId: auth.user?.uid ?? '',
          );
          Navigator.pop(context); // Close the drawer
          Navigator.pop(context, booking); // Return booking to previous page
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}