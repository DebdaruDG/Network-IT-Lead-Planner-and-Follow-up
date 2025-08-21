import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/utils/animation_constants.dart';
import '../../step_utils.dart';

class NavigationButtons extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const NavigationButtons({
    super.key,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StepUtils()
            .backButton(onBack)
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          onPressed: onContinue,
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
    );
  }
}
