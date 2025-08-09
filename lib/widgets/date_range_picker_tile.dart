import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class DateRangePickerTile extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onTap;

  const DateRangePickerTile({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        startDate == null || endDate == null
          ? AppLocalizations.of(context, 'choose_period')
          : '${AppLocalizations.of(context, 'period')}: ${AppLocalizations.of(context, 'from')} ${startDate!.toLocal().toString().split(' ')[0]} ${AppLocalizations.of(context, 'to')} ${endDate!.toLocal().toString().split(' ')[0]}'
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: onTap,
    );
  }
}