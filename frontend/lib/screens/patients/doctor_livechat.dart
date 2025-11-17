import 'package:flutter/material.dart';

class DoctorLiveChatScreen extends StatefulWidget {
  @override
  DoctorLiveChatScreenState createState() => DoctorLiveChatScreenState();
}

class DoctorLiveChatScreenState extends State<DoctorLiveChatScreen> {
  final Map<String, bool> _services = {
    'General health problems': false,
    'Tooth & oral/plantal problem': false,
    'Pregnancy related issues': false,
    'Child health problem': false,
    'Mental health issues': false,
    'Ear, nose, throat problem': false,
    'Surgeries needed': false,
    'Sugar specialist needed': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What happened?'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Global Services For:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ..._services.keys.map((service) {
              return CheckboxListTile(
                title: Text(service),
                value: _services[service],
                onChanged: (bool? value) {
                  setState(() {
                    _services[service] = value ?? false;
                  });
                },
              );
            }).toList(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle selected services
                final selected = _services.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList();
                // For now, just show a dialog with selected services
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Selected Services'),
                    content: Text(selected.isEmpty
                        ? 'No services selected.'
                        : selected.join('\n')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}