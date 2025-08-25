import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/config/app_routes.dart';
import '../../features/auth/data_handling/auth_view_model.dart';
import '../../features/auth/data_handling/route_notifier.dart';
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
    final currentNav = ref.watch(routeNotifierProvider);
    final navNotifier = ref.read(routeNotifierProvider.notifier);

    return AppBar(
      backgroundColor: const Color(0xFF233B7A),
      actionsPadding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.1,
      ),
      title: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
        child: Row(
          children: [
            // --- Logo/Initial ---
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
            const SizedBox(width: 12),
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
            const SizedBox(width: 48),
            // --- Nav Items ---
            _buildNavItem(
              context,
              ref,
              label: "Dashboard",
              isSelected: currentNav == NavItem.dashboard,
              onTap: () {
                navNotifier.setNavItem(NavItem.dashboard);
                context.go(AppRoutes.dashboard);
              },
            ),
            const SizedBox(width: 8),
            _buildNavItem(
              context,
              ref,
              label: "Journey",
              isSelected: currentNav == NavItem.journey,
              onTap: () {
                navNotifier.setNavItem(NavItem.journey);
                context.go(AppRoutes.leadCreation);
              },
            ),
          ],
        ),
      ),

      // --- Right Actions ---
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
              navNotifier.setNavItem(NavItem.journey);
            },
            child: const Text("+ Add Lead"),
          ),
        if (extraActions != null) ...extraActions!,
        _buildSignOutButton(context, ref),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final themeColor = const Color(0xFF233B7A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? themeColor : Colors.white,
          ),
        ),
      ),
    ).animate(
      effects:
          AnimationEffectConstants
              .usualAnimationEffects['summaryCardAnimation']
              ?.effectsBuilder,
    );
  }

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    return Tooltip(
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onPressed:
              isLoading
                  ? null
                  : () async {
                    final authNotifier = ref.read(
                      authViewModelProvider.notifier,
                    );
                    await authNotifier.signOut();
                    authNotifier.resetUIState();
                    context.go(AppRoutes.login);
                  },
          child: Row(
            children: [
              isLoading
                  ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : const Icon(Icons.logout, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              const Text(
                "Sign out",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
