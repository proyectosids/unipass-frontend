import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeekDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _WeekDatePickerState createState() => _WeekDatePickerState();
}

class _WeekDatePickerState extends State<WeekDatePicker> {
  late DateTime _startOfWeek;

  @override
  void initState() {
    super.initState();
    _startOfWeek = _calculateStartOfWeek(widget.selectedDate);
  }

  DateTime _calculateStartOfWeek(DateTime date) {
    int daysToSubtract = date.weekday - 1; // Lunes es el primer día (1)
    return date.subtract(Duration(days: daysToSubtract));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        DateTime day = _startOfWeek.add(Duration(days: index));
        bool isSelected = day.isAtSameMomentAs(widget.selectedDate);

        return GestureDetector(
          onTap: () {
            widget.onDateSelected(day);
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple : Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat.E('es').format(day), // Día de la semana
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.d().format(day), // Día del mes
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
