import 'package:flutter/material.dart';

class Step2GoalSelection extends StatelessWidget {
  const Step2GoalSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Select a goal",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            goalCard("Book a meeting", "Calendar event"),
            goalCard("Get a reply", "Positive response"),
            goalCard("Share proposal", "Formal document"),
            goalCard("Close deal", "Convert to customer"),
            goalCard("Other", "Custom target"),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Text("Duration (days)"),
            SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget goalCard(String title, String subtitle) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
