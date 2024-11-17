import 'package:flutter/material.dart';
import 'dart:async';

class CalibrationProcessScreen extends StatefulWidget {
  const CalibrationProcessScreen({super.key});

  @override
  _CalibrationProcessScreenState createState() =>
      _CalibrationProcessScreenState();
}

class _CalibrationProcessScreenState extends State<CalibrationProcessScreen> {
  bool isCalibrationComplete = false;

  @override
  void initState() {
    super.initState();
    // Simulate calibration process
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isCalibrationComplete = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calibrating Subject',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0, // Removes shadow
        backgroundColor: Colors.white, // Matches the background color
        foregroundColor: Colors.black, // Sets the text/icon color
      ),
      backgroundColor: const Color(0xFFF8F9FB), // Light background color
      body: Center(
        child: isCalibrationComplete
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Calibration\nComplete',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      // Handle navigation or further action
                      print('Calibration process complete');
                      Navigator.pop(context); // Navigate back
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            : const Text(
                'Calibrating\nSubject...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }
}
