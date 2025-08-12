import 'package:flutter/material.dart';

class Step4Instructions extends StatelessWidget {
  const Step4Instructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        templateSelector("Email templates", [
          "Share a news",
          "Comment",
          "Case study",
          "Ask for meeting",
        ]),
        const SizedBox(height: 12),
        templateSelector("LinkedIn templates", [
          "Warm intro",
          "Insight share",
          "Value drop",
        ]),
        const SizedBox(height: 12),
        templateSelector("Call talking points", [
          "Wish on an occasion",
          "Something interesting",
          "Just checking",
        ]),
      ],
    );
  }

  Widget templateSelector(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          items:
              options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}
