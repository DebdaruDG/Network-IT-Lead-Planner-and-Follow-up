import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/animation_constants.dart';
import '../data_handling/lead_followup_provider.dart';
import '../lead_creation_provider.dart';
import '../step_utils.dart';
import '../../../core/widgets/app_toast.dart';

class Step6TrackProgress extends ConsumerStatefulWidget {
  const Step6TrackProgress({super.key});

  @override
  ConsumerState<Step6TrackProgress> createState() => _Step6TrackProgressState();
}

class _Step6TrackProgressState extends ConsumerState<Step6TrackProgress> {
  @override
  Widget build(BuildContext context) {
    final followupState = ref.watch(followupProvider);
    final tasks =
        followupState.followupResult?['tasks'] as List<dynamic>? ??
        [
          {
            'day': '1',
            'type': 'email',
            'template': 'Share a news',
            'status': 'Sent',
          },
          {
            'day': '3',
            'type': 'linkedin',
            'template': 'Value drop',
            'status': 'Pending',
          },
          {
            'day': '5',
            'type': 'phone',
            'template': 'Just checking how are you?',
            'status': 'Pending',
          },
        ];
    final completedTasks =
        tasks.where((task) => task['status'] == 'Sent').length;
    final progress = tasks.isNotEmpty ? completedTasks / tasks.length : 0.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 720;

    return SingleChildScrollView(
      child: Column(
        children: [
          isMobile
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  progressCard(
                    "Plan completion",
                    progress,
                    "$completedTasks of ${tasks.length} tasks completed",
                  ),
                  const SizedBox(height: 16),
                  progressCard(
                    "Lead responsiveness",
                    null,
                    "Awaiting response",
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: progressCard(
                      "Plan completion",
                      progress,
                      "$completedTasks of ${tasks.length} tasks completed",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: progressCard(
                      "Lead responsiveness",
                      null,
                      "Awaiting response",
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 24),
          taskList(tasks),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StepUtils()
                  .backButton(
                    () => ref.read(leadStepProvider.notifier).previousStep(),
                  )
                  .animate(
                    effects:
                        AnimationEffectConstants
                            .usualAnimationEffects['summaryCardAnimation']
                            ?.effectsBuilder,
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
                    "Process Completed",
                    subtitle: "Lead follow-up finished.",
                  );
                  ref.read(leadStepProvider.notifier).nextStep();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Finish",
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
              ).animate(
                effects:
                    AnimationEffectConstants
                        .usualAnimationEffects['summaryCardAnimation']
                        ?.effectsBuilder,
              ),
            ],
          ),
        ],
      ),
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
    ).animate(
      effects:
          AnimationEffectConstants
              .usualAnimationEffects['summaryCardAnimation']
              ?.effectsBuilder,
    );
  }

  Widget taskList(List<dynamic> tasks) {
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
          ...tasks.map(
            (task) => Column(
              children: [
                taskRow(
                  "Day ${task['day']}",
                  task['type'] == 'email'
                      ? 'Email'
                      : task['type'] == 'linkedin'
                      ? 'LinkedIn'
                      : 'Phone Call',
                  task['template'],
                  task['status'],
                ),
                const Divider(color: Color(0xFFCBD5E1), thickness: 1),
              ],
            ),
          ),
        ],
      ),
    ).animate(
      effects:
          AnimationEffectConstants
              .usualAnimationEffects['summaryCardAnimation']
              ?.effectsBuilder,
    );
  }

  Widget taskRow(String when, String type, String detail, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            child: Text(when, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 80,
            child: Text(type, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 120,
            child: Text(detail, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 100,
            child: Text(
              status,
              style: TextStyle(
                color:
                    status == 'Sent'
                        ? const Color(0xFF10B981)
                        : const Color(0xFF64748B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ).animate(
      effects:
          AnimationEffectConstants
              .usualAnimationEffects['summaryCardAnimation']
              ?.effectsBuilder,
    );
  }
}
