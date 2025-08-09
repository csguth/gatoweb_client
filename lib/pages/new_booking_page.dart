import 'package:flutter/material.dart';
import '../models/service_type.dart';
import '../models/price_config.dart';
import '../models/booking.dart';
import '../utils/season_utils.dart';
import '../localization/app_localizations.dart';

class NewBookingPage extends StatefulWidget {
  final PriceConfig priceConfig;
  final List<DateTime> blockedDates;
  const NewBookingPage({super.key, required this.priceConfig, required this.blockedDates});

  @override
  State<NewBookingPage> createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
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
      // selectableDayPredicate: (date) {
      //   return !widget.blockedDates.any((blocked) =>
      //     blocked.year == date.year &&
      //     blocked.month == date.month &&
      //     blocked.day == date.day
      //   );
      // },
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
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startDate: startDate!,
      endDate: endDate!,
      service: selectedService!,
      petName: petNameController.text,
      status: 'In afwachting', // You may want to localize status as well
    );
    Navigator.pop(context, booking);
  }

  @override
  Widget build(BuildContext context) {
    const services = ServiceType.values;
    final isSeasonal = startDate != null && isSummer(startDate!);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context, 'title'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context, 'choose_service'), style: const TextStyle(fontWeight: FontWeight.bold)),
            ...services.map((service) {
              final price = widget.priceConfig.prices[service]!;
              String priceText;
              if (service == ServiceType.hondenUitlaatservice) {
                priceText = '${AppLocalizations.of(context, 'starting_from')} € ${price.getPrice(isSeasonal).toStringAsFixed(0)} '
                  '/${AppLocalizations.of(context, 'walk')}, '
                  '€ ${price.getPrice(isSeasonal, extraPet: true).toStringAsFixed(0)} '
                  '/${AppLocalizations.of(context, 'extra_pet')}';
              } else {
                priceText = '${AppLocalizations.of(context, 'starting_from')} € ${price.getPrice(isSeasonal).toStringAsFixed(0)} '
                  '/${AppLocalizations.of(context, 'day')}';
              }
              return Card(
                child: RadioListTile<ServiceType>(
                  value: service,
                  groupValue: selectedService,
                  onChanged: (val) => setState(() => selectedService = val),
                  title: Text(service.localizedName(context)),
                  subtitle: Text(priceText, style: const TextStyle(color: Colors.green)),
                ),
              );
            }),
            const SizedBox(height: 16),
            TextField(
              controller: petNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context, 'pet_name'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                startDate == null || endDate == null
                  ? AppLocalizations.of(context, 'choose_period')
                  : '${AppLocalizations.of(context, 'period')}: ${AppLocalizations.of(context, 'from')} ${startDate!.toLocal().toString().split(' ')[0]} ${AppLocalizations.of(context, 'to')} ${endDate!.toLocal().toString().split(' ')[0]}'
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDateRange,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitBooking,
              child: Text(AppLocalizations.of(context, 'confirm_booking')),
            ),
          ],
        ),
      ),
    );
  }
}