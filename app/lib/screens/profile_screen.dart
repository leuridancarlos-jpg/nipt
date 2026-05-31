import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 24,
        title: Text(
          'Profiel',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            // Avatar + naam
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        'L',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Leerling',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'leerling@nipt.app',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Nipt Pro card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Nipt Pro',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'BINNENKORT',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Unlock streaks, herinneringen, kalenderintegratie en meer. School wordt een systeem.',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Binnenkort sectie
            Text(
              'BINNENKORT',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 12),

            ..._comingFeatures.map((f) => _FeatureTile(feature: f)),

            const SizedBox(height: 40),

            // Versienummer
            Center(
              child: Text(
                'Nipt v1.0.0',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: AppColors.ignore,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _comingFeatures = [
    _Feature(
      icon: Icons.notifications_none_rounded,
      title: 'Herinneringen',
      description: 'Slimme meldingen voor aankomende toetsen.',
    ),
    _Feature(
      icon: Icons.local_fire_department_outlined,
      title: 'Streaks',
      description: 'Bouw een reeks leerdagen op.',
    ),
    _Feature(
      icon: Icons.calendar_month_outlined,
      title: 'Kalender-koppeling',
      description: 'Toetsen direct in je agenda.',
    ),
    _Feature(
      icon: Icons.group_outlined,
      title: 'School-breed toetsen delen',
      description: 'Deel en ontvang toetsen van klasgenoten.',
    ),
  ];
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;

  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _FeatureTile extends StatelessWidget {
  final _Feature feature;

  const _FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            feature.icon,
            color: AppColors.ignore,
            size: 20,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  feature.description,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 12,
                    color: AppColors.ignore,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'BINNENKORT',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: AppColors.ignore,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
