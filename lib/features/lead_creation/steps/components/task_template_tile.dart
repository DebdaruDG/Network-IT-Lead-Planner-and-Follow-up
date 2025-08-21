import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/lead_plan_response.dart';

class TaskTemplateTile extends StatelessWidget {
  final Map<String, Task?> tasksByChannel;
  final Plan task;

  const TaskTemplateTile({
    super.key,
    required this.tasksByChannel,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text(
        'Templates',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1E293B),
        ),
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 0),
      childrenPadding: const EdgeInsets.only(bottom: 8),
      expandedCrossAxisAlignment: CrossAxisAlignment.center,
      expandedAlignment: Alignment.center,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            if (tasksByChannel.containsKey("email") &&
                tasksByChannel["email"] != null)
              _buildTemplateTile(
                context,
                icon: LucideIcons.mail,
                iconColor: Colors.blueGrey,
                title: task.emailTemplate ?? '',
                content: tasksByChannel["email"]!.templateContent,
              ),
            if (tasksByChannel.containsKey("linkedin") &&
                tasksByChannel["linkedin"] != null)
              _buildTemplateTile(
                context,
                icon: LucideIcons.linkedin,
                iconColor: Colors.blue,
                title: task.linkedInTemplate ?? '',
                content: tasksByChannel["linkedin"]!.templateContent,
              ),
            if (tasksByChannel.containsKey("phone") &&
                tasksByChannel["phone"] != null)
              _buildTemplateTile(
                context,
                icon: LucideIcons.phone,
                iconColor: Colors.orange,
                title: task.callTalkingPoint ?? '',
                content: tasksByChannel["phone"]!.templateContent,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemplateTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade500, width: 0.75),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
              ),
            ),
          ],
        ),
        tilePadding: const EdgeInsets.only(left: 16),
        childrenPadding: const EdgeInsets.only(left: 16, bottom: 8),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              content,
              style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
              maxLines: 40,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
