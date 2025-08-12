import 'package:flutter/material.dart';

class Step3PlanSetup extends StatelessWidget {
  const Step3PlanSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Choose step types",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            choiceChip("Phone Call"),
            choiceChip("LinkedIn Message"),
            choiceChip("Email"),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Preview (mock):"),
        const SizedBox(height: 8),
        const Text("• Day 1 – Email"),
        const Text("• Day 3 – LinkedIn Message"),
        const Text("• Day 5 – Phone Call"),
      ],
    );
  }

  Widget choiceChip(String label) {
    return Chip(label: Text(label));
  }
}
