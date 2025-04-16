import 'package:flutter/material.dart';
import 'screens/memory_games_screen.dart';
import 'screens/storytelling_screen.dart';
import 'screens/trauma_therapy_screen.dart';
import 'screens/memory_reframing_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/calendar_reminder.dart';
import 'screens/patient_profile_screen.dart';
import 'screens/home_screen.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

// -------------------- Firebase Disabled Temporarily --------------------
// import 'package:firebase_core/firebase_core.dart';
// await Firebase.initializeApp();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚫 Firebase initialization disabled temporarily
  // await Firebase.initializeApp();

  // ✅ Local Notifications Initialization
  await _initializeNotifications();

  runApp(CognicareApp());
}

Future<void> _initializeNotifications() async {
  tz.initializeTimeZones();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class CognicareApp extends StatefulWidget {
  @override
  _CognicareAppState createState() => _CognicareAppState();
}

class _CognicareAppState extends State<CognicareApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CognicareHomeScreen(),
    MemoryGamesScreen(),
    StorytellingScreen(),
    TraumaTherapyScreen(),
    RemindersScreen(),
    ReportsScreen(),
    PatientProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cognicare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Cognicare"),
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CalendarReminderScreen()),
                );
              },
            ),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Games"),
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_album), label: "Stories"),
            BottomNavigationBarItem(
                icon: Icon(Icons.healing), label: "Therapy"),
            BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Reminders"),
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics), label: "Reports"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Patients"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// -------------------- Trauma Therapy Screen --------------------
class TraumaTherapyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trauma Therapy 🧠✨')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a Therapy Method:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildTherapyCard(Icons.brush, 'Memory Reframing 🎨', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MemoryReframingScreen()),
                    );
                  }),
                  _buildTherapyCard(Icons.auto_stories, 'Story Weaving 📖', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoryWeavingScreen()),
                    );
                  }),
                  _buildTherapyCard(Icons.lock, 'Memory Vault 🔒', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MemoryVaultScreen()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTherapyCard(IconData icon, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- Placeholder Screens --------------------
class StoryWeavingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Story Weaving 📖')),
      body: Center(
        child: Text('Coming Soon: Story Weaving'),
      ),
    );
  }
}

class MemoryVaultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Memory Vault 🔒')),
      body: Center(
        child: Text('Coming Soon: Emotion-Based Memory Vault'),
      ),
    );
  }
}

