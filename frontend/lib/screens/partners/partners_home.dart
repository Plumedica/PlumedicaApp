import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_buttons.dart';

// 🔹 Import your real partner pages
import 'package:frontend/screens/partners/health_insurance.dart';
import 'package:frontend/screens/partners/scientific_journals.dart';
import 'package:frontend/screens/partners/life_insurance.dart';

class PartnersHome extends StatefulWidget {
  const PartnersHome({super.key});

  @override
  State<PartnersHome> createState() => _PartnersHomeState();
}

class _PartnersHomeState extends State<PartnersHome> {
  // ✅ State for selected partner
  String? selectedPartner;

  void _submitSelection() {
    if (selectedPartner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a partner!")),
      );
      return;
    }

    // ✅ Navigate based on selection
    Widget page;
    switch (selectedPartner) {
      case "Health Insurances":
        page = const HealthInsurancePage();
        break;
      case "Scientific Journals":
        page = const ScientificJournalsPage();
        break;
      case "Life Insurances":
        page = const LifeInsurancePage();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Collaborating Partners"),
        backgroundColor: const Color.fromRGBO(199, 206, 219, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Partner:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ✅ Radio buttons for single selection
            RadioListTile<String>(
              title: const Text("Health Insurances"),
              value: "Health Insurances",
              groupValue: selectedPartner,
              onChanged: (value) {
                setState(() {
                  selectedPartner = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text("Scientific Journals"),
              value: "Scientific Journals",
              groupValue: selectedPartner,
              onChanged: (value) {
                setState(() {
                  selectedPartner = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text("Life Insurances"),
              value: "Life Insurances",
              groupValue: selectedPartner,
              onChanged: (value) {
                setState(() {
                  selectedPartner = value;
                });
              },
            ),

            const SizedBox(height: 30),

            // ✅ Custom Submit Button
            Center(
              child: CustomButton(
                text: "Register",
                filled: true,
                onPressed: _submitSelection,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
