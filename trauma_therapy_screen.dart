import 'package:flutter/material.dart';

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
                    // Navigate to Memory Reframing Screen
                  }),
                  _buildTherapyCard(Icons.auto_stories, 'Story Weaving 📖', () {
                    // Navigate to Story Weaving Screen
                  }),
                  _buildTherapyCard(Icons.lock, 'Memory Vault 🔒', () {
                    // Navigate to Emotion-Based Memory Vault Screen
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
