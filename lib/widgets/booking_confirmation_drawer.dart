import 'package:flutter/material.dart';
import '../models/service_type.dart';
import '../localization/app_localizations.dart';

class BookingConfirmationDrawer extends StatelessWidget {
  final ServiceType? selectedService;
  final List<Map<String, dynamic>> pets; // <-- Add this field
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const BookingConfirmationDrawer({
    super.key,
    required this.selectedService,
    required this.pets, // <-- Add this parameter
    required this.startDate,
    required this.endDate,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context, 'confirm_details'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('${AppLocalizations.of(context, 'service')}: ${selectedService?.localizedName(context) ?? ''}'),
            Text('${AppLocalizations.of(context, 'period')}: ${AppLocalizations.of(context, 'from')} ${startDate?.toLocal().toString().split(' ')[0] ?? ''} ${AppLocalizations.of(context, 'to')} ${endDate?.toLocal().toString().split(' ')[0] ?? ''}'),
            Text('${AppLocalizations.of(context, 'pets')}:'),
            ...pets.map((pet) => ListTile(
              leading: pet['photoUrl'] != null
                  ? CircleAvatar(backgroundImage: NetworkImage(pet['photoUrl']))
                  : const CircleAvatar(child: Icon(Icons.pets)),
              title: Text(pet['name'] ?? ''),
              subtitle: Text('${pet['type'] ?? ''} • ${pet['birthDate'] ?? ''}'),
            )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onConfirm,
              child: Text(AppLocalizations.of(context, 'confirm_booking')),
            ),
            TextButton(
              onPressed: onCancel,
              child: Text(AppLocalizations.of(context, 'cancel')),
            ),
          ],
        ),
      ),
    );
  }
}