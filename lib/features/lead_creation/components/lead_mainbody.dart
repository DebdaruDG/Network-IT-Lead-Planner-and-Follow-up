import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lead_creation_provider.dart';
import '../../../core/utils/animation_constants.dart';

class AddLeadBody extends ConsumerWidget {
  final List<String> titles;
  final List<String> subtitles;
  final List<Widget> stepWidgets;
  final Map<String, AnimationInfo> animationsMap;

  const AddLeadBody({
    super.key,
    required this.titles,
    required this.subtitles,
    required this.stepWidgets,
    required this.animationsMap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(leadStepProvider);

    return Expanded(
      child: Container(
        color: const Color(0xFFF8FAFC),
        margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titles[currentStep],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1D2939),
                letterSpacing: 0.1,
                fontFamily: "Manrope",
              ),
            ).animate(
              effects:
                  AnimationEffectConstants
                      .usualAnimationEffects['summaryCardAnimation']
                      ?.effectsBuilder,
            ),
            const SizedBox(height: 6),
            Text(
              subtitles[currentStep],
              style: const TextStyle(fontSize: 14, color: Color(0xFF667085)),
            ).animate(
              effects:
                  AnimationEffectConstants
                      .usualAnimationEffects['summaryCardAnimation']
                      ?.effectsBuilder,
            ),
            const SizedBox(height: 24),
            Expanded(child: stepWidgets[currentStep]),
          ],
        ),
      ).animate(
        effects: animationsMap['rightContentAnimation']?.effectsBuilder,
      ),
    );
  }
}
