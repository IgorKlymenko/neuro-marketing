import 'package:flutter/material.dart';

class StartTestPage extends StatelessWidget {
  const StartTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF), // Light purple background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Testing Subject',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add functionality for starting the test here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A4B9A), // Purple button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: const Text(
            'Start Test',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
