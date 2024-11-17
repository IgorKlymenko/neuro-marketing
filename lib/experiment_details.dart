import 'package:flutter/material.dart';
import 'package:nathacks_app/conducting_experiment.dart';

class ExperimentDetailsScreen extends StatefulWidget {
  const ExperimentDetailsScreen({super.key});

  @override
  _ExperimentDetailsScreenState createState() =>
      _ExperimentDetailsScreenState();
}

class _ExperimentDetailsScreenState extends State<ExperimentDetailsScreen> {
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController experimentNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();

  bool isDemographicsEnabled = false;

  // Dropdown experiment type
  String? selectedExperimentType;

  final List<String> experimentTypes = [
    'Video',
    'Audio',
    'Visual Data (Poster etc.)',
    'Text Data',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiment Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Name
              TextField(
                controller: clientNameController,
                decoration: const InputDecoration(
                  labelText: 'Client Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Experiment Name
              TextField(
                controller: experimentNameController,
                decoration: const InputDecoration(
                  labelText: 'Experiment Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Experiment Types
              const Text(
                'Select the type of the Experiment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Experiment Type',
                ),
                value: selectedExperimentType,
                items: experimentTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedExperimentType = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Audience Demographics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Preset audience demographics?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: isDemographicsEnabled,
                    onChanged: (value) {
                      setState(() {
                        isDemographicsEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              if (isDemographicsEnabled) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: genderController,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ethnicityController,
                  decoration: const InputDecoration(
                    labelText: 'Ethnicity',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Continue Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Placeholder for action on continue
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => const ConductingExperimentPage()));
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
