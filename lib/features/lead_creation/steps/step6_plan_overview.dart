import 'package:flutter/material.dart';

class Step6TrackProgress extends StatelessWidget {
  const Step6TrackProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: progressCard(
                "Plan completion",
                0.33,
                "1 of 3 tasks completed",
              ),
            ),
            Expanded(
              child: progressCard(
                "Lead responsiveness",
                null,
                "Replied in 18h (mock)",
              ),
            ),
          ],
        ),
        const SizedBox(height: 24), // Spacing before task list
        taskList(),
        const SizedBox(height: 24), // Spacing before task list
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            backButton(() {
              // Placeholder for go back action
            }),
            finishButton(() {
              // Placeholder for finish action
            }),
          ],
        ),
      ],
    );
  }

  Widget progressCard(String title, double? progress, String detail) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(16),
      ),
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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

  Widget finishButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text(
        "Finish",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto', // Match image font style
        ),
      ),
    );
  }

  Widget backButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text(
        "Back",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget taskList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "When",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                fontFamily: 'Roboto',
              ),
            ),
            Text(
              "Type",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                fontFamily: 'Roboto',
              ),
            ),
            Text(
              "Detail",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                fontFamily: 'Roboto',
              ),
            ),
            Text(
              "Status",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        taskRow("Day 1", "Email", "Share a news", "Sent (mock)"),
        const SizedBox(height: 8),
        taskRow("Day 3", "LinkedIn", "Value drop", "Pending"),
        const SizedBox(height: 8),
        taskRow("Day 5", "Phone Call", "Just checking", "Pending"),
      ],
    );
  }

  Widget taskRow(String when, String type, String detail, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          when,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1E293B),
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          type,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1E293B),
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          detail,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1E293B),
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          status,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color:
                status == "Sent (mock)"
                    ? const Color(0xFF10B981) // Green for sent
                    : const Color(0xFF64748B), // Medium gray for pending
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}
