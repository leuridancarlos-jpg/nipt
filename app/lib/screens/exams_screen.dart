import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/exam.dart';
import '../providers/exam_provider.dart';
import '../theme/app_theme.dart';
import 'add_exam_screen.dart';
import 'exam_detail_screen.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

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
        titleSpacing: 24,
        title: Text(
          'Toetsen',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExamScreen()),
          );
        },
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      body: SafeArea(
        child: Consumer<ExamProvider>(
          builder: (context, provider, _) {
            if (provider.exams.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildList(context, provider.exams);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📖', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 20),
            Text(
              'Nog geen toetsen',
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Voeg je eerste toets toe en Nipt filtert wat écht telt.',
              textAlign: TextAlign.center,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddExamScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.28),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Toets toevoegen',
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Exam> exams) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      itemCount: exams.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final exam = exams[i];
        return _ExamCard(
          exam: exam,
          formatDate: _formatDate,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExamDetailScreen(exam: exam),
              ),
            );
          },
        );
      },
    );
  }
}

class _ExamCard extends StatelessWidget {
  final Exam exam;
  final String Function(DateTime) formatDate;
  final VoidCallback onTap;

  const _ExamCard({
    required this.exam,
    required this.formatDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateColor = exam.isUrgent ? AppColors.urgency : AppColors.textMuted;
    final analyzed = exam.mustKnow.isNotEmpty || exam.canSkip.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: exam.isUrgent ? AppColors.urgency.withOpacity(0.4) : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.subject,
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(exam.date),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: dateColor,
                      letterSpacing: 0.6,
                    ),
                  ),
                  if (exam.isUrgent) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${exam.daysUntil == 0 ? "Vandaag!" : exam.daysUntil == 1 ? "Morgen!" : "${exam.daysUntil} dagen"}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: AppColors.urgency,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: analyzed
                        ? AppColors.accent.withOpacity(0.12)
                        : AppColors.border.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: analyzed
                          ? AppColors.accent.withOpacity(0.3)
                          : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    analyzed ? 'Geanalyseerd' : 'Te analyseren',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: analyzed ? AppColors.accent : AppColors.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
