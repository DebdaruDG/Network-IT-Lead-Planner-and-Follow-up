import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_routes.dart';
import '../../features/auth/data_handling/auth_view_model.dart';
import 'animation_constants.dart';

class NetworkItAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool showAddLead;
  final List<Widget>? extraActions;

  const NetworkItAppBar({
    super.key,
    required this.title,
    this.showAddLead = true,
    this.extraActions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: const Color(0xFF233B7A),
      actionsPadding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.1,
      ),
      title: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                title.characters.first.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: "Manrope",
                ),
              ),
            ).animate(
              effects:
                  AnimationEffectConstants
                      .usualAnimationEffects['summaryCardAnimation']
                      ?.effectsBuilder,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: "Manrope",
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white,
                letterSpacing: 0.15,
              ),
            ).animate(
              effects:
                  AnimationEffectConstants
                      .usualAnimationEffects['summaryCardAnimation']
                      ?.effectsBuilder,
            ),
          ],
        ),
      ),
      actions: [
        if (showAddLead)
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.15),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final authNotifier = ref.read(authViewModelProvider.notifier);
              authNotifier.resetUIState();
              context.go(AppRoutes.leadCreation);
            },
            child: const Text("+ Add Lead"),
          ),
        if (extraActions != null) ...extraActions!,
        Tooltip(
          message: "Sign out",
          waitDuration: const Duration(milliseconds: 500),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onPressed: () async {
                final authNotifier = ref.read(authViewModelProvider.notifier);
                await authNotifier.signOut();
                authNotifier.resetUIState();
                context.go(AppRoutes.login);
              },
              child: const Row(
                children: [
                  Icon(Icons.logout, size: 18, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    "Sign out",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
