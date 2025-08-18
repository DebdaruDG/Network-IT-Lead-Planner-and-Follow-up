import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lead_creation_provider.dart';
import '../step_utils.dart';

class Step3PlanSetup extends ConsumerStatefulWidget {
  const Step3PlanSetup({super.key});

  @override
  ConsumerState<Step3PlanSetup> createState() => _Step3PlanSetupState();
}

class _Step3PlanSetupState extends ConsumerState<Step3PlanSetup> {
  final Set<String> _selectedTypes = {
    'Phone Call',
    'LinkedIn Message',
    'Email',
  };

  final List<Map<String, String>> _stepConfigs = [
    {'type': 'Email', 'day': '1'},
    {'type': 'LinkedIn Message', 'day': '3'},
    {'type': 'Phone Call', 'day': '5'},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> activeSteps =
        _stepConfigs
            .where((config) => _selectedTypes.contains(config['type']))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step type selection
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose step types",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _choiceChip("Phone Call"),
                  _choiceChip("LinkedIn Message"),
                  _choiceChip("Email"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Preview
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Preview (mock)",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              ...activeSteps.map(
                (step) => Row(
                  children: [
                    const Icon(Icons.circle, size: 6, color: Color(0xFF1E293B)),
                    const SizedBox(width: 8),
                    Text(
                      "Day ${step['day']} - ${step['type']}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Navigation buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StepUtils().backButton(() {
              ref.read(leadStepProvider.notifier).previousStep();
            }),
            StepUtils().continueButton(() {
              ref.read(leadStepProvider.notifier).nextStep();
              // Later: Save selected step types into provider/state
            }),
          ],
        ),
      ],
    );
  }

  Widget _choiceChip(String label) {
    final bool isSelected = _selectedTypes.contains(label);
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF4338CA),
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedTypes.add(label);
          } else {
            _selectedTypes.remove(label);
          }
        });
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF3B82F6),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
