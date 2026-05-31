import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/exam.dart';
import '../models/must_know_item.dart';
import '../models/question.dart';

class ExamProvider extends ChangeNotifier {
  List<Exam> _exams = [];
  Exam? _selectedExam;
  bool _isLoading = false;
  String? _error;

  List<Exam> get exams => List.unmodifiable(_exams);
  Exam? get selectedExam => _selectedExam;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Exam? get nextExam {
    if (_exams.isEmpty) return null;
    final upcoming = _exams
        .where((e) => e.daysUntil >= 0)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  void addExam(Exam exam) {
    _exams.add(exam);
    _exams.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }

  void removeExam(String id) {
    _exams.removeWhere((e) => e.id == id);
    if (_selectedExam?.id == id) {
      _selectedExam = null;
    }
    notifyListeners();
  }

  void selectExam(Exam exam) {
    _selectedExam = exam;
    notifyListeners();
  }

  void clearSelection() {
    _selectedExam = null;
    notifyListeners();
  }

  void updateMustKnowStatus(String examId, int index, MustKnowStatus status) {
    final examIndex = _exams.indexWhere((e) => e.id == examId);
    if (examIndex == -1) return;

    final exam = _exams[examIndex];
    final updatedMustKnow = List<MustKnowItem>.from(exam.mustKnow);
    if (index < 0 || index >= updatedMustKnow.length) return;

    updatedMustKnow[index] = updatedMustKnow[index].copyWith(status: status);
    _exams[examIndex] = exam.copyWith(mustKnow: updatedMustKnow);

    if (_selectedExam?.id == examId) {
      _selectedExam = _exams[examIndex];
    }
    notifyListeners();
  }

  Future<void> analyzeExam({
    required String subject,
    required DateTime date,
    required String leerstofText,
    required String oldTestText,
    required List<String> knownAlready,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      const baseUrl = 'http://10.0.2.2:8000';
      final response = await http
          .post(
            Uri.parse('$baseUrl/analyze'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'subject': subject,
              'date': date.toIso8601String(),
              'leerstof': leerstofText,
              'old_test': oldTestText,
              'known_already': knownAlready,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final mustKnowRaw = data['must_know'] as List? ?? [];
        final mustKnow = mustKnowRaw
            .map((e) => MustKnowItem(titel: e as String))
            .toList();

        final canSkip = List<String>.from(data['can_skip'] as List? ?? []);

        final questionsRaw = data['questions'] as List? ?? [];
        final questions = questionsRaw
            .map((e) => Question.fromJson(e as Map<String, dynamic>))
            .toList();

        final exam = Exam(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          subject: subject,
          date: date,
          leerstofText: leerstofText,
          oldTestText: oldTestText,
          knownAlready: knownAlready,
          mustKnow: mustKnow,
          canSkip: canSkip,
          questions: questions,
        );

        addExam(exam);
        _selectedExam = exam;
      } else {
        _error = 'Server fout: ${response.statusCode}. Probeer opnieuw.';
      }
    } on Exception catch (e) {
      _error = 'Kon geen verbinding maken. Controleer je internetverbinding.\n$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addDemoExam() {
    final exam = Exam(
      id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
      subject: 'Economie',
      date: DateTime.now().add(const Duration(days: 2)),
      leerstofText: 'Hoofdstuk 4 t/m 7: marktvormen, prijsvorming, elasticiteit.',
      oldTestText: '',
      knownAlready: ['vraag en aanbod', 'consumentensurplus'],
      mustKnow: const [
        MustKnowItem(titel: 'Marktvormen: volkomen, monopolie, oligopolie'),
        MustKnowItem(titel: 'Prijselasticiteit berekenen en interpreteren'),
        MustKnowItem(titel: 'Kruiselingse elasticiteit: substituten vs. complementen'),
        MustKnowItem(titel: 'Break-even analyse met formule'),
      ],
      canSkip: [
        'Historische context van markttheorie',
        'Gedetailleerde wiskunde achter Cournot-model',
        'Internationale handelstheorieën',
      ],
      questions: const [
        Question(
          vraag: 'Wat is de formule voor prijselasticiteit van de vraag?',
          opties: [
            '% verandering prijs / % verandering vraag',
            '% verandering vraag / % verandering prijs',
            'absolute vraagverandering / absolute prijsverandering',
            'prijs × hoeveelheid',
          ],
          juistAntwoord: 1,
        ),
        Question(
          vraag: 'Bij welke markvorm zijn er veel aanbieders van homogene producten?',
          opties: [
            'Monopolie',
            'Oligopolie',
            'Volkomen concurrentie',
            'Monopolistische concurrentie',
          ],
          juistAntwoord: 2,
        ),
      ],
    );
    addExam(exam);
  }
}
