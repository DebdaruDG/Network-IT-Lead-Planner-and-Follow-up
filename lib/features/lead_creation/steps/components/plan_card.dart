import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/lead_plan_response.dart';
import 'task_template_tile.dart';

class PlanCard extends StatelessWidget {
  final Plan task;
  final VoidCallback onExecute;

  const PlanCard({super.key, required this.task, required this.onExecute});

  @override
  Widget build(BuildContext context) {
    final effectiveTitle = '${task.goal} - Day ${task.durationDays}';
    final taskIcon = _getTaskIcon(task.preferredChannels);
    final tasksByChannel = _groupTasksByChannel(task.tasks);
    final hasTemplates =
        (task.emailTemplate?.isNotEmpty ?? false) ||
        (task.linkedInTemplate?.isNotEmpty ?? false) ||
        (task.callTalkingPoint?.isNotEmpty ?? false) ||
        tasksByChannel.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
          _buildHeader(context, effectiveTitle, taskIcon, task),
          const SizedBox(height: 10),
          hasTemplates
              ? TaskTemplateTile(tasksByChannel: tasksByChannel, task: task)
              : const Center(
                child: Text(
                  "No templates or tasks available",
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String title,
    IconData taskIcon,
    Plan task,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(taskIcon, size: 20, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              title,
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.shade800),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Pending",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onExecute,
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
              child: Text(
                task.preferredChannels.contains("phone") ? "Call Now" : "Send",
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getTaskIcon(List<String> channels) {
    if (channels.contains("email")) return LucideIcons.mail;
    if (channels.contains("linkedin")) return LucideIcons.linkedin;
    if (channels.contains("phone")) return LucideIcons.phone;
    return LucideIcons.circle;
  }

  Map<String, Task?> _groupTasksByChannel(List<Task> tasks) {
    final tasksByChannel = <String, Task?>{};
    for (var taskItem in tasks) {
      for (var channel in taskItem.channel) {
        tasksByChannel.putIfAbsent(channel, () => taskItem);
      }
    }
    return tasksByChannel;
  }
}
