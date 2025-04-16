import 'package:flutter/material.dart';

class CognicareHomeScreen extends StatelessWidget {
  const CognicareHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF0FA), // Light blue background
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ Top Navigation Bar using Wrap to avoid overflow
                    Wrap(
                      spacing: 16,
                      runSpacing: 10,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        _navItem(context, "Home"),
                        _navItem(context, "About"),
                        _navItem(context, "Contact"),
                        _navItem(context, "Profile"),
                        _navItem(context, "Login"),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ✅ Logo & Tagline
                    Column(
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported, size: 80);
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "COGNICARE",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          "REVIVE, REMEMBER, REFRAME.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal.shade700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // ✅ Feature Cards
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _featureCard(context, "Story Telling", "assets/storytelling.png"),
                        _featureCard(context, "Therapy", "assets/therapy.png"),
                        _featureCard(context, "Memory Games", "assets/memory_games.png"),
                        _featureCard(context, "Reports", "assets/reports.png"),
                      ],
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),

            // ✅ Reminder Icon
            Positioned(
              top: 40,
              right: 24,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reminder clicked')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.access_time, size: 40, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text("Reminder", style: TextStyle(fontSize: 14)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🔹 Navigation Item Widget
  Widget _navItem(BuildContext context, String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label clicked!')),
        );
        // Navigator.push(...) if needed
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // 🔹 Feature Card Widget
  Widget _featureCard(BuildContext context, String title, String imagePath) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title tapped')),
        );
        // Navigator.push(...) to respective feature
      },
      child: Container(
        width: 160,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Image.asset(imagePath, width: 36, height: 36, fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}
