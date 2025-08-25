import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/animation_constants.dart';
import '../lead_creation_provider.dart';
import 'sidebar_step_model.dart';

class AddLeadSidebar extends ConsumerStatefulWidget {
  final List<SidebarStep> steps;
  final Map<String, AnimationInfo> animationsMap;

  const AddLeadSidebar({
    super.key,
    required this.steps,
    required this.animationsMap,
  });

  @override
  ConsumerState<AddLeadSidebar> createState() => _AddLeadSidebarState();
}

class _AddLeadSidebarState extends ConsumerState<AddLeadSidebar> {
  bool planExpanded = true; // default expanded

  // helper: flattens steps into unique global indices
  int _globalIndexForChild(int parentIndex, int childIndex) {
    // parentIndex is the index of the parent in steps
    // all previous parents and steps count
    int global = 0;
    for (int i = 0; i < parentIndex; i++) {
      if (widget.steps[i].children != null &&
          widget.steps[i].children!.isNotEmpty) {
        global += widget.steps[i].children!.length;
      } else {
        global += 1;
      }
    }
    return global + childIndex;
  }

  int _globalIndexForFlat(int stepIndex) {
    int global = 0;
    for (int i = 0; i < stepIndex; i++) {
      if (widget.steps[i].children != null &&
          widget.steps[i].children!.isNotEmpty) {
        global += widget.steps[i].children!.length;
      } else {
        global += 1;
      }
    }
    return global;
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(leadStepProvider);
    final leadNotifier = ref.read(leadStepProvider.notifier);

    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: ListView(
        children:
            widget.steps.asMap().entries.map((entry) {
              final stepIndex = entry.key;
              final step = entry.value;

              if (step.children != null && step.children!.isNotEmpty) {
                // PLAN (with children)
                final isPlanActive = step.children!.asMap().keys.any((subIdx) {
                  final gIndex = _globalIndexForChild(stepIndex, subIdx);
                  return gIndex == currentStep;
                });

                return Container(
                  decoration: BoxDecoration(
                    color:
                        isPlanActive
                            ? const Color(0xFF4338CA).withOpacity(0.05)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      if (isPlanActive)
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  isPlanActive
                                      ? const Color(0xFF4338CA)
                                      : const Color(
                                        0xFF4338CA,
                                      ).withOpacity(0.1),
                              child: Text(
                                step.number.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isPlanActive
                                          ? Colors.white
                                          : const Color(0xFF4338CA),
                                ),
                              ),
                            ),
                            title: Text(
                              step.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color:
                                    isPlanActive
                                        ? Colors.black
                                        : const Color(0xFF1D2939),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                planExpanded
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_right,
                              ),
                              onPressed: () {
                                setState(() {
                                  planExpanded = !planExpanded;
                                });
                              },
                            ),
                          ),
                          if (planExpanded)
                            ...step.children!.asMap().entries.map((subEntry) {
                              final subIdx = subEntry.key;
                              final subStep = subEntry.value;
                              final gIndex = _globalIndexForChild(
                                stepIndex,
                                subIdx,
                              );

                              final isActive = gIndex == currentStep;

                              return InkWell(
                                onTap: () {
                                  ref
                                      .read(leadStepProvider.notifier)
                                      .goToStep(gIndex);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    top: 6,
                                    bottom: 6,
                                  ),
                                  child: Text(
                                    subStep.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          isActive
                                              ? const Color(0xFF4338CA)
                                              : Colors.grey[700],
                                      fontWeight:
                                          isActive
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                // FLAT step
                final gIndex = _globalIndexForFlat(stepIndex);
                final isActive = gIndex == currentStep;

                return Container(
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
                      InkWell(
                        onTap: () {
                          ref.read(leadStepProvider.notifier).goToStep(gIndex);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 12,
                            backgroundColor:
                                isActive
                                    ? const Color(0xFF4338CA)
                                    : const Color(0xFF4338CA).withOpacity(0.1),
                            child: Text(
                              step.number.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color:
                                    isActive
                                        ? Colors.white
                                        : const Color(0xFF4338CA),
                              ),
                            ),
                          ),
                          title: Text(
                            step.title,
                            style: TextStyle(
                              fontSize: 15,
                              color: isActive ? Colors.black : Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }).toList(),
      ),
    ).animate(
      effects: widget.animationsMap['stepTileAnimation']?.effectsBuilder,
    );
  }
}
