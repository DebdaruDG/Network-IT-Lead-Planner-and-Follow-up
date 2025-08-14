import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isRequired;
  final bool obscureText;
  final TextEditingController? controller;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isRequired = false,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const themeBlue = Color(0xFF001BCE);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
            children:
                isRequired
                    ? [
                      TextSpan(
                        text: ' *',
                        style: GoogleFonts.poppins(
                          color: Colors.red[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                    : [],
          ),
        ),
        const SizedBox(height: 6),

        // TextField
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFFDADCE0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: themeBlue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
