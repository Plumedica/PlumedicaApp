import 'package:flutter/material.dart';
import 'package:frontend/screens/jobs/jobs_existing_client.dart'; // Create this page
import 'package:frontend/screens/jobs/jobs_new_clinet.dart'; // Create this page
import 'package:frontend/screens/jobs/jobs_seeker_register.dart'; // Create this page

class JobsHome extends StatefulWidget {
  const JobsHome({Key? key}) : super(key: key);

  @override
  State<JobsHome> createState() => _JobsHomeState();
}

class _JobsHomeState extends State<JobsHome> {
  bool isExistingClient = false;
  bool isNewClient = false;

  void _onSubmit() {
    if (isExistingClient) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExistingClientPage()),
      );
    } else if (isNewClient) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  NewClientPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a client type')),
      );
    }
  }

  void _onJobSeekerRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobSeekerRegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Looking for Employee?'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            CheckboxListTile(
              title: const Text('Existing Client'),
              value: isExistingClient,
              onChanged: (val) {
                setState(() {
                  isExistingClient = val ?? false;
                  if (isExistingClient) isNewClient = false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('New Client'),
              value: isNewClient,
              onChanged: (val) {
                setState(() {
                  isNewClient = val ?? false;
                  if (isNewClient) isExistingClient = false;
                });
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('Submit'),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _onJobSeekerRegister,
                child: const Text('Job Seeker Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}