import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/animation_constants.dart';
import '../lead_creation_provider.dart';

class AddLeadSidebar extends ConsumerWidget {
  final List<String> steps;
  final Map<String, AnimationInfo> animationsMap;

  const AddLeadSidebar({
    super.key,
    required this.steps,
    required this.animationsMap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(leadStepProvider);

    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Journey',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: "Manrope",
                color: Color(0xFF1D2939),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final isActive = index == currentStep;
                final isCompleted = index < currentStep;

                return InkWell(
                  onTap: () {
                    ref.read(leadStepProvider.notifier).goToStep(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isActive
                              ? const Color(0xFF4338CA).withOpacity(0.05)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        if (isActive)
                          Positioned(
                            top: 2,
                            bottom: 2,
                            child: Container(
                              width: 2.75,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4338CA).withOpacity(0.8),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  color:
                                      isActive
                                          ? const Color(0xFF4338CA)
                                          : isCompleted
                                          ? const Color(
                                            0xFF4338CA,
                                          ).withOpacity(0.1)
                                          : Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    color:
                                        isActive
                                            ? Colors.white
                                            : const Color(0xFF4338CA),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                steps[index],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isActive
                                          ? Colors.black
                                          : Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lead Context (mock)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Manrope",
                    color: Color(0xFF1D2939),
                    letterSpacing: 0.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Company, Role, Notes can live here.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Manrope",
                    color: Colors.grey.shade700,
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(effects: animationsMap['stepTileAnimation']?.effectsBuilder);
  }
}
