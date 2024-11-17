import 'package:flutter/material.dart';
import 'adding_subjects_screen.dart'; // Import the second file

class SubExperimentDetailsPage extends StatefulWidget {
  const SubExperimentDetailsPage({super.key});

  @override
  _SubExperimentDetailsPageState createState() =>
      _SubExperimentDetailsPageState();
}

class _SubExperimentDetailsPageState extends State<SubExperimentDetailsPage> {
  bool isDescriptionSwitchOn = false;
  bool isMediaSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sub-Experiment Details'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF4F7FE), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Brief description of the experiment',
              switchValue: isDescriptionSwitchOn,
              onSwitchChanged: (value) {
                setState(() {
                  isDescriptionSwitchOn = value;
                });
              },
              child: TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Upload the media',
              switchValue: isMediaSwitchOn,
              onSwitchChanged: (value) {
                setState(() {
                  isMediaSwitchOn = value;
                });
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.upload_file, color: Colors.grey, size: 48),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                // Navigate to AddingSubjectsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddingSubjectsScreen()),
                );
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: switchValue,
              onChanged: onSwitchChanged,
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
