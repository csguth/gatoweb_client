import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/booking.dart';
import 'booking_day_details_sheet.dart';

class UpcomingBookingsCalendar extends StatefulWidget {
  final List<Booking> bookings;
  final void Function(Booking)? onTap;
  final VoidCallback? onStatusChanged;

  const UpcomingBookingsCalendar({
    super.key,
    required this.bookings,
    this.onTap,
    this.onStatusChanged,
  });

  static const busyDayColor = Colors.redAccent;

  @override
  State<UpcomingBookingsCalendar> createState() =>
      _UpcomingBookingsCalendarState();
}

class _UpcomingBookingsCalendarState extends State<UpcomingBookingsCalendar> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // Filter out cancelled bookings
    final visibleBookings = widget.bookings
        .where((b) => b.status != BookingStatus.cancelled)
        .toList();

    final events = <DateTime, List<Booking>>{};
    for (final booking in visibleBookings) {
      DateTime date = DateTime(booking.startDate.year, booking.startDate.month,
          booking.startDate.day);
      final endDate = DateTime(
          booking.endDate.year, booking.endDate.month, booking.endDate.day);
      while (!date.isAfter(endDate)) {
        events.putIfAbsent(date, () => []).add(booking);
        date = date.add(const Duration(days: 1));
      }
    }

    return Expanded(
      child: TableCalendar<Booking>(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) =>
            _selectedDay != null &&
            day.year == _selectedDay!.year &&
            day.month == _selectedDay!.month &&
            day.day == _selectedDay!.day,
        eventLoader: (day) {
          final normalized = DateTime(day.year, day.month, day.day);
          return events[normalized] ?? [];
        },
        calendarFormat: CalendarFormat.month,
        calendarBuilders: CalendarBuilders<Booking>(
          rangeHighlightBuilder: (context, day, isWithinRange) {
            final normalized = DateTime(day.year, day.month, day.day);
            final dayBookings = visibleBookings.where((booking) {
              final start = DateTime(booking.startDate.year,
                  booking.startDate.month, booking.startDate.day);
              final end = DateTime(booking.endDate.year, booking.endDate.month,
                  booking.endDate.day);
              return !normalized.isBefore(start) && !normalized.isAfter(end);
            }).toList();
            if (dayBookings.isEmpty) return null;
            return Container(
              decoration: BoxDecoration(
                color: UpcomingBookingsCalendar.busyDayColor.withAlpha(80),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          final normalized =
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
          final dayBookings = events[normalized] ?? [];
          if (dayBookings.isNotEmpty) {
            showModalBottomSheet(
              context: context,
              builder: (context) => BookingDayDetailsSheet(
                bookings: dayBookings,
                onStatusChanged: widget.onStatusChanged,
                onTap: widget.onTap,
              ),
            ).then((_) {
              setState(() {
                _selectedDay = null;
              });
            });
          }
        },
      ),
    );
  }
}
