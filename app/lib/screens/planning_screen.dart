import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/exam.dart';
import '../providers/exam_provider.dart';
import '../theme/app_theme.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  int _tabIndex = 1; // 0=Dag, 1=Week, 2=Maand

  // Maandag van de huidige week
  DateTime get _weekStart {
    final now = DateTime.now();
    final diff = now.weekday - 1; // weekday: 1=ma, 7=zo
    final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: diff));
    return monday;
  }

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  static const _dayLabels = ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'];
  static const _timeSlots = ['Ochtend', 'Middag', 'Avond'];

  String _formatShort(DateTime d) {
    return '${d.day}/${d.month}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Dag- en maandweergave komen binnenkort.',
          style: GoogleFonts.hankenGrotesk(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
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
          'Planning',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<ExamProvider>(
          builder: (context, provider, _) {
            final exams = provider.exams;

            // Dummy exam als er geen zijn
            final List<Exam> displayExams = exams.isEmpty
                ? [
                    Exam(
                      id: 'dummy',
                      subject: 'Voorbeeld Toets',
                      date: _weekStart.add(const Duration(days: 3)),
                    ),
                  ]
                : exams;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tab-schakelaar
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: ['Dag', 'Week', 'Maand'].asMap().entries.map(
                        (entry) {
                          final i = entry.key;
                          final label = entry.value;
                          final selected = _tabIndex == i;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (i != 1) {
                                  _showComingSoon();
                                } else {
                                  setState(() => _tabIndex = i);
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.accent
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: Text(
                                    label,
                                    style: GoogleFonts.hankenGrotesk(
                                      fontSize: 13,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: selected
                                          ? AppColors.background
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),

                // Sectielabel
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: Text(
                    'DEZE WEEK',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),

                // Week-grid
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      children: [
                        // Header rij met dagnamen
                        Row(
                          children: [
                            // Lege cel voor tijdlabel
                            const SizedBox(width: 52),
                            ..._weekDays.asMap().entries.map((entry) {
                              final i = entry.key;
                              final day = entry.value;
                              final isToday = _isSameDay(day, DateTime.now());
                              return Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      _dayLabels[i],
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: isToday
                                            ? AppColors.accent
                                            : AppColors.textMuted,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatShort(day),
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 9,
                                        color: isToday
                                            ? AppColors.accent
                                            : AppColors.ignore,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),

                        // Tijdblokken
                        ..._timeSlots.map((slot) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 52,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Text(
                                      slot,
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 8,
                                        color: AppColors.ignore,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                ),
                                ..._weekDays.map((day) {
                                  // Vind toetsen die op deze dag vallen
                                  final toetsen = displayExams
                                      .where((e) => _isSameDay(e.date, day))
                                      .toList();

                                  // Toon toets alleen in 'Ochtend'-blok om te voorkomen
                                  // dat het in alle drie de blokken verschijnt
                                  final showExam =
                                      slot == 'Ochtend' && toetsen.isNotEmpty;

                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: showExam
                                          ? _ExamBlock(exam: toetsen.first)
                                          : _EmptyBlock(),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
    );
  }
}

class _ExamBlock extends StatelessWidget {
  final Exam exam;

  const _ExamBlock({required this.exam});

  @override
  Widget build(BuildContext context) {
    final color = exam.isUrgent ? AppColors.urgent : AppColors.accent;
    return Container(
      height: 52,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            exam.subject,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (exam.isUrgent)
            Text(
              '${exam.daysUntil}d',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 8,
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}
