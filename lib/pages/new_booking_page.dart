import 'package:flutter/material.dart';
import '../models/service_type.dart';
import '../models/price_config.dart';
import '../models/booking.dart';
import '../localization/app_localizations.dart';
import '../widgets/service_selection.dart';
import '../widgets/pet_name_input.dart';
import '../widgets/date_range_picker_tile.dart';
import '../widgets/confirm_booking_button.dart';
import '../widgets/booking_confirmation_drawer.dart';

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
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  void _submitBooking() {
    if (selectedService == null || startDate == null || endDate == null || petNameController.text.isEmpty) {
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
            PetNameInput(controller: petNameController),
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
        petName: petNameController.text,
        startDate: startDate,
        endDate: endDate,
        onConfirm: () {
          final booking = Booking(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            startDate: startDate!,
            endDate: endDate!,
            service: selectedService!,
            petName: petNameController.text,
            status: BookingStatus.pendingConfirmation,
          );
          Navigator.pop(context); // Close the drawer
          Navigator.pop(context, booking); // Return booking to previous page
        },
        onCancel: () => Navigator.pop(context), // Close drawer without confirming
      ),
    );
  }
}