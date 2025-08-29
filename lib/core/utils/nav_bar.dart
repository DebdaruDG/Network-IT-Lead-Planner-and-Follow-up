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
    final isMobile = MediaQuery.of(context).size.width <= 920;

    return AppBar(
      backgroundColor: const Color(0xFF233B7A),
      actionsPadding: EdgeInsets.only(
        right: isMobile ? 8 : MediaQuery.of(context).size.width * 0.1,
      ),
      title: Container(
        padding: EdgeInsets.only(
          left: isMobile ? 8 : MediaQuery.of(context).size.width * 0.1,
        ),
        child: Row(
          children: [
            // --- Logo/Initial ---
            Container(
              height: isMobile ? 32 : 36,
              width: isMobile ? 32 : 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                title.characters.first.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: isMobile ? 16 : 18,
                  fontFamily: "Manrope",
                ),
              ),
            ).animate(
              effects:
                  AnimationEffectConstants
                      .usualAnimationEffects['summaryCardAnimation']
                      ?.effectsBuilder,
            ),
            if (!isMobile) ...[
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
            ],
            SizedBox(width: isMobile ? 24 : 48),
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
              isMobile: isMobile,
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
              isMobile: isMobile,
            ),
          ],
        ),
      ),
      // --- Right Actions ---
      actions: [
        if (showAddLead && !isMobile)
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
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
        _buildSignOutButton(context, ref, isMobile),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    final themeColor = const Color(0xFF233B7A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 14,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? themeColor.withValues(alpha: 0.01)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: isMobile ? 12 : 14,
                color: isSelected ? Colors.white : Colors.white,
              ),
            ),
            if (isSelected)
              Container(
                height: 2,
                margin: const EdgeInsets.only(top: 8),
                color: Colors.white,
                width: isMobile ? 60 : 80,
              ),
          ],
        ),
      ),
    ).animate(
      effects:
          AnimationEffectConstants
              .usualAnimationEffects['summaryCardAnimation']
              ?.effectsBuilder,
    );
  }

  Widget _buildSignOutButton(
    BuildContext context,
    WidgetRef ref,
    bool isMobile,
  ) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    return Tooltip(
      message: "Sign out",
      waitDuration: const Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16),
        padding: const EdgeInsets.all(8.0),
        child: FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12,
              vertical: isMobile ? 6 : 8,
            ),
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
                  ? SizedBox(
                    height: isMobile ? 14 : 16,
                    width: isMobile ? 14 : 16,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : Icon(
                    Icons.logout,
                    size: isMobile ? 16 : 18,
                    color: Colors.white,
                  ),
              if (!isMobile) ...[
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
