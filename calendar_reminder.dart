import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarReminderScreen extends StatefulWidget {
  @override
  _CalendarReminderScreenState createState() => _CalendarReminderScreenState();
}

class _CalendarReminderScreenState extends State<CalendarReminderScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Store reminders
  Map<DateTime, List<Map<String, dynamic>>> reminders = {};

  TextEditingController _medicineNameController = TextEditingController();

  void _addMedicineReminder() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      String medicineName = _medicineNameController.text.trim();
      if (medicineName.isNotEmpty) {
        setState(() {
          reminders[_selectedDay] ??= [];
          reminders[_selectedDay]!.add({
            "type": "medicine",
            "time": selectedTime.format(context),
            "name": medicineName,
          });
        });

        _medicineNameController.clear();
      }
    }
  }

  void _addOccasionReminder() {
    TextEditingController occasionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Important Occasion"),
          content: TextField(
            controller: occasionController,
            decoration: InputDecoration(hintText: "Occasion Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String occasionName = occasionController.text.trim();
                if (occasionName.isNotEmpty) {
                  setState(() {
                    reminders[_selectedDay] ??= [];
                    reminders[_selectedDay]!.add({
                      "type": "occasion",
                      "name": occasionName,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reminders")),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          SizedBox(height: 10),

          // Buttons to Add Reminders
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _addMedicineReminder,
                child: Text("Add Medicine"),
              ),
              ElevatedButton(
                onPressed: _addOccasionReminder,
                child: Text("Add Occasion"),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Reminder List
          Expanded(
            child: ListView(
              children: (reminders[_selectedDay] ?? []).map((reminder) {
                return ListTile(
                  leading: Icon(reminder["type"] == "medicine"
                      ? Icons.medical_services
                      : Icons.event),
                  title: Text(reminder["name"]),
                  subtitle: reminder["type"] == "medicine"
                      ? Text("Time: ${reminder["time"]}")
                      : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
