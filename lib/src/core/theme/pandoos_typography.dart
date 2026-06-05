import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pandoos_colors.dart';

class PandoosTypography {
  // Display — used for big hero titles
  static TextStyle display1 = GoogleFonts.outfit(
    fontSize: 36, fontWeight: FontWeight.w800,
    color: PandoosColors.textPrimary, height: 1.1, letterSpacing: -1,
  );
  static TextStyle display2 = GoogleFonts.outfit(
    fontSize: 28, fontWeight: FontWeight.w700,
    color: PandoosColors.textPrimary, height: 1.15, letterSpacing: -0.5,
  );

  // Headings — section titles
  static TextStyle h1 = GoogleFonts.outfit(
    fontSize: 22, fontWeight: FontWeight.w700,
    color: PandoosColors.textPrimary,
  );
  static TextStyle h2 = GoogleFonts.outfit(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: PandoosColors.textPrimary,
  );
  static TextStyle h3 = GoogleFonts.outfit(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: PandoosColors.textPrimary,
  );

  // Body — general content
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 15, fontWeight: FontWeight.w400,
    color: PandoosColors.textPrimary,
  );
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w400,
    color: PandoosColors.textSecondary,
  );
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w400,
    color: PandoosColors.textMuted,
  );

  // Labels
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w600,
    color: PandoosColors.textPrimary, letterSpacing: 0.3,
  );
  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w500,
    color: PandoosColors.textMuted, letterSpacing: 0.5,
  );

  // Caption — metadata like artist name, duration
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: PandoosColors.textSecondary,
  );
}
