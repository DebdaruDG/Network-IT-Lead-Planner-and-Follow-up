import 'dart:developer' as console;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    /// ✅ Fetch tasks (plans) for the selected lead
    Future.delayed(Duration.zero, () async {
      final leadId = widget.leadId;
      // ref.read(leadProvider).leadId;
      console.log('leadId - $leadId');

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
            CircularProgressIndicator(strokeWidth: 2),
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
            console.log('task - ${task.toJson()}');
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
              isPhoneCall:
                  (task.preferredChannels is List &&
                      (task.preferredChannels as List).contains("phone")),
            );
          }),
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
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
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
