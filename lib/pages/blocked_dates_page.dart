import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../localization/app_localizations.dart';

class BlockedDatesPage extends StatefulWidget {
  final List<DateTime> blockedDates;
  final ValueChanged<List<DateTime>> onChanged;

  const BlockedDatesPage({
    super.key,
    required this.blockedDates,
    required this.onChanged,
  });

  @override
  State<BlockedDatesPage> createState() => _BlockedDatesPageState();
}

class _BlockedDatesPageState extends State<BlockedDatesPage> {
  late Set<DateTime> blocked;

  @override
  void initState() {
    super.initState();
    blocked = widget.blockedDates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
  }

  void _toggleDate(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    setState(() {
      if (blocked.contains(normalized)) {
        blocked.remove(normalized);
      } else {
        blocked.add(normalized);
      }
    });
    widget.onChanged(blocked.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context, 'blocked_dates')),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context, blocked.toList());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) => blocked.contains(DateTime(day.year, day.month, day.day)),
          calendarFormat: CalendarFormat.month,
          onDaySelected: (selectedDay, focusedDay) {
            _toggleDate(selectedDay);
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final normalized = DateTime(day.year, day.month, day.day);
              final isBlocked = blocked.contains(normalized);
              return GestureDetector(
                onTap: () => _toggleDate(day),
                child: Container(
                  decoration: BoxDecoration(
                    color: isBlocked ? Colors.redAccent.withAlpha(127) : null,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isBlocked ? Colors.white : null,
                      fontWeight: isBlocked ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}