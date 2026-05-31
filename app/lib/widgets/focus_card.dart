import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/exam.dart';
import '../theme/app_theme.dart';

class FocusCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback onStart;

  const FocusCard({super.key, required this.exam, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final isUrgent = exam.daysUntil <= 3;
    final dateColor = isUrgent ? AppColors.urgent : AppColors.textMuted;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  exam.subject.toUpperCase(),
                  style: AppTextStyles.label,
                ),
              ),
              Text(
                isUrgent
                    ? exam.daysUntil == 0
                        ? 'VANDAAG'
                        : '${exam.daysUntil}D'
                    : '${exam.daysUntil}D',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: dateColor,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Vandaag: 25 min en je bent klaar.', style: AppTextStyles.promise),
          if (exam.isAnalyzed) ..._buildMustKnow(),
          const SizedBox(height: 24),
          _buildStartButton(),
        ],
      ),
    );
  }

  List<Widget> _buildMustKnow() {
    return [
      const SizedBox(height: 24),
      Text('WAT TELT VOOR DEZE TOETS', style: AppTextStyles.label),
      const SizedBox(height: 12),
      ...exam.mustKnow.take(4).map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(item.titel, style: AppTextStyles.body),
                  ),
                ],
              ),
            ),
          ),
      const SizedBox(height: 4),
      Text('+ de rest kan je laten liggen', style: AppTextStyles.ignore),
    ];
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.25),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onStart,
          child: Text('Start oefenen (25 min)', style: AppTextStyles.buttonPrimary),
        ),
      ),
    );
  }
}
