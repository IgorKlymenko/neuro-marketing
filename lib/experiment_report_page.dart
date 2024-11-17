import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:nathacks_app/adding_subjects_screen.dart';

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
            _buildGraphPlaceholder(),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportScreen(),
                  ),
                );
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

  Widget _buildStatisticCard(
      {required String title, required String value, required IconData icon}) {
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
        child: Text(
          '(Graph Placeholder)',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiment Report'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Summary Statistics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatisticRow(title: 'Total Samples', value: '2'),
            _buildStatisticRow(title: 'Sub-Experiments Conducted', value: '2'),
            const SizedBox(height: 32),
            const Text(
              'Visualizations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBarChart(),
            const SizedBox(height: 32),
            _buildPieChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticRow({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final data = [
      _ChartData('Experiment 1', 50),
      _ChartData('Experiment 2', 30),
    ];

    final series = [
      charts.Series<_ChartData, String>(
        id: 'Experiments',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (data, _) => data.label,
        measureFn: (data, _) => data.value,
        data: data,
      ),
    ];

    return SizedBox(
      height: 200,
      child: charts.BarChart(series, animate: true),
    );
  }

  Widget _buildPieChart() {
    final data = [
      _ChartData('Success', 70),
      _ChartData('Failure', 30),
    ];

    final series = [
      charts.Series<_ChartData, String>(
        id: 'Outcomes',
        colorFn: (_, idx) =>
            idx == 0 ? charts.MaterialPalette.green.shadeDefault : charts.MaterialPalette.red.shadeDefault,
        domainFn: (data, _) => data.label,
        measureFn: (data, _) => data.value,
        data: data,
      ),
    ];

    return SizedBox(
      height: 200,
      child: charts.PieChart(series, animate: true),
    );
  }
}

class _ChartData {
  final String label;
  final int value;

  _ChartData(this.label, this.value);
}
