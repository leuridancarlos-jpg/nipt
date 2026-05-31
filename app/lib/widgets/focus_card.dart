import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/exam.dart';
import '../models/must_know_item.dart';
import '../theme/app_theme.dart';

class FocusCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback? onStartPractice;

  const FocusCard({
    super.key,
    required this.exam,
    this.onStartPractice,
  });

  @override
  Widget build(BuildContext context) {
    final dateColor = exam.isUrgent ? AppColors.urgent : AppColors.textMuted;
    final dateLabel = _buildDateLabel();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(dateColor, dateLabel),
          const Divider(color: AppColors.border, height: 1, thickness: 1),
          _buildPromiseText(),
          _buildMustKnowSection(),
          _buildStartButton(),
        ],
      ),
    );
  }

  String _buildDateLabel() {
    final days = exam.daysUntil;
    if (days == 0) return 'VANDAAG';
    if (days == 1) return 'MORGEN';
    if (days < 0) return 'VERLOPEN';
    return 'OVER $days DAGEN';
  }

  Widget _buildHeader(Color dateColor, String dateLabel) {
    final formatter = DateFormat('EEEE d MMMM', 'nl_NL');
    String formattedDate;
    try {
      formattedDate = formatter.format(exam.date);
    } catch (_) {
      formattedDate = DateFormat('d MMM yyyy').format(exam.date);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.subject.toUpperCase(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: exam.isUrgent
                  ? AppColors.urgent.withOpacity(0.15)
                  : AppColors.border,
              borderRadius: BorderRadius.circular(8),
              border: exam.isUrgent
                  ? Border.all(color: AppColors.urgent.withOpacity(0.4), width: 1)
                  : null,
            ),
            child: Text(
              dateLabel,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: dateColor,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromiseText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Text(
        'Vandaag: 25 min en je bent klaar.',
        style: GoogleFonts.hankenGrotesk(
          fontSize: 15,
          color: AppColors.textMuted,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildMustKnowSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WAT TELT VOOR DEZE TOETS',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 12),
          ...exam.mustKnow.map((item) => _buildMustKnowItem(item)),
          const SizedBox(height: 8),
          _buildSkipHint(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMustKnowItem(MustKnowItem item) {
    final isDone = item.status == MustKnowStatus.done;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.only(top: 2, right: 10),
            decoration: BoxDecoration(
              color: isDone ? AppColors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isDone ? AppColors.accent : AppColors.border,
                width: 1.5,
              ),
            ),
            child: isDone
                ? const Icon(Icons.check, size: 12, color: AppColors.background)
                : null,
          ),
          Expanded(
            child: Text(
              item.titel,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 15,
                color: isDone
                    ? AppColors.textMuted
                    : AppColors.textPrimary,
                decoration: isDone ? TextDecoration.lineThrough : null,
                decorationColor: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipHint() {
    if (exam.canSkip.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 10),
            child: Icon(
              Icons.remove,
              size: 16,
              color: AppColors.ignore,
            ),
          ),
          Expanded(
            child: Text(
              '+ de rest kan je laten liggen',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                color: AppColors.ignore,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: GestureDetector(
        onTap: onStartPractice,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Start oefenen  (25 min)',
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.background,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
