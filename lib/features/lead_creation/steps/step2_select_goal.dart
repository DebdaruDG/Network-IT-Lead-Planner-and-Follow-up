import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lead_creation_provider.dart';
import '../step_utils.dart';

class Step2GoalSelection extends ConsumerStatefulWidget {
  const Step2GoalSelection({super.key});

  @override
  ConsumerState<Step2GoalSelection> createState() => _Step2GoalSelectionState();
}

class _Step2GoalSelectionState extends ConsumerState<Step2GoalSelection> {
  String _selectedGoal = "Book a meeting";
  int _duration = 10;

  final List<Map<String, String>> _goals = [
    {"title": "Book a meeting", "subtitle": "Calendar event"},
    {"title": "Get a reply", "subtitle": "Positive response"},
    {"title": "Share proposal", "subtitle": "Formal document"},
    {"title": "Close deal", "subtitle": "Convert to customer"},
    {"title": "Other", "subtitle": "Custom target"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              _goals.map((goal) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: _goalCard(
                    goal["title"]!,
                    goal["subtitle"]!,
                    _selectedGoal == goal["title"],
                    (selected) {
                      if (selected) {
                        setState(() {
                          _selectedGoal = goal["title"]!;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Row(
            children: [
              const Text(
                "Duration (days): ",
                style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 70,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  controller: TextEditingController(text: _duration.toString()),
                  onChanged: (value) {
                    setState(() {
                      _duration = int.tryParse(value) ?? 10;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StepUtils().backButton(() {
              ref.read(leadStepProvider.notifier).previousStep();
            }),
            StepUtils().generatePlanButton(() {
              ref.read(leadStepProvider.notifier).nextStep();
              // Later: Save selected goal + duration to provider/state
            }),
          ],
        ),
      ],
    );
  }

  Widget _goalCard(
    String title,
    String subtitle,
    bool isSelected,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
      ),
      child: InkWell(
        onTap: () => onChanged(true),
        child: Row(
          children: [
            Radio<String>(
              value: title,
              groupValue: _selectedGoal,
              onChanged: (value) {
                if (value != null) onChanged(true);
              },
              activeColor: const Color(0xFF3B82F6),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
