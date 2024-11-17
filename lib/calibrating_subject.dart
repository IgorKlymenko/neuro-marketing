import 'package:flutter/material.dart';

class CalibratingSubjectScreen extends StatelessWidget {
  const CalibratingSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calibrating Subject'),
        centerTitle: true, // Centers the title in the app bar
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5, // 50% of screen width
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press here
                    print('Calibrate Subject button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Purple button background
                    foregroundColor: Colors.white, // White text color
                    padding: const EdgeInsets.symmetric(vertical: 16.0), // Button height
                  ),
                  child: const Text(
                    'Calibrate Subject',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // Add spacing at the bottom
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
              child: ElevatedButton(
                onPressed: () {
                  // Handle "Continue" button press here
                  print('Continue button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Black button background
                  foregroundColor: Colors.white, // White text color
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // Button height
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

