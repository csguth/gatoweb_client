import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class ConfirmBookingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmBookingButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(AppLocalizations.of(context, 'confirm_booking')),
    );
  }
}