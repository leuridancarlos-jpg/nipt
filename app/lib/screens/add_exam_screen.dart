import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import '../theme/app_theme.dart';
import 'exam_detail_screen.dart';

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({super.key});

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _leerstofController = TextEditingController();
  final _oldTestController = TextEditingController();
  final _knownController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _leerstofController.dispose();
    _oldTestController.dispose();
    _knownController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.card,
      labelStyle: GoogleFonts.hankenGrotesk(
        fontSize: 13,
        color: AppColors.textMuted,
      ),
      hintStyle: GoogleFonts.hankenGrotesk(
        fontSize: 14,
        color: AppColors.ignore,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.urgency, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.urgency, width: 1.5),
      ),
      errorStyle: GoogleFonts.hankenGrotesk(
        fontSize: 12,
        color: AppColors.urgency,
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.background,
              surface: AppColors.card,
              onSurface: AppColors.textPrimary,
              outline: AppColors.border,
            ),
            dialogBackgroundColor: AppColors.card,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'jan', 'feb', 'mrt', 'apr', 'mei', 'jun',
      'jul', 'aug', 'sep', 'okt', 'nov', 'dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kies een toetsdatum.',
            style: GoogleFonts.hankenGrotesk(color: AppColors.textPrimary),
          ),
          backgroundColor: AppColors.card,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppColors.urgency),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final provider = context.read<ExamProvider>();

    final knownAlready = _knownController.text.trim().isEmpty
        ? <String>[]
        : _knownController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();

    await provider.analyzeExam(
      subject: _subjectController.text.trim(),
      date: _selectedDate!,
      leerstofText: _leerstofController.text.trim(),
      oldTestText: _oldTestController.text.trim(),
      knownAlready: knownAlready,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error!,
            style: GoogleFonts.hankenGrotesk(color: AppColors.textPrimary),
          ),
          backgroundColor: AppColors.card,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppColors.urgency),
          ),
        ),
      );
      return;
    }

    final exam = provider.selectedExam;
    if (exam != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ExamDetailScreen(exam: exam)),
      );
    }
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
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Toets toevoegen',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            children: [
              // Vak
              TextFormField(
                controller: _subjectController,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
                decoration: _fieldDecoration('Vak', hint: 'bv. Economie'),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Vul een vak in.' : null,
              ),
              const SizedBox(height: 16),

              // Datum picker
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedDate != null
                          ? AppColors.border
                          : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      _selectedDate == null
                          ? Text(
                              'Toetsdatum kiezen',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 14,
                                color: AppColors.ignore,
                              ),
                            )
                          : Text(
                              _formatDate(_selectedDate!),
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Leerstof
              TextFormField(
                controller: _leerstofController,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  height: 1.55,
                ),
                decoration: _fieldDecoration(
                  'Leerstof',
                  hint: 'Plak hier je leerstof...',
                ),
                maxLines: null,
                minLines: 6,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Voeg leerstof toe.' : null,
              ),
              const SizedBox(height: 16),

              // Oude toets
              TextFormField(
                controller: _oldTestController,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  height: 1.55,
                ),
                decoration: _fieldDecoration(
                  'Oude toets (optioneel)',
                  hint: 'Oude toets van de leerkracht (optioneel)',
                ),
                maxLines: null,
                minLines: 4,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),

              // Wat ken je al
              TextFormField(
                controller: _knownController,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: _fieldDecoration(
                  'Wat ken je al? (optioneel)',
                  hint: 'bv. vraag en aanbod, elasticiteit',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 32),

              // Knop
              GestureDetector(
                onTap: _isLoading ? null : _submit,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: _isLoading
                        ? AppColors.accent.withOpacity(0.6)
                        : AppColors.accent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _isLoading
                        ? []
                        : [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 6),
                            ),
                          ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.background,
                              ),
                            ),
                          )
                        : Text(
                            'Analyseren',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.background,
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
