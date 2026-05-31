import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/exam.dart';
import '../theme/app_theme.dart';
import 'completion_screen.dart';

class StudySessionScreen extends StatefulWidget {
  final Exam exam;

  const StudySessionScreen({super.key, required this.exam});

  @override
  State<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends State<StudySessionScreen>
    with TickerProviderStateMixin {
  late List<Question> _queue;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _correctCount = 0;
  int _totalAnswered = 0;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;

  @override
  void initState() {
    super.initState();
    _queue = List.from(widget.exam.questions);

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _feedbackScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Question get _currentQuestion => _queue[_currentIndex];

  void _selectAnswer(int index) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      _totalAnswered++;

      if (index == _currentQuestion.juistAntwoord) {
        _correctCount++;
      } else {
        // Fout: vraag komt terug aan einde queue
        _queue.add(_currentQuestion);
      }
    });

    _feedbackController.forward(from: 0);
  }

  void _nextQuestion() {
    if (_currentIndex >= _queue.length - 1) {
      // Klaar
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompletionScreen(
            exam: widget.exam,
            correct: _correctCount,
            total: _totalAnswered,
          ),
        ),
      );
      return;
    }

    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _answered = false;
    });
  }

  Future<bool> _onWillPop() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(
          'Sessie stoppen?',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Je voortgang in deze sessie gaat verloren.',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 14,
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Doorgaan',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Stoppen',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.urgency,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Color _cardColor(int index) {
    if (!_answered) return AppColors.card;
    if (index == _currentQuestion.juistAntwoord) {
      return const Color(0xFF1A3A1A);
    }
    if (index == _selectedAnswer) {
      return const Color(0xFF3A1A1A);
    }
    return AppColors.card;
  }

  Color _borderColor(int index) {
    if (!_answered) return AppColors.border;
    if (index == _currentQuestion.juistAntwoord) {
      return const Color(0xFF3AB73A);
    }
    if (index == _selectedAnswer) {
      return const Color(0xFFB73A3A);
    }
    return AppColors.border;
  }

  Widget? _trailingIcon(int index) {
    if (!_answered) return null;
    if (index == _currentQuestion.juistAntwoord) {
      return const Icon(Icons.check_circle_rounded,
          color: Color(0xFF3AB73A), size: 20);
    }
    if (index == _selectedAnswer) {
      return const Icon(Icons.cancel_rounded,
          color: Color(0xFFB73A3A), size: 20);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIndex + 1) / _queue.length;
    final letters = ['A', 'B', 'C', 'D'];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.close_rounded, color: AppColors.textPrimary),
            onPressed: () async {
              if (await _onWillPop()) {
                if (mounted) Navigator.pop(context);
              }
            },
          ),
          title: Text(
            widget.exam.subject,
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Voortgangsbalk
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.accent,
                        ),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'VRAAG ${_currentIndex + 1} VAN ${_queue.length}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              // Vraag en antwoorden
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  children: [
                    Text(
                      _currentQuestion.vraag,
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ...List.generate(
                      _currentQuestion.opties.length,
                      (i) {
                        final letter = i < letters.length ? letters[i] : '$i';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ScaleTransition(
                            scale: _answered && i == _selectedAnswer
                                ? _feedbackScale
                                : const AlwaysStoppedAnimation(1.0),
                            child: GestureDetector(
                              onTap: () => _selectAnswer(i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: _cardColor(i),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _borderColor(i),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: _borderColor(i),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          letter,
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _answered &&
                                                    i ==
                                                        _currentQuestion
                                                            .juistAntwoord
                                                ? const Color(0xFF3AB73A)
                                                : _answered &&
                                                        i == _selectedAnswer
                                                    ? const Color(0xFFB73A3A)
                                                    : AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _currentQuestion.opties[i],
                                        style: GoogleFonts.hankenGrotesk(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textPrimary,
                                          height: 1.45,
                                        ),
                                      ),
                                    ),
                                    if (_trailingIcon(i) != null) ...[
                                      const SizedBox(width: 8),
                                      _trailingIcon(i)!,
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Volgende knop
              AnimatedOpacity(
                opacity: _answered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedSlide(
                  offset: _answered ? Offset.zero : const Offset(0, 0.3),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: GestureDetector(
                      onTap: _answered ? _nextQuestion : null,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _currentIndex >= _queue.length - 1
                                ? 'Resultaten bekijken'
                                : 'Volgende vraag',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.background,
                            ),
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
