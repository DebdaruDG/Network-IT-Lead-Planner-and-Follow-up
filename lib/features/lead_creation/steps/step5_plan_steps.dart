import 'package:flutter/material.dart';

class Step5ExecuteTasks extends StatelessWidget {
  const Step5ExecuteTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        taskCard("Email · Day 1", "Template: Share a news", "Pending"),
        const SizedBox(height: 8),
        taskCard("LinkedIn · Day 3", "Template: Value drop", "Pending"),
        const SizedBox(height: 8),
        taskCard(
          "Phone Call · Day 5",
          "Talking points: Just checking",
          "Pending",
        ),
      ],
    );
  }

  Widget taskCard(String title, String subtitle, String status) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              Chip(label: Text(status)),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () {}, child: const Text("Send")),
            ],
          ),
        ],
      ),
    );
  }
}
