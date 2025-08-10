import 'package:flutter/material.dart';
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
  late List<DateTime> dates;

  @override
  void initState() {
    super.initState();
    dates = List.from(widget.blockedDates);
  }

  void _addDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (date) {
        // Prevent picking dates that are already blocked
        return !dates.any((d) =>
          d.year == date.year &&
          d.month == date.month &&
          d.day == date.day
        );
      },
    );
    if (picked != null) {
      setState(() {
        dates.add(picked);
        dates.sort();
      });
      widget.onChanged(List.from(dates));
    }
  }

  void _removeDate(DateTime date) {
    setState(() {
      dates.removeWhere((d) => d.year == date.year && d.month == date.month && d.day == date.day);
    });
    widget.onChanged(List.from(dates));
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
              Navigator.pop(context, dates); // <-- Return dates on pop
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _addDate,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context, 'add_blocked_date')),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: dates.isEmpty
                  ? Text(AppLocalizations.of(context, 'no_blocked_dates'))
                  : ListView.builder(
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        final date = dates[index];
                        return ListTile(
                          title: Text('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeDate(date),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}