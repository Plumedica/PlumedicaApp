import 'package:flutter/material.dart';
import 'package:frontend/screens/doctors/doctor_patient_history.dart'; // Import the PatientHistory page

class DoctorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Profile
              },
              child: Text('Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Appointments Pending
              },
              child: Text('Appointments Pending'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Appointments Covered
              },
              child: Text('Appointments Covered'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Prescription
              },
              child: Text('Prescription'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Payments Received
              },
              child: Text('Payments Received'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Patient History
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientHistory(),
                  ),
                );
              },
              child: Text('Patient History'),
            ),
          ],
        ),
      ),
    );
  }
}
