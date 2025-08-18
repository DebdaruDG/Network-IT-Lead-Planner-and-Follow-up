import 'package:flutter/material.dart';

class StepUtils {
  Widget backButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: Colors.grey.shade700, width: 0.4),
      ),
      child: const Text(
        "Back",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          fontFamily: 'Roboto',
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget generatePlanButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text(
        "Generate Plan",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget continueButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text(
        "Continue",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget finishButton(VoidCallback onPressed) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1E293B),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
    child: const Text(
      "Finish",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        fontFamily: 'Roboto',
        letterSpacing: 0.6,
      ),
    ),
  );
}
