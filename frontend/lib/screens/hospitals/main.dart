import 'package:flutter/material.dart';
import 'package:frontend/screens/hospitals/hospital_dashboard.dart';

class Hospitalmain extends StatelessWidget {
  const Hospitalmain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitals'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/whatYouWantToKnow');
              },
              child: const Text('What you want to know'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, './hospital_dashboard.dart');
              },
              child: const Text('What you want to do'),
            ),
          ],
        ),
      ),
    );
  }
}