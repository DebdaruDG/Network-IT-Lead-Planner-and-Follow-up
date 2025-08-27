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
  final String? leadId;
  final bool isMobile;
  final bool isTablet;

  const AddLeadBody({
    super.key,
    required this.titles,
    required this.subtitles,
    required this.stepWidgets,
    required this.animationsMap,
    this.leadId,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadState = ref.watch(leadStepProvider);
    final currentStep = leadState.currentStep;

    return Expanded(
      child: Container(
        color: const Color(0xFFF8FAFC),
        margin: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 48,
          vertical: isMobile ? 16 : 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titles[currentStep],
              style: TextStyle(
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1D2939),
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
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                color: const Color(0xFF667085),
              ),
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
