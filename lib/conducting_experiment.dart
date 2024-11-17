import 'package:flutter/material.dart';
import 'sub_experiment_details.dart'; // Import the Sub-Experiment Details Page
import 'adding_subjects_screen.dart'; // Import the Adding Subjects Screen

class ConductingExperimentPage extends StatelessWidget {
  const ConductingExperimentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conducting Experiment'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF4F7FE), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Sample Button (Green Plus Button)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // Navigate to AddingSubjectsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddingSubjectsScreen(),
                      ),
                    );
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Statistics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatisticCard(
                  title: 'Sample Size',
                  value: '2',
                  icon: Icons.bar_chart_rounded,
                ),
                _buildStatisticCard(
                  title: 'Sub-Experiments',
                  value: '2',
                  icon: Icons.bar_chart_rounded,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Placeholder for Graph Section
            _buildGraphPlaceholder(),
            const SizedBox(height: 24),
            // Buttons Section
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Navigate to Sub-Experiment Details Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubExperimentDetailsPage(),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  'Add Sub-Experiment',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                debugPrint('Generate Report Button Pressed');
              },
              child: const Center(
                child: Text(
                  'Generate Report',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard({required String title, required String value, required IconData icon}) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGraphPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$26.4K Total Spent',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'On track',
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(height: 16),
            Text(
              '(Graph Placeholder)',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
