import 'package:flutter/material.dart';

class Step6TrackProgress extends StatelessWidget {
  const Step6TrackProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        progressCard("Plan completion", 0.33, "1 of 3 tasks completed"),
        const SizedBox(height: 12),
        progressCard("Lead responsiveness", null, "Replied in 18h (mock)"),
      ],
    );
  }

  Widget progressCard(String title, double? progress, String detail) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          if (progress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
          ],
          const SizedBox(height: 8),
          Text(
            detail,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
