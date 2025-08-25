import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/models/lead_plan_response.dart';
import '../../../../core/utils/animation_constants.dart';

class TaskTemplateTile extends StatefulWidget {
  final Map<String, Task?> tasksByChannel;
  final Plan task;

  const TaskTemplateTile({
    super.key,
    required this.tasksByChannel,
    required this.task,
  });

  @override
  State<TaskTemplateTile> createState() => _TaskTemplateTileState();
}

class _TaskTemplateTileState extends State<TaskTemplateTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 6),
                child: InkWell(
                  onTap: _toggleExpansion,
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Templates',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                          children: [
                            TextSpan(
                              text: ' (Click to Expand)',
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.arrow_drop_up_outlined
                            : Icons.arrow_drop_down_outlined,
                        color: const Color(0xFF233B7A),
                        size: 20,
                      ).animate(
                        effects:
                            AnimationEffectConstants
                                .usualAnimationEffects['summaryCardAnimation']
                                ?.effectsBuilder,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTemplateItem(
                        context,
                        channel: 'email',
                        icon: LucideIcons.mail,
                        iconColor: Colors.blueGrey,
                        title: widget.task.emailTemplate ?? '',
                        content:
                            widget.tasksByChannel['email']?.templateContent ??
                            '',
                      ),
                      _buildTemplateItem(
                        context,
                        channel: 'linkedin',
                        icon: LucideIcons.linkedin,
                        iconColor: Colors.blue,
                        title: widget.task.linkedInTemplate ?? '',
                        content:
                            widget
                                .tasksByChannel['linkedin']
                                ?.templateContent ??
                            '',
                      ),
                      _buildTemplateItem(
                        context,
                        channel: 'phone',
                        icon: LucideIcons.phone,
                        iconColor: Colors.orange,
                        title: widget.task.callTalkingPoint ?? '',
                        content:
                            widget.tasksByChannel['phone']?.templateContent ??
                            '',
                      ),
                    ],
                  ).animate(
                    effects:
                        AnimationEffectConstants
                            .usualAnimationEffects['summaryCardAnimation']
                            ?.effectsBuilder,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateItem(
    BuildContext context, {
    required String channel,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    if (!widget.tasksByChannel.containsKey(channel) ||
        widget.tasksByChannel[channel] == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.height * 0.35,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade500, width: 0.4),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: iconColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Color(0xFF1E293B),
                      ),
                    ).animate(
                      effects:
                          AnimationEffectConstants
                              .usualAnimationEffects['summaryCardAnimation']
                              ?.effectsBuilder,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Text(
                content,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
                maxLines: 40,
                overflow: TextOverflow.ellipsis,
              ).animate(
                effects:
                    AnimationEffectConstants
                        .usualAnimationEffects['leadRowAnimation']
                        ?.effectsBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
