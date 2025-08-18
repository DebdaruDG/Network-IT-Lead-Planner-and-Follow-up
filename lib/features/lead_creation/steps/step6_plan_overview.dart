import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lead_creation_provider.dart';

class Step6TrackProgress extends ConsumerStatefulWidget {
  const Step6TrackProgress({super.key});

  @override
  ConsumerState<Step6TrackProgress> createState() => _Step6TrackProgressState();
}

class _Step6TrackProgressState extends ConsumerState<Step6TrackProgress> {
  @override
  Widget build(BuildContext context) {
    final stepNotifier = ref.read(leadStepProvider.notifier);

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
            const SizedBox(width: 16),
            Expanded(
              child: progressCard(
                "Lead responsiveness",
                null,
                "Replied in 18h (mock)",
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        taskList(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            backButton(() => stepNotifier.previousStep()),
            finishButton(() {
              // You could reset or show summary screen
              debugPrint("Finish clicked!");
            }),
          ],
        ),
      ],
    );
  }

  Widget progressCard(String title, double? progress, String detail) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontFamily: 'Roboto',
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE0E7FF),
              color: const Color(0xFF4C51BF),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            detail,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color:
                  progress != null
                      ? const Color(0xFF64748B)
                      : const Color(0xFF10B981),
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  Widget finishButton(VoidCallback onPressed) => ElevatedButton(
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
        fontFamily: 'Roboto',
      ),
    ),
  );

  Widget backButton(VoidCallback onPressed) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Color(0xFF1E293B)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
    child: const Text(
      "Back",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1E293B),
        fontFamily: 'Roboto',
      ),
    ),
  );

  Widget taskList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SizedBox(width: 80, child: Text("When")),
              SizedBox(width: 80, child: Text("Type")),
              SizedBox(width: 120, child: Text("Detail")),
              SizedBox(width: 100, child: Text("Status")),
            ],
          ),
          const Divider(color: Color(0xFFCBD5E1), thickness: 1),
          taskRow("Day 1", "Email", "Share a news", "Sent (mock)"),
          const Divider(color: Color(0xFFCBD5E1), thickness: 1),
          taskRow("Day 3", "LinkedIn", "Value drop", "Pending"),
          const Divider(color: Color(0xFFCBD5E1), thickness: 1),
          taskRow("Day 5", "Phone Call", "Just checking", "Pending"),
        ],
      ),
    );
  }

  Widget taskRow(String when, String type, String detail, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 80, child: Text(when)),
          SizedBox(width: 80, child: Text(type)),
          SizedBox(width: 120, child: Text(detail)),
          SizedBox(
            width: 100,
            child: Text(
              status,
              style: TextStyle(
                color:
                    status == "Sent (mock)"
                        ? const Color(0xFF10B981)
                        : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
