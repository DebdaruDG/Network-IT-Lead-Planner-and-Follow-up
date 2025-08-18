import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

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

  final Set<String> _hoveredGoals = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              _goals.map((goal) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    double cardWidth = (constraints.maxWidth - 12 * 2) / 3;
                    return SizedBox(
                      width: cardWidth,
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
                  },
                );
              }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text(
              "Duration (days): ",
              style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80, // adjust width if needed
              child: SpinBox(
                min: 1,
                max: 365,
                value: _duration.toDouble(),
                step: 1,
                spacing: 0, // spacing between number and buttons
                incrementIcon: const Icon(Icons.arrow_drop_up, size: 20),
                decrementIcon: const Icon(Icons.arrow_drop_down, size: 20),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 0.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                ),
                onChanged: (value) {
                  setState(() {
                    _duration = value.toInt();
                  });
                },
              ),
            ),
          ],
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
    final isHovered = _hoveredGoals.contains(title);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredGoals.add(title)),
      onExit: (_) => setState(() => _hoveredGoals.remove(title)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isHovered ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
            width: 0.7,
          ),
          color: const Color(0xFFF9FBFD),
        ),
        child: InkWell(
          onTap: () => onChanged(true),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Transform.scale(
                scale: 0.8,
                child: Radio<String>(
                  value: title,
                  groupValue: _selectedGoal,
                  onChanged: (value) {
                    if (value != null) onChanged(true);
                  },
                  activeColor: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
