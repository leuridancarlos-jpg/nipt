import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/exam.dart';
import '../theme/app_theme.dart';

class CompletionScreen extends StatefulWidget {
  final Exam exam;
  final int correct;
  final int total;

  const CompletionScreen({
    super.key,
    required this.exam,
    required this.correct,
    required this.total,
  });

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();

    final durations = [
      const Duration(milliseconds: 600),
      const Duration(milliseconds: 600),
      const Duration(milliseconds: 600),
      const Duration(milliseconds: 500),
    ];

    _controllers = durations
        .map((d) => AnimationController(vsync: this, duration: d))
        .toList();

    _fades = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();

    _slides = _controllers.map((c) {
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut));
    }).toList();

    _runAnimations();
  }

  Future<void> _runAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 120 + i * 180));
      if (mounted) _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  String get _scoreLabel {
    final pct = widget.total == 0 ? 0 : widget.correct / widget.total;
    if (pct >= 0.9) return 'Uitstekend.';
    if (pct >= 0.7) return 'Goed gedaan.';
    if (pct >= 0.5) return 'Bijna.';
    return 'Blijven oefenen.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 3),

              // Grote tekst
              FadeTransition(
                opacity: _fades[0],
                child: SlideTransition(
                  position: _slides[0],
                  child: Text(
                    'School gedaan.',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.05,
                      letterSpacing: -1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Subtekst
              FadeTransition(
                opacity: _fades[1],
                child: SlideTransition(
                  position: _slides[1],
                  child: Text(
                    'Lock in op je business.',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Score
              FadeTransition(
                opacity: _fades[2],
                child: SlideTransition(
                  position: _slides[2],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.correct}/${widget.total} CORRECT',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _scoreLabel,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 15,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 4),

              // Knop
              FadeTransition(
                opacity: _fades[3],
                child: SlideTransition(
                  position: _slides[3],
                  child: GestureDetector(
                    onTap: () {
                      // Terug naar root (AppShell)
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.textPrimary,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Sluiten',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
