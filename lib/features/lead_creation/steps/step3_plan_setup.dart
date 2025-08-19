import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_handling/lead_followup_provider.dart';
import '../lead_creation_provider.dart';
import '../step_utils.dart';
import '../../../core/widgets/app_toast.dart';

class Step3PlanSetup extends ConsumerStatefulWidget {
  const Step3PlanSetup({super.key});

  @override
  ConsumerState<Step3PlanSetup> createState() => _Step3PlanSetupState();
}

class _Step3PlanSetupState extends ConsumerState<Step3PlanSetup> {
  final Map<String, String> _channelMap = {
    'Phone Call': 'phone',
    'LinkedIn Message': 'linkedin',
    'Email': 'email',
  };

  final List<Map<String, String>> _stepConfigs = [
    {'type': 'Email', 'day': '1'},
    {'type': 'LinkedIn Message', 'day': '3'},
    {'type': 'Phone Call', 'day': '5'},
  ];

  @override
  Widget build(BuildContext context) {
    final followupState = ref.watch(followupProvider);
    final selectedChannels =
        followupState.selectedChannels ?? ['email', 'linkedin', 'phone'];
    final selectedTypes =
        _channelMap.entries
            .where((entry) => selectedChannels.contains(entry.value))
            .map((entry) => entry.key)
            .toSet();

    final List<Map<String, String>> activeSteps =
        _stepConfigs
            .where((config) => selectedTypes.contains(config['type']))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 0.5),
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
                  letterSpacing: 0.35,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _checkboxItem("Phone Call", selectedTypes),
                  const SizedBox(width: 16),
                  _checkboxItem("LinkedIn Message", selectedTypes),
                  const SizedBox(width: 16),
                  _checkboxItem("Email", selectedTypes),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 0.5),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Preview",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              ...activeSteps.map(
                (step) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StepUtils().backButton(() {
              ref.read(leadStepProvider.notifier).previousStep();
            }),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111827),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              onPressed: () {
                if (selectedChannels.isEmpty) {
                  AppToast.warning(
                    context,
                    "Selection Incomplete",
                    subtitle: "Please select at least one step type.",
                  );
                  return;
                }
                AppToast.success(
                  context,
                  "Channels Selected",
                  subtitle: "Proceeding to template selection.",
                );
                ref.read(leadStepProvider.notifier).nextStep();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (followupState.isLoading) ...[
                    const SizedBox(width: 8),
                    const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _checkboxItem(String label, Set<String> selectedTypes) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.75,
          child: Checkbox(
            value: selectedTypes.contains(label),
            onChanged: (bool? value) {
              setState(() {
                final updatedTypes = Set<String>.from(selectedTypes);
                if (value == true) {
                  updatedTypes.add(label);
                } else {
                  updatedTypes.remove(label);
                }
                final updatedChannels =
                    updatedTypes.map((type) => _channelMap[type]!).toList();
                ref
                    .read(followupProvider.notifier)
                    .updateChannels(updatedChannels);
              });
            },
            activeColor: const Color(0xFF3B82F6),
            checkColor: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
