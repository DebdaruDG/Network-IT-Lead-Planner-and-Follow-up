import 'dart:developer' as console;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    console.log('task - ${task.toJson()}');

    // Title: Goal + Duration
    String effectiveTitle = '${task.goal} - Day ${task.durationDays}';

    // Status / template preview
    String effectiveStatus = 'Pending';
    if (task.emailTemplate != null && task.emailTemplate!.isNotEmpty) {
      effectiveStatus = task.emailTemplate!;
    } else if (task.linkedInTemplate != null &&
        task.linkedInTemplate!.isNotEmpty) {
      effectiveStatus = task.linkedInTemplate!;
    } else if (task.callTalkingPoint != null &&
        task.callTalkingPoint!.isNotEmpty) {
      effectiveStatus = task.callTalkingPoint!;
    }
    List<String> channels =
        task.preferredChannels.isNotEmpty
            ? task.preferredChannels.expand((c) => c).toList()
            : [];
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER: Goal + Duration + Status + Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    effectiveTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  channels.isNotEmpty
                      ? Wrap(
                        spacing: 6,
                        children:
                            channels.map((c) {
                              Color bg;
                              IconData icon;
                              switch (c.toLowerCase()) {
                                case 'email':
                                  bg = Colors.blue.shade100;
                                  icon = Icons.email_outlined;
                                  break;
                                case 'linkedin':
                                  bg = Colors.green.shade100;
                                  icon = Icons.link;
                                  break;
                                case 'phone call':
                                  bg = Colors.orange.shade100;
                                  icon = Icons.phone_outlined;
                                  break;
                                default:
                                  bg = Colors.grey.shade200;
                                  icon = Icons.circle_outlined;
                              }
                              return Chip(
                                label: Text(
                                  c,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                avatar: Icon(
                                  icon,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                backgroundColor: bg,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              );
                            }).toList(),
                      )
                      : const Text(
                        'No channels',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
                        ),
                      ),
                ],
              ),
              Row(
                children: [
                  Text(
                    effectiveStatus,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
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
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Templates Section (Expandable)
          ExpansionTile(
            title: const Text(
              "Templates",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            tilePadding: EdgeInsets.zero,
            children: [
              if (task.emailTemplate != null && task.emailTemplate!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.email_outlined, size: 20),
                  title: Text(
                    task.emailTemplate!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              if (task.linkedInTemplate != null &&
                  task.linkedInTemplate!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.link, size: 20),
                  title: Text(
                    task.linkedInTemplate!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              if (task.callTalkingPoint != null &&
                  task.callTalkingPoint!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.phone_outlined, size: 20),
                  title: Text(
                    task.callTalkingPoint!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              if ((task.emailTemplate?.isEmpty ?? true) &&
                  (task.linkedInTemplate?.isEmpty ?? true) &&
                  (task.callTalkingPoint?.isEmpty ?? true))
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "No templates available",
                    style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                  ),
                ),
            ],
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
