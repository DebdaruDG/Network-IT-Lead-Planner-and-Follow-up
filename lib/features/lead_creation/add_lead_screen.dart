import 'dart:developer' as console;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_routes.dart';
import '../../core/utils/animation_constants.dart';
import '../../core/utils/nav_bar.dart';
import '../auth/data_handling/route_notifier.dart';
import 'components/lead_mainbody.dart';
import 'components/lead_sidebar.dart';
import 'components/sidebar_step_model.dart';
import 'data_handling/lead_provider.dart';
import 'steps/step1_add_lead.dart';
import 'steps/step2_select_goal.dart';
import 'steps/step3_plan_setup.dart';
import 'steps/step4_select_instructions.dart';
import 'steps/step5_plan_steps.dart';
import 'steps/step6_plan_overview.dart';

class AddLeadScreen extends ConsumerStatefulWidget {
  final String? leadId;
  const AddLeadScreen({super.key, this.leadId});

  @override
  ConsumerState<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends ConsumerState<AddLeadScreen> {
  late Map<String, AnimationInfo> animationsMap;

  @override
  void initState() {
    super.initState();
    console.log('lead id - ${widget.leadId}');
    animationsMap = {
      'stepTileAnimation': AnimationInfo(
        effectsBuilder: [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 400),
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 400),
            begin: const Offset(-20.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'rightContentAnimation': AnimationInfo(
        effectsBuilder: [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    };
    if ((widget.leadId ?? '').isNotEmpty) {
      Future.delayed(Duration.zero, () async {
        final leadId = widget.leadId;
        if (leadId != null) {
          await ref.read(leadProvider.notifier).fetchLeadPlans(leadId: leadId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sidebarSteps = [
      SidebarStep(
        title: (widget.leadId ?? '').isEmpty ? "Add Lead" : "Update Lead",
        number: 1,
      ),
      SidebarStep(
        title: "Plan",
        number: 2,
        children: [
          SidebarStep(title: "Select Goal"),
          SidebarStep(title: "Generate Plan"),
          SidebarStep(title: "Select Instructions"),
        ],
      ),
      SidebarStep(title: "Execute Tasks", number: 3),
      SidebarStep(title: "Track Progress", number: 4),
    ];

    final stepWidgets = [
      Step1LeadDetailsForm(leadId: widget.leadId),
      const Step2GoalSelection(),
      const Step3PlanSetup(),
      const Step4Instructions(),
      Step5ExecuteTasks(leadId: widget.leadId),
      const Step6TrackProgress(),
    ];

    final titles = [
      if ((widget.leadId ?? '').isEmpty) "Add a new lead" else "Update Lead",
      "Select a goal",
      "Plan generation",
      "Plan generation",
      "Execute tasks",
      "Track progress",
    ];

    final subtitles = [
      "Start the journey by saving a lead.",
      "What do we want to achieve?",
      "Evenly spaced steps over the chosen duration.",
      "Pick a template for each step.",
      "Email and LinkedIn show 'sent' (simulated). Calls show 'Call Now'",
      "Simple progress and responsive view (mock).",
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth <= 920 && screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFD),
      appBar: NetworkItAppBar(
        title: "NetworkIt",
        showAddLead: false,
        extraActions: [
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final navNotifier = ref.read(routeNotifierProvider.notifier);
              navNotifier.setNavItem(NavItem.dashboard);
              context.go(AppRoutes.dashboard);
            },
            child: const Text("Go Back"),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : MediaQuery.of(context).size.width * 0.1,
          vertical: isMobile ? 16 : MediaQuery.of(context).size.height * 0.05,
        ),
        child:
            isMobile || isTablet
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddLeadSidebar(
                      steps: sidebarSteps,
                      animationsMap: animationsMap,
                      leadId: widget.leadId,
                      isHorizontal: isMobile,
                    ),
                    AddLeadBody(
                      titles: titles,
                      subtitles: subtitles,
                      stepWidgets: stepWidgets,
                      animationsMap: animationsMap,
                      leadId: widget.leadId,
                      isMobile: isMobile,
                      isTablet: isTablet,
                    ),
                  ],
                )
                : Row(
                  children: [
                    AddLeadSidebar(
                      steps: sidebarSteps,
                      animationsMap: animationsMap,
                      leadId: widget.leadId,
                      isHorizontal: false,
                    ),
                    AddLeadBody(
                      titles: titles,
                      subtitles: subtitles,
                      stepWidgets: stepWidgets,
                      animationsMap: animationsMap,
                      leadId: widget.leadId,
                      isMobile: isMobile,
                      isTablet: isTablet,
                    ),
                  ],
                ),
      ),
    );
  }
}
