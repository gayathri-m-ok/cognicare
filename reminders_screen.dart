import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, List<Map<String, dynamic>>> _events = {};
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize time zones
    _selectedDay = _focusedDay;
    _loadReminders();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEvents = prefs.getString('events');
    if (savedEvents != null) {
      setState(() {
        _events = Map<String, List<Map<String, dynamic>>>.from(
            json.decode(savedEvents));
      });
    }
  }

  void _saveReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('events', json.encode(_events));
  }

  void _scheduleNotification(String title, DateTime scheduledTime) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Use a static ID for now
      "Reminder",
      title,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    TextEditingController _reminderController = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Reminder"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _reminderController,
              decoration: InputDecoration(hintText: "Enter reminder"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    selectedTime = time;
                  });
                }
              },
              child: Text("Select Time"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_reminderController.text.isNotEmpty && selectedTime != null) {
                setState(() {
                  String selectedKey = _selectedDay!.toIso8601String();
                  if (!_events.containsKey(selectedKey)) {
                    _events[selectedKey] = [];
                  }
                  DateTime scheduledTime = DateTime(
                    _selectedDay!.year,
                    _selectedDay!.month,
                    _selectedDay!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  _events[selectedKey]!.add({
                    'title': _reminderController.text,
                    'time': scheduledTime.toIso8601String(),
                  });
                  _scheduleNotification(_reminderController.text, scheduledTime);
                  _saveReminders();
                });
                Navigator.pop(context);
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteReminder(String dateKey, int index) {
    setState(() {
      _events[dateKey]?.removeAt(index);
      if (_events[dateKey]!.isEmpty) {
        _events.remove(dateKey);
      }
      _saveReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    String selectedKey = _selectedDay!.toIso8601String();
    List<Map<String, dynamic>> selectedDayReminders =
        _events[selectedKey] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text("Reminders")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          ElevatedButton(
            onPressed: () => _showAddReminderDialog(context),
            child: Text("Add Reminder"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedDayReminders.length,
              itemBuilder: (context, index) {
                final reminder = selectedDayReminders[index];
                return ListTile(
                  title: Text(reminder['title']),
                  subtitle: Text(
                      "Time: ${DateTime.parse(reminder['time']).hour}:${DateTime.parse(reminder['time']).minute}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteReminder(selectedKey, index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
