
import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_buttons.dart';
import 'package:frontend/screens/doctors/doctors_home.dart';
import 'package:frontend/screens/patients/patient_home.dart';
import 'package:frontend/screens/hospitals/hospital_home.dart';
import 'package:frontend/screens/pharmacies/pharmacy_home.dart';
import 'package:frontend/screens/partners/partners_home.dart';
import 'package:frontend/screens/jobs/jobs_home.dart';
import 'package:frontend/screens/diagnostics/diagnostics_home.dart';


class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  String? selectedOption; // Stores the selected option

  final List<String> options = [
    "Doctor",
    "Patient",
    "Hospital",
    "Pharmacy",
    "Partners",
    "Jobs",
    "Diagnostics",
  ];

  // This method handles navigation based on selection
  void navigateToSelectedPage(BuildContext context, String option) {
    if (option == "Doctor") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorsHome()),
      );
    } 
    else if (option == "Patient") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PatientHome()),
      );
    } 
    else if (option == "Hospital") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HospitalHome()),
      );
    } 
    else if (option == "Pharmacy") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PharmacyHome()),
      );
    } 
    else if (option == "Partners") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PartnersHome()),
      );
    } 
    else if (option == "Jobs") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JobsHome()),
      );
    } 
    else if (option == "Diagnostics") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DiagnosticsHome()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Navigation for $option not implemented yet!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Register As",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Generate checkboxes (single selection)
            ...options.map((option) {
              return CheckboxListTile(
                title: Text(option),
                value: selectedOption == option,
                onChanged: (bool? value) {
                  setState(() {
                    selectedOption = value == true ? option : null;
                  });
                },
              );
            }),

            const SizedBox(height: 26),

            // Submit Button
            Center(
              child: CustomButton(
                text: "Submit",
                filled: true,
                onPressed: () {
                  if (selectedOption != null) {
                    // Navigate to selected screen
                    navigateToSelectedPage(context, selectedOption!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select one option!")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



