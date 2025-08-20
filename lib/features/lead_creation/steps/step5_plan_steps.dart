import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/utils/animation_constants.dart';
import '../../../core/widgets/app_toast.dart';
import '../data_handling/lead_provider.dart';
import '../lead_creation_provider.dart';
import '../../../core/models/lead_plan_response.dart';
import '../step_utils.dart';

class Step5ExecuteTasks extends ConsumerStatefulWidget {
  final String? leadId;
  const Step5ExecuteTasks({super.key, this.leadId});

  @override
  ConsumerState<Step5ExecuteTasks> createState() => _Step5ExecuteTasksState();
}

class _Step5ExecuteTasksState extends ConsumerState<Step5ExecuteTasks> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final leadId = widget.leadId;

      if (leadId != null) {
        await ref.read(leadProvider.notifier).fetchLeadPlans(leadId: leadId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final leadState = ref.watch(leadProvider);
    final isLoading = leadState.isLoading;
    final tasks = leadState.selectedLeadPlans;

    if (isLoading) {
      return const Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF001BCE)),
              ),
            ),
            SizedBox(width: 12),
            Text(
              "Fetching Tasks...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    if (leadState.error != null) {
      return Center(
        child: Text(
          "Error loading tasks: ${leadState.error}",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          "No tasks found for this lead.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ...tasks.map((Plan task) {
            return taskCard(
              "${task.goal} · Day ${task.durationDays}",
              "Template: ${task.emailTemplate?.isNotEmpty == true ? task.emailTemplate : (task.linkedInTemplate ?? task.callTalkingPoint ?? 'N/A')}",
              "Pending",
              () {
                AppToast.success(
                  context,
                  "Task Executed",
                  subtitle:
                      "Executed ${task.goal} (Plan ${task.planId}) on Day ${task.durationDays}.",
                );
              },
              isPhoneCall: ((task.preferredChannels as List).contains("phone")),
              task: task,
            );
          }),
          const SizedBox(height: 16),
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
                    "Tasks Ready",
                    subtitle: "Proceeding to track progress.",
                  );
                  ref.read(leadStepProvider.notifier).nextStep();
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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

  Widget taskCard(
    String title,
    String subtitle,
    String status,
    VoidCallback onPressed, {
    required bool isPhoneCall,
    required Plan task,
  }) {
    // Title: Goal + Duration
    String effectiveTitle = '${task.goal} - Day ${task.durationDays}';

    // Status / template preview
    if (task.emailTemplate != null && task.emailTemplate!.isNotEmpty) {
    } else if (task.linkedInTemplate != null &&
        task.linkedInTemplate!.isNotEmpty) {
    } else if (task.callTalkingPoint != null &&
        task.callTalkingPoint!.isNotEmpty) {}

    // Pick icon based on preferred channel
    IconData taskIcon = LucideIcons.circle;
    if (task.preferredChannels.contains("email")) {
      taskIcon = LucideIcons.mail;
    } else if (task.preferredChannels.contains("linkedin")) {
      taskIcon = LucideIcons.linkedin;
    } else if (task.preferredChannels.contains("phone call")) {
      taskIcon = LucideIcons.phone;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)), // subtle border
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER: Icon + Goal + Duration + Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(taskIcon, size: 20, color: Colors.black87),
                  const SizedBox(width: 8),
                  Text(
                    effectiveTitle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: Text(isPhoneCall ? "Call Now" : "Send"),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TEMPLATES PREVIEW SECTION
          if ((task.emailTemplate?.isNotEmpty ?? false) ||
              (task.linkedInTemplate?.isNotEmpty ?? false) ||
              (task.callTalkingPoint?.isNotEmpty ?? false))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.emailTemplate?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.mail,
                          size: 16,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            task.emailTemplate!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (task.linkedInTemplate?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.linkedin,
                          size: 16,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            task.linkedInTemplate!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (task.callTalkingPoint?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.phone,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            task.callTalkingPoint!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No templates available",
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
