import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/animation_constants.dart';
import '../lead_creation_provider.dart';
import 'sidebar_step_model.dart';

class AddLeadSidebar extends ConsumerWidget {
  final List<SidebarStep> steps;
  final Map<String, AnimationInfo> animationsMap;
  final String? leadId;
  final bool isHorizontal;

  const AddLeadSidebar({
    super.key,
    required this.steps,
    required this.animationsMap,
    this.leadId,
    this.isHorizontal = false,
  });

  // Helper: flattens steps into unique global indices
  int _globalIndexForChild(
    List<SidebarStep> steps,
    int parentIndex,
    int childIndex,
  ) {
    int global = 0;
    for (int i = 0; i < parentIndex; i++) {
      if (steps[i].children != null && steps[i].children!.isNotEmpty) {
        global += steps[i].children!.length;
      } else {
        global += 1;
      }
    }
    return global + childIndex;
  }

  int _globalIndexForFlat(List<SidebarStep> steps, int stepIndex) {
    int global = 0;
    for (int i = 0; i < stepIndex; i++) {
      if (steps[i].children != null && steps[i].children!.isNotEmpty) {
        global += steps[i].children!.length;
      } else {
        global += 1;
      }
    }
    return global;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadState = ref.watch(leadStepProvider); // LeadStepState
    final currentStep = leadState.currentStep; // int
    final isPlanExpanded = leadState.planExpanded;

    Widget content =
        isHorizontal
            ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // Prevent overflow by using min size
                children:
                    steps.asMap().entries.map((entry) {
                      final stepIndex = entry.key;
                      final step = entry.value;

                      if (step.children != null && step.children!.isNotEmpty) {
                        // PLAN (with children)
                        final isPlanActive = step.children!.asMap().keys.any((
                          subIdx,
                        ) {
                          final gIndex = _globalIndexForChild(
                            steps,
                            stepIndex,
                            subIdx,
                          );
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
                          margin: const EdgeInsets.only(right: 12),
                          child: Stack(
                            children: [
                              if (isPlanActive)
                                Positioned(
                                  left: 2,
                                  right: 2,
                                  child: Container(
                                    height: 2.75,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF4338CA,
                                      ).withOpacity(0.8),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize:
                                    MainAxisSize.min, // Minimize vertical space
                                children: [
                                  InkWell(
                                    onTap: () {
                                      final gIndex = _globalIndexForFlat(
                                        steps,
                                        stepIndex,
                                      );
                                      ref
                                          .read(leadStepProvider.notifier)
                                          .goToStep(gIndex);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
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
                                                fontWeight:
                                                    isPlanActive
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color:
                                                    isPlanActive
                                                        ? Colors.white
                                                        : const Color(
                                                          0xFF4338CA,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.15,
                                            ),
                                            child: Text(
                                              step.title,
                                              style: GoogleFonts.inter(
                                                fontSize: 15,
                                                fontWeight:
                                                    isPlanActive
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color:
                                                    isPlanActive
                                                        ? Colors.black
                                                        : const Color(
                                                          0xFF1D2939,
                                                        ),
                                                letterSpacing: 0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            isPlanExpanded
                                                ? Icons.keyboard_arrow_down
                                                : Icons.keyboard_arrow_right,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isPlanExpanded)
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children:
                                            step.children!.asMap().entries.map((
                                              subEntry,
                                            ) {
                                              final subIdx = subEntry.key;
                                              final subStep = subEntry.value;
                                              final gIndex =
                                                  _globalIndexForChild(
                                                    steps,
                                                    stepIndex,
                                                    subIdx,
                                                  );

                                              final isActive =
                                                  gIndex == currentStep;

                                              IconData iconData;
                                              switch (subStep.title) {
                                                case "Select Goal":
                                                  iconData =
                                                      Icons.flag_outlined;
                                                  break;
                                                case "Generate Plan":
                                                  iconData =
                                                      Icons
                                                          .auto_fix_high_outlined;
                                                  break;
                                                case "Select Instructions":
                                                  iconData =
                                                      Icons
                                                          .playlist_add_check_outlined;
                                                  break;
                                                default:
                                                  iconData =
                                                      Icons.circle_outlined;
                                              }

                                              return InkWell(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                        leadStepProvider
                                                            .notifier,
                                                      )
                                                      .goToStep(gIndex);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                  margin: const EdgeInsets.only(
                                                    right: 12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        isActive
                                                            ? const Color(
                                                              0xFF4338CA,
                                                            ).withOpacity(0.1)
                                                            : Colors
                                                                .transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          isActive ? 12 : 4,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        iconData,
                                                        size: 18,
                                                        color:
                                                            isActive
                                                                ? const Color(
                                                                  0xFF4338CA,
                                                                )
                                                                : Colors
                                                                    .grey[600],
                                                      ),
                                                      const SizedBox(width: 8),
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                              maxWidth:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width *
                                                                  0.15,
                                                            ),
                                                        child: Text(
                                                          subStep.title,
                                                          style: GoogleFonts.inter(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                isActive
                                                                    ? FontWeight
                                                                        .w600
                                                                    : FontWeight
                                                                        .w400,
                                                            color:
                                                                isActive
                                                                    ? const Color(
                                                                      0xFF4338CA,
                                                                    )
                                                                    : Colors
                                                                        .grey[700],
                                                            letterSpacing: 0,
                                                          ),
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        // FLAT step
                        final gIndex = _globalIndexForFlat(steps, stepIndex);
                        final isActive = gIndex == currentStep;

                        return Container(
                          decoration: BoxDecoration(
                            color:
                                isActive
                                    ? const Color(0xFF4338CA).withOpacity(0.05)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: const EdgeInsets.only(right: 12),
                          child: Stack(
                            children: [
                              if (isActive)
                                Positioned(
                                  left: 2,
                                  right: 2,
                                  child: Container(
                                    height: 2.75,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF4338CA,
                                      ).withOpacity(0.8),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              InkWell(
                                onTap: () {
                                  ref
                                      .read(leadStepProvider.notifier)
                                      .goToStep(gIndex);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor:
                                            isActive
                                                ? const Color(0xFF4338CA)
                                                : const Color(
                                                  0xFF4338CA,
                                                ).withOpacity(0.1),
                                        child: Text(
                                          step.number.toString(),
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight:
                                                isActive
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color:
                                                isActive
                                                    ? Colors.white
                                                    : const Color(0xFF4338CA),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.15,
                                        ),
                                        child: Text(
                                          step.title,
                                          style: GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight:
                                                isActive
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color: Colors.black87,
                                            letterSpacing: 0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }).toList(),
              ),
            )
            : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    steps.asMap().entries.map((entry) {
                      final stepIndex = entry.key;
                      final step = entry.value;

                      if (step.children != null && step.children!.isNotEmpty) {
                        // PLAN (with children)
                        final isPlanActive = step.children!.asMap().keys.any((
                          subIdx,
                        ) {
                          final gIndex = _globalIndexForChild(
                            steps,
                            stepIndex,
                            subIdx,
                          );
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
                                      color: const Color(
                                        0xFF4338CA,
                                      ).withOpacity(0.8),
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
                                          fontWeight:
                                              isPlanActive
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color:
                                              isPlanActive
                                                  ? Colors.white
                                                  : const Color(0xFF4338CA),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      step.title,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight:
                                            isPlanActive
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color:
                                            isPlanActive
                                                ? Colors.black
                                                : const Color(0xFF1D2939),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        isPlanExpanded
                                            ? Icons.keyboard_arrow_down
                                            : Icons.keyboard_arrow_right,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(leadStepProvider.notifier)
                                            .togglePlanExpanded();
                                      },
                                    ),
                                  ),
                                  if (isPlanExpanded)
                                    ...step.children!.asMap().entries.map((
                                      subEntry,
                                    ) {
                                      final subIdx = subEntry.key;
                                      final subStep = subEntry.value;
                                      final gIndex = _globalIndexForChild(
                                        steps,
                                        stepIndex,
                                        subIdx,
                                      );

                                      final isActive = gIndex == currentStep;

                                      IconData iconData;
                                      switch (subStep.title) {
                                        case "Select Goal":
                                          iconData = Icons.flag_outlined;
                                          break;
                                        case "Generate Plan":
                                          iconData =
                                              Icons.auto_fix_high_outlined;
                                          break;
                                        case "Select Instructions":
                                          iconData =
                                              Icons.playlist_add_check_outlined;
                                          break;
                                        default:
                                          iconData = Icons.circle_outlined;
                                      }

                                      return InkWell(
                                        onTap: () {
                                          ref
                                              .read(leadStepProvider.notifier)
                                              .goToStep(gIndex);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 6,
                                          ),
                                          margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isActive
                                                    ? const Color(
                                                      0xFF4338CA,
                                                    ).withOpacity(0.1)
                                                    : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              isActive ? 12 : 4,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                iconData,
                                                size: 18,
                                                color:
                                                    isActive
                                                        ? const Color(
                                                          0xFF4338CA,
                                                        )
                                                        : Colors.grey[600],
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  subStep.title,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        isActive
                                                            ? FontWeight.w600
                                                            : FontWeight.w400,
                                                    color:
                                                        isActive
                                                            ? const Color(
                                                              0xFF4338CA,
                                                            )
                                                            : Colors.grey[700],
                                                    letterSpacing: 0,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
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
                        final gIndex = _globalIndexForFlat(steps, stepIndex);
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
                                      color: const Color(
                                        0xFF4338CA,
                                      ).withOpacity(0.8),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              InkWell(
                                onTap: () {
                                  ref
                                      .read(leadStepProvider.notifier)
                                      .goToStep(gIndex);
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 12,
                                    backgroundColor:
                                        isActive
                                            ? const Color(0xFF4338CA)
                                            : const Color(
                                              0xFF4338CA,
                                            ).withOpacity(0.1),
                                    child: Text(
                                      step.number.toString(),
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight:
                                            isActive
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color:
                                            isActive
                                                ? Colors.white
                                                : const Color(0xFF4338CA),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    step.title,
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight:
                                          isActive
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color: Colors.black87,
                                      letterSpacing: 0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }).toList(),
              ),
            );

    return Container(
      width:
          isHorizontal
              ? null
              : MediaQuery.of(context).size.width *
                  0.2, // Increased width for desktop
      height: isHorizontal ? null : MediaQuery.of(context).size.height * 0.75,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child:
          isHorizontal
              ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: content,
              )
              : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: content,
              ),
    ).animate(effects: animationsMap['stepTileAnimation']?.effectsBuilder);
  }
}
