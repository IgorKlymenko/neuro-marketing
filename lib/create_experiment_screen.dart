import 'package:flutter/material.dart';
import 'package:nathacks_app/experiment_details.dart';
import 'conducting_experiment.dart'; // Import the ExperimentScreen file

class CreateExperimentScreen extends StatefulWidget {
  const CreateExperimentScreen({super.key});

  @override
  _CreateExperimentScreenState createState() => _CreateExperimentScreenState();
}

class _CreateExperimentScreenState extends State<CreateExperimentScreen> {
  // Text controllers for text fields
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController experimentNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();

  // State variables for checkboxes
  bool isVideoSelected = false;
  bool isAudioSelected = false;
  bool isVisualDataSelected = false;
  bool isTextDataSelected = false;
  bool isOtherSelected = false;

  // State variable for demographics toggle
  bool isDemographicsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Name Field
              TextField(
                controller: clientNameController,
                decoration: const InputDecoration(
                  labelText: 'Client Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Experiment Name Field
              TextField(
                controller: experimentNameController,
                decoration: const InputDecoration(
                  labelText: 'Experiment Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Experiment Type
              const Text(
                'Select the type of the Experiment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Enable Types'),
                value: true,
                onChanged: (value) => {},
              ),
              CheckboxListTile(
                title: const Text('Video'),
                value: isVideoSelected,
                onChanged: (bool? value) {
                  setState(() {
                    isVideoSelected = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Audio'),
                value: isAudioSelected,
                onChanged: (bool? value) {
                  setState(() {
                    isAudioSelected = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Visual Data (Poster etc.)'),
                value: isVisualDataSelected,
                onChanged: (bool? value) {
                  setState(() {
                    isVisualDataSelected = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Text Data'),
                value: isTextDataSelected,
                onChanged: (bool? value) {
                  setState(() {
                    isTextDataSelected = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Other'),
                value: isOtherSelected,
                onChanged: (bool? value) {
                  setState(() {
                    isOtherSelected = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Preset Audience Demographics
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
                    // Handle navigation to ExperimentScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExperimentDetailsScreen(),
                      ),
                    );
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
