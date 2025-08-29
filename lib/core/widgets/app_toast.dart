import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';

class AppToast {
  static final Color primaryBlue = const Color(0xFF001BCE);

  static void _showToast(
    BuildContext context, {
    required String title,
    String? subtitle,
    required Color bgColor,
    IconData? icon,
  }) {
    final double toastWidth = MediaQuery.of(context).size.width * 0.4;

    showToastWidget(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: toastWidth, minWidth: toastWidth),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      context: context,
      position: StyledToastPosition.top,
      animDuration: const Duration(milliseconds: 500),
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.fade,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );
  }

  /// ✅ Success Toast
  static void success(BuildContext context, String title, {String? subtitle}) {
    _showToast(
      context,
      title: title,
      subtitle: subtitle,
      bgColor: Colors.green[600]!,
      icon: Icons.check_circle,
    );
  }

  /// ❌ Failure Toast
  static void failure(BuildContext context, String title, {String? subtitle}) {
    _showToast(
      context,
      title: title,
      subtitle: subtitle,
      bgColor: Colors.red[600]!,
      icon: Icons.error,
    );
  }

  /// ⚠️ Warning Toast
  static void warning(BuildContext context, String title, {String? subtitle}) {
    _showToast(
      context,
      title: title,
      subtitle: subtitle,
      bgColor: primaryBlue,
      icon: Icons.warning_amber_rounded,
    );
  }
}
