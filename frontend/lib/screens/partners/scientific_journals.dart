import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_buttons.dart';
import 'package:frontend/screens/partners/scientific_journals.dart';

class ScientificJournalsPage extends StatelessWidget {
  const ScientificJournalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scientific Journals"),
      ),
      body: Center(
        child: CustomButton(
          text: "Get Started",
          filled: true,
          onPressed: () {
            // Navigate to the next screen or perform an action
          },
        ),
      ),
    );
  }
}
