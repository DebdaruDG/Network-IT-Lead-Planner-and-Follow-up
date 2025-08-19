import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_handling/lead_followup_provider.dart';
import '../lead_creation_provider.dart';
import '../step_utils.dart';
import '../../../core/widgets/app_toast.dart';

class Step5ExecuteTasks extends ConsumerStatefulWidget {
  const Step5ExecuteTasks({super.key});

  @override
  ConsumerState<Step5ExecuteTasks> createState() => _Step5ExecuteTasksState();
}

class _Step5ExecuteTasksState extends ConsumerState<Step5ExecuteTasks> {
  @override
  Widget build(BuildContext context) {
    final followupState = ref.watch(followupProvider);
    final tasks =
        followupState.followupResult?['tasks'] as List<dynamic>? ??
        [
          {
            'type': 'email',
            'day': '1',
            'template': 'Share a news',
            'status': 'Pending',
          },
          {
            'type': 'linkedin',
            'day': '3',
            'template': 'Value drop',
            'status': 'Pending',
          },
          {
            'type': 'phone',
            'day': '5',
            'template': 'Just checking how are you?',
            'status': 'Pending',
          },
        ];

    return Column(
      children: [
        ...tasks.map(
          (task) => Column(
            children: [
              taskCard(
                "${task['type'] == 'email'
                    ? 'Email'
                    : task['type'] == 'linkedin'
                    ? 'LinkedIn'
                    : 'Phone Call'} · Day ${task['day']}",
                "Template: ${task['template']}",
                task['status'],
                () {
                  AppToast.success(
                    context,
                    "Task Executed",
                    subtitle:
                        "Mock execution for ${task['type']} on Day ${task['day']}.",
                  );
                },
                isPhoneCall: task['type'] == 'phone',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StepUtils().backButton(
              () => ref.read(leadStepProvider.notifier).previousStep(),
            ),
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
                AppToast.success(
                  context,
                  "Tasks Ready",
                  subtitle: "Proceeding to track progress.",
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

  Widget taskCard(
    String title,
    String subtitle,
    String status,
    VoidCallback onPressed, {
    required bool isPhoneCall,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 4),
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
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  isPhoneCall ? "Call Now" : "Send",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
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
