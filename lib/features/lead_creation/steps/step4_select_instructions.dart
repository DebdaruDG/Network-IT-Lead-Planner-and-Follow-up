import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lead_creation_provider.dart';

class Step4Instructions extends ConsumerStatefulWidget {
  const Step4Instructions({super.key});

  @override
  ConsumerState<Step4Instructions> createState() => _Step4InstructionsState();
}

class _Step4InstructionsState extends ConsumerState<Step4Instructions> {
  @override
  Widget build(BuildContext context) {
    final stepNotifier = ref.read(leadStepProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: templateSelector("Email templates", [
                "Share a news",
                "Comment",
                "Case study",
                "Ask for meeting",
              ]),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: templateSelector("LinkedIn templates", [
                "Warm intro",
                "Insight share",
                "Value drop",
              ]),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: templateSelector("Call talking points", [
                "Wish on an occasion",
                "Something interesting",
                "Just checking",
              ]),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            goBackButton(() => stepNotifier.previousStep()),
            continueButton(() => stepNotifier.nextStep()),
          ],
        ),
      ],
    );
  }

  Widget templateSelector(String title, List<String> options) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.35,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E293B)),
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
              items:
                  options
                      .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                      .toList(),
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Preview placeholder...",
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget continueButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text(
        "Continue",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget goBackButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: const Text(
        "Go Back",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}
