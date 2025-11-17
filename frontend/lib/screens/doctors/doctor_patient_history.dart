import 'package:flutter/material.dart';

class PatientHistory extends StatelessWidget {
  const PatientHistory({Key? key}) : super(key: key);

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Icon(icon),
          label: Text(label),
          onPressed: onPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildActionButton(
                  'Prescription',
                  Icons.receipt_long,
                  () {
                    // TODO: Handle prescription button press
                  },
                ),
                _buildActionButton(
                  'Test Reports',
                  Icons.assignment,
                  () {
                    // TODO: Handle test reports button press
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildActionButton(
                  'Advice',
                  Icons.info_outline,
                  () {
                    // TODO: Handle advice button press
                  },
                ),
                _buildActionButton(
                  'Diagnosis',
                  Icons.medical_services,
                  () {
                    // TODO: Handle diagnosis button press
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Add more content below as needed
          ],
        ),
      ),
    );
  }
}