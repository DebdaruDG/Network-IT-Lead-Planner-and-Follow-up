import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/animation_constants.dart';
import '../data_handling/lead_followup_provider.dart';
import '../lead_creation_provider.dart';
import '../step_utils.dart';
import '../../../core/widgets/app_toast.dart';
import '../data_handling/lead_provider.dart';

class Step4Instructions extends ConsumerWidget {
  const Step4Instructions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followupState = ref.watch(followupProvider);
    final leadState = ref.watch(leadProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: templateSelector(
                "Email templates",
                [
                  "Ask for meeting",
                  "Share a news",
                  "comment on company activity",
                ],
                followupState.emailTemplate,
                (value) => ref
                    .read(followupProvider.notifier)
                    .updateEmailTemplate(value),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: templateSelector(
                "LinkedIn templates",
                ["Warm intro", "Insight share", "Value drop"],
                followupState.linkedinTemplate,
                (value) => ref
                    .read(followupProvider.notifier)
                    .updateLinkedinTemplate(value),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: templateSelector(
                "Call talking points",
                [
                  "Wish on an occasion",
                  "Something interesting happened",
                  "Just checking how are you?",
                ],
                followupState.callTalkingPoint,
                (value) => ref
                    .read(followupProvider.notifier)
                    .updateCallTalkingPoint(value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
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
              onPressed: () async {
                final leadId = leadState.leadId;
                if (leadId == null) {
                  AppToast.failure(
                    context,
                    "Generation Failed",
                    subtitle: "Lead ID not found.",
                  );
                  return;
                }

                await ref
                    .read(followupProvider.notifier)
                    .generateFollowup(leadId: leadId);

                final updatedState = ref.read(followupProvider);
                if (updatedState.error == null) {
                  AppToast.success(
                    context,
                    "Follow-up Plan Generated",
                    subtitle: "Proceeding to execution.",
                  );
                  ref.read(leadStepProvider.notifier).nextStep();
                } else {
                  AppToast.failure(
                    context,
                    "Generation Failed",
                    subtitle: updatedState.error!,
                  );
                }
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

  Widget templateSelector(
    String title,
    List<String> options,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF1E293B),
              letterSpacing: 0.25,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1E293B),
                    width: 0.2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E293B)),
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
              value: selectedValue,
              items:
                  options
                      .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                      .toList(),
              onChanged: onChanged,
              hint: Text(
                "Select an option",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              isExpanded: true,
              menuMaxHeight: 200,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Preview placeholder...",
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
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
