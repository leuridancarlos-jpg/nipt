import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/exam.dart';
import '../theme/app_theme.dart';
import 'study_session_screen.dart';

class ExamDetailScreen extends StatelessWidget {
  final Exam exam;

  const ExamDetailScreen({super.key, required this.exam});

  String _formatDate(DateTime date) {
    const months = [
      'jan', 'feb', 'mrt', 'apr', 'mei', 'jun',
      'jul', 'aug', 'sep', 'okt', 'nov', 'dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.subject,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              _formatDate(exam.date),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: exam.isUrgent ? AppColors.urgency : AppColors.textMuted,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                children: [
                  // DIT MOET JE KENNEN
                  if (exam.mustKnow.isNotEmpty) ...[
                    Text(
                      'DIT MOET JE KENNEN',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: exam.mustKnow.asMap().entries.map((entry) {
                          final item = entry.value;
                          final isLast = entry.key == exam.mustKnow.length - 1;
                          return Padding(
                            padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.titel,
                                    style: GoogleFonts.hankenGrotesk(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Divider
                  if (exam.canSkip.isNotEmpty && exam.mustKnow.isNotEmpty)
                    const Divider(color: AppColors.border, thickness: 1),

                  if (exam.canSkip.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'DIT KAN JE LATEN LIGGEN',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ignore,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: exam.canSkip.asMap().entries.map((entry) {
                          final text = entry.value;
                          final isLast = entry.key == exam.canSkip.length - 1;
                          return Padding(
                            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.ignore,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    text,
                                    style: GoogleFonts.hankenGrotesk(
                                      fontSize: 14,
                                      color: AppColors.ignore,
                                      height: 1.5,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: AppColors.ignore,
                                      decorationThickness: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (exam.mustKnow.isEmpty && exam.canSkip.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Text(
                          'Nog geen analyse beschikbaar.',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 15,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Knop onderaan
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: GestureDetector(
                onTap: exam.questions.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StudySessionScreen(exam: exam),
                          ),
                        );
                      },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: exam.questions.isEmpty
                        ? AppColors.card
                        : AppColors.accent,
                    borderRadius: BorderRadius.circular(14),
                    border: exam.questions.isEmpty
                        ? Border.all(color: AppColors.border)
                        : null,
                    boxShadow: exam.questions.isEmpty
                        ? []
                        : [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.32),
                              blurRadius: 28,
                              offset: const Offset(0, 6),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Text(
                      exam.questions.isEmpty
                          ? 'Geen oefenvragen beschikbaar'
                          : 'Start oefenen (25 min)',
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: exam.questions.isEmpty
                            ? AppColors.textMuted
                            : AppColors.background,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
