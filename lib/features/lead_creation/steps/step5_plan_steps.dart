import 'package:flutter/material.dart';

class Step5ExecuteTasks extends StatelessWidget {
  const Step5ExecuteTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        taskCard(
          "Email · Day 1",
          "Template: Share a news",
          "Pending",
          () {}, // Placeholder for Send action
          isPhoneCall: false,
        ),
        const SizedBox(height: 16), // Increased spacing to match image
        taskCard(
          "LinkedIn · Day 3",
          "Template: Value drop",
          "Pending",
          () {}, // Placeholder for Send action
          isPhoneCall: false,
        ),
        const SizedBox(height: 16), // Increased spacing to match image
        taskCard(
          "Phone Call · Day 5",
          "Talking points: Just checking",
          "Pending",
          () {}, // Placeholder for Call Now action
          isPhoneCall: true,
        ),
      ],
    );
  }

  Widget taskCard(
    String title,
    String subtitle,
    String status,
    VoidCallback onPressed, {
    required bool isPhoneCall,
  }) {
    return Container(
      padding: const EdgeInsets.all(16), // Increased padding to match image
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(
                height: 4,
              ), // Added spacing between title and subtitle
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                status,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF64748B),
                  fontFamily: 'Roboto', // Match image font style
                ),
              ),
              const SizedBox(width: 16), // Increased spacing to match image
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.transparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  isPhoneCall ? "Call Now" : "Send (mock)",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto', // Match image font style
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
