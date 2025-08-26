import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import '../../../core/utils/animation_constants.dart';
import '../data_handling/lead_followup_provider.dart';
import '../lead_creation_provider.dart';
import '../step_utils.dart';
import '../../../core/widgets/app_toast.dart';

class Step2GoalSelection extends ConsumerStatefulWidget {
  const Step2GoalSelection({super.key});

  @override
  ConsumerState<Step2GoalSelection> createState() => _Step2GoalSelectionState();
}

class _Step2GoalSelectionState extends ConsumerState<Step2GoalSelection> {
  final List<Map<String, String>> _goals = [
    {"title": "Book a meeting", "subtitle": "Calendar event"},
    {"title": "Get a reply", "subtitle": "Positive response"},
    {"title": "Share proposal", "subtitle": "Formal document"},
    {"title": "Close deal", "subtitle": "Convert to customer"},
    {"title": "Other", "subtitle": "Custom target"},
  ];

  final Set<String> _hoveredGoals = {};

  @override
  Widget build(BuildContext context) {
    final followupState = ref.watch(followupProvider);
    final selectedGoal = followupState.selectedGoal ?? "Book a meeting";
    final duration = followupState.durationDays ?? 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              _goals.map((goal) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    double cardWidth = (constraints.maxWidth - 12 * 2) / 3;
                    return SizedBox(
                      width: cardWidth,
                      child: _goalCard(
                        goal["title"]!,
                        goal["subtitle"]!,
                        selectedGoal == goal["title"],
                        (selected) {
                          if (selected) {
                            ref
                                .read(followupProvider.notifier)
                                .updateGoal(goal["title"]!);
                          }
                        },
                      ),
                    );
                  },
                );
              }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Duration (days): ",
              style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            ).animate(
              effects:
                  AnimationEffectConstants
                      .usualAnimationEffects['summaryCardAnimation']
                      ?.effectsBuilder,
            ),
            const SizedBox(height: 8),
            Container(
              width: 82,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 0.25, // Matches the original thin border width
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: TextField(
                      controller: TextEditingController(
                        text: duration.toString(),
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                      decoration: const InputDecoration(
                        border:
                            InputBorder
                                .none, // No inner border for the TextField
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                      onChanged: (value) {
                        int? newValue = int.tryParse(value);
                        if (newValue != null &&
                            newValue >= 1 &&
                            newValue <= 365) {
                          ref
                              .read(followupProvider.notifier)
                              .updateDuration(newValue);
                        }
                      },
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_drop_up),
                          padding: EdgeInsets.zero,
                          iconSize: 15,
                          onPressed: () {
                            if (duration < 365) {
                              ref
                                  .read(followupProvider.notifier)
                                  .updateDuration(duration + 1);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          padding: EdgeInsets.zero,
                          iconSize: 15,
                          onPressed: () {
                            if (duration > 1) {
                              ref
                                  .read(followupProvider.notifier)
                                  .updateDuration(duration - 1);
                            }
                          },
                        ),
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
            ),
          ],
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
                if (followupState.selectedGoal == null ||
                    followupState.durationDays == null) {
                  AppToast.warning(
                    context,
                    "Selection Incomplete",
                    subtitle: "Please select a goal and duration.",
                  );
                  return;
                }
                AppToast.success(
                  context,
                  "Goal Selected",
                  subtitle: "Proceeding to plan setup.",
                );
                ref.read(leadStepProvider.notifier).nextStep();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Generate Plan",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ).animate(
                    effects:
                        AnimationEffectConstants
                            .usualAnimationEffects['summaryCardAnimation']
                            ?.effectsBuilder,
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

  Widget _goalCard(
    String title,
    String subtitle,
    bool isSelected,
    ValueChanged<bool> onChanged,
  ) {
    final isHovered = _hoveredGoals.contains(title);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredGoals.add(title)),
      onExit: (_) => setState(() => _hoveredGoals.remove(title)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isHovered ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
            width: 0.7,
          ),
          color: const Color(0xFFF9FBFD),
        ),
        child: InkWell(
          onTap: () => onChanged(true),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Transform.scale(
                scale: 0.8,
                child: Radio<String>(
                  value: title,
                  groupValue:
                      ref.watch(followupProvider).selectedGoal ??
                      "Book a meeting",
                  onChanged: (value) {
                    if (value != null) onChanged(true);
                  },
                  activeColor: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate(
        effects:
            AnimationEffectConstants
                .usualAnimationEffects['summaryCardAnimation']
                ?.effectsBuilder,
      ),
    );
  }
}
