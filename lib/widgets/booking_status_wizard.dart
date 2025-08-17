import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingStatusWizard extends StatelessWidget {
  final Booking booking;
  final Future<void> Function(BookingStatus newStatus) onStatusChange;

  const BookingStatusWizard({
    super.key,
    required this.booking,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isInRange = now.isAfter(booking.startDate) && now.isBefore(booking.endDate.add(const Duration(days: 1)));
    final isAfterEnd = now.isAfter(booking.endDate);

    List<Widget> actions = [];

    switch (booking.status) {
      case BookingStatus.pendingConfirmation:
        actions = [
          ElevatedButton(
            onPressed: () => onStatusChange(BookingStatus.confirmed),
            child: const Text('Confirm'),
          ),
          TextButton(
            onPressed: () => onStatusChange(BookingStatus.cancelled),
            child: const Text('Cancel'),
          ),
        ];
        break;
      case BookingStatus.confirmed:
        if (isInRange) {
          actions = [
            ElevatedButton(
              onPressed: () => onStatusChange(BookingStatus.ongoing),
              child: const Text('Mark as Ongoing'),
            ),
            TextButton(
              onPressed: () => onStatusChange(BookingStatus.cancelled),
              child: const Text('Cancel'),
            ),
          ];
        } else {
          actions = [
            TextButton(
              onPressed: () => onStatusChange(BookingStatus.cancelled),
              child: const Text('Cancel'),
            ),
          ];
        }
        break;
      case BookingStatus.ongoing:
        if (isInRange) {
          actions = [
            ElevatedButton(
              onPressed: () => onStatusChange(BookingStatus.awaitingPayment),
              child: const Text('End Booking'),
            ),
          ];
        }
        break;
      case BookingStatus.awaitingPayment:
        if (isAfterEnd) {
          actions = [
            ElevatedButton(
              onPressed: () => onStatusChange(BookingStatus.concluded),
              child: const Text('Mark as Concluded'),
            ),
          ];
        }
        break;
      default:
        actions = [];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current status: ${booking.status.name}', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...actions,
      ],
    );
  }
}