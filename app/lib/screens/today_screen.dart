import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/focus_card.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> with TickerProviderStateMixin {
  late AnimationController _greetingCtrl;
  late AnimationController _cardCtrl;
  late AnimationController _buttonCtrl;

  late Animation<double> _greetingFade;
  late Animation<Offset> _greetingSlide;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _buttonFade;
  late Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _greetingCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _cardCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _buttonCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _greetingFade = CurvedAnimation(parent: _greetingCtrl, curve: Curves.easeOut);
    _greetingSlide = Tween(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _greetingCtrl, curve: Curves.easeOut));

    _cardFade = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut);
    _cardSlide = Tween(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut));

    _buttonFade = CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeOut);
    _buttonSlide = Tween(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 100), () => _greetingCtrl.forward());
    Future.delayed(const Duration(milliseconds: 250), () => _cardCtrl.forward());
    Future.delayed(const Duration(milliseconds: 400), () => _buttonCtrl.forward());
  }

  @override
  void dispose() {
    _greetingCtrl.dispose();
    _cardCtrl.dispose();
    _buttonCtrl.dispose();
    super.dispose();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Goeiemorgen';
    if (hour < 18) return 'Goeiedag';
    return 'Goeieavond';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamProvider>();
    final exam = provider.nextExam;

    return Scaffold(
      appBar: AppBar(
        title: Text('Nipt', style: GoogleFonts.bricolageGrotesque(
          fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary,
        )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'DEZE WEEK — SCHOOL 2U · BUSINESS 18U',
                style: AppTextStyles.monoMuted,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(
              opacity: _greetingFade,
              child: SlideTransition(
                position: _greetingSlide,
                child: Text(_greeting, style: AppTextStyles.heading1),
              ),
            ),
            const SizedBox(height: 40),
            if (exam == null)
              FadeTransition(
                opacity: _cardFade,
                child: SlideTransition(
                  position: _cardSlide,
                  child: _EmptyState(
                    onAdd: () {},
                  ),
                ),
              )
            else
              FadeTransition(
                opacity: _cardFade,
                child: SlideTransition(
                  position: _cardSlide,
                  child: FocusCard(
                    exam: exam,
                    onStart: () {},
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text('Geen toetsen', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Text('Voeg je eerste toets toe om te beginnen.', style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAdd,
              child: Text('Toets toevoegen', style: AppTextStyles.buttonPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
