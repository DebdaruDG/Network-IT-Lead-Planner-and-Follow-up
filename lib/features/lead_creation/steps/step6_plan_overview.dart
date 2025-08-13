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
            const SizedBox(width: 16), // Spacing between progress cards
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
        const SizedBox(height: 24), // Spacing before buttons
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
      padding: const EdgeInsets.all(16), // Increased padding for spacious feel
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCBD5E1)), // Light gray border
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B), // Dark gray-blue
              fontFamily: 'Roboto',
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE0E7FF), // Light blue background
              color: const Color(0xFF4C51BF), // Purple progress
              minHeight: 8, // Thicker progress bar
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
                      ? const Color(0xFF64748B) // Medium gray
                      : const Color(0xFF10B981), // Green for responsiveness
              fontFamily: 'Roboto',
            ),
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
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget backButton(VoidCallback onPressed) {
    return OutlinedButton(
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
  }

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
            children: [
              SizedBox(
                width: 80, // Fixed width for "When" column
                child: Text(
                  "When",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(
                width: 80, // Fixed width for "Type" column
                child: Text(
                  "Type",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(
                width: 120, // Fixed width for "Detail" column
                child: Text(
                  "Detail",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(
                width: 100, // Fixed width for "Status" column
                child: Text(
                  "Status",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFFCBD5E1), thickness: 1), // Separator
          taskRow("Day 1", "Email", "Share a news", "Sent (mock)"),
          const Divider(color: Color(0xFFCBD5E1), thickness: 1), // Separator
          taskRow("Day 3", "LinkedIn", "Value drop", "Pending"),
          const Divider(color: Color(0xFFCBD5E1), thickness: 1), // Separator
          taskRow("Day 5", "Phone Call", "Just checking", "Pending"),
        ],
      ),
    );
  }

  Widget taskRow(String when, String type, String detail, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Vertical spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80, // Fixed width for "When" column
            child: Text(
              when,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1E293B),
                fontFamily: 'Roboto',
              ),
            ),
          ),
          SizedBox(
            width: 80, // Fixed width for "Type" column
            child: Text(
              type,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1E293B),
                fontFamily: 'Roboto',
              ),
            ),
          ),
          SizedBox(
            width: 120, // Fixed width for "Detail" column
            child: Text(
              detail,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1E293B),
                fontFamily: 'Roboto',
              ),
            ),
          ),
          SizedBox(
            width: 100, // Fixed width for "Status" column
            child: Text(
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
          ),
        ],
      ),
    );
  }
}
