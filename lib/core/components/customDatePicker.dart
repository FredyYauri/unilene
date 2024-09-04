import 'package:flutter/material.dart';

class DayMonthPicker extends StatefulWidget {
  final Function(int? day, int? month) onDateChanged;
  final DateTime? initialDate;
  const DayMonthPicker({
    super.key,
    required this.onDateChanged,
    this.initialDate,
  });

  @override
  _DayMonthPickerState createState() => _DayMonthPickerState();
}

class _DayMonthPickerState extends State<DayMonthPicker> {
  int? _selectedDay;
  int? _selectedMonth;

   @override
  void initState() {
    super.initState();
    if(widget.initialDate != null){
      _selectedDay = widget.initialDate!.day;
      _selectedMonth = widget.initialDate!.month;
    }    
  }


  final List<int> _days = List<int>.generate(31, (i) => i + 1);
  final List<int> _months = List<int>.generate(12, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Cumpleaños",
          style: TextStyle(
            fontFamily: 'Roboto',
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 4.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              DropdownButton<int>(
                hint: const Text("Día"),
                value: _selectedDay,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedDay = newValue;
                    widget.onDateChanged(_selectedDay, _selectedMonth);
                  });
                },
                items: _days.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              const SizedBox(width: 16.0),
              DropdownButton<int>(
                hint: const Text("Mes"),
                value: _selectedMonth,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedMonth = newValue;
                    widget.onDateChanged(_selectedDay, _selectedMonth);
                  });
                },
                items: _months.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
