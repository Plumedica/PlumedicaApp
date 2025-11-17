import 'package:flutter/material.dart';

class HospitalDashboard extends StatelessWidget {
  const HospitalDashboard({Key? key}) : super(key: key);

  void _navigate(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.local_hospital),
                ),
                title: const Text('Hospital Profile'),
                subtitle: const Text('View and edit hospital profile'),
                onTap: () => _navigate(context, '/hospitalProfile'),
              ),
            ),
            const SizedBox(height: 24),
            // Dashboard Options
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text('Payment History'),
                    onTap: () => _navigate(context, '/paymentHistory'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Patient Details'),
                    onTap: () => _navigate(context, '/patientDetails'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: const Text('Emergency Services'),
                    onTap: () => _navigate(context, '/emergencyServices'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.assignment),
                    title: const Text('Admissions'),
                    onTap: () => _navigate(context, '/admissions'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: const Text('Job Postings'),
                    onTap: () => _navigate(context, '/jobPostings'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}