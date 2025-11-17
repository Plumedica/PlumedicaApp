import 'package:flutter/material.dart';
import 'package:frontend/screens/patients/profile_settings.dart'; // Import your profile page
import 'package:frontend/screens/patients/doctor_livechat.dart'; // Import your doctor live chat page

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({Key? key}) : super(key: key);

  void _onModuleTap(BuildContext context, String module) {
    if (module == 'Profile Settings') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileSettings()),
      );
    } else if (module == 'Doctor Live Chat') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorLiveChatScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tapped on $module')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final modules = [
      {
        'title': 'Profile Settings',
        'icon': Icons.person,
      },
      {
        'title': 'Medical History',
        'icon': Icons.history,
      },
      {
        'title': 'Fitness',
        'icon': Icons.fitness_center,
      },
      {
        'title': 'Doctor Live Chat',
        'icon': Icons.chat,
      },
      {
        'title': 'Health Record',
        'icon': Icons.folder_shared,
      },
      {
        'title': 'Pharmacy',
        'icon': Icons.local_pharmacy,
      },
      {
        'title': 'Hospital/Clinic',
        'icon': Icons.local_hospital,
      },
      {
        'title': 'Emergency Services',
        'icon': Icons.emergency,
      },
      {
        'title': 'Home Care / Home Visit',
        'icon': Icons.home,
      },
      {
        'title': 'AI Enable Remote Scanning',
        'icon': Icons.scanner,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: modules.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final module = modules[index];
            return GestureDetector(
              onTap: () => _onModuleTap(context, module['title'] as String),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      module['icon'] as IconData,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      module['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}