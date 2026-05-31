import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/exam.dart';
import '../models/must_know_item.dart';
import '../models/question.dart';

class ExamProvider extends ChangeNotifier {
  final List<Exam> _exams = [];
  Exam? _selectedExam;
  bool _isLoading = false;
  String? _error;

  List<Exam> get exams => List.unmodifiable(_exams);
  Exam? get selectedExam => _selectedExam;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Exam? get nextExam {
    if (_exams.isEmpty) return null;
    final upcoming = _exams.where((e) => e.date.isAfter(DateTime.now())).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return upcoming.isNotEmpty ? upcoming.first : _exams.last;
  }

  void addExam(Exam exam) {
    _exams.add(exam);
    notifyListeners();
  }

  void selectExam(Exam exam) {
    _selectedExam = exam;
    notifyListeners();
  }

  Future<void> analyzeExam(Exam exam) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Android emulator gebruikt 10.0.2.2 voor localhost; op device gebruik je het LAN-IP
    const baseUrl = 'http://10.0.2.2:8000';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'subject': exam.subject,
          'leerstof_text': exam.leerstofText,
          'old_test_text': exam.oldTestText,
          'known_already': exam.knownAlready,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final analyzed = exam.copyWith(
          mustKnow: (data['must_know'] as List)
              .map((i) => MustKnowItem.fromJson(i as Map<String, dynamic>))
              .toList(),
          canSkip: List<String>.from(data['can_skip'] as List),
          questions: (data['questions'] as List)
              .map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList(),
        );
        final idx = _exams.indexWhere((e) => e.id == exam.id);
        if (idx >= 0) _exams[idx] = analyzed;
        _selectedExam = analyzed;
      } else {
        _error = 'Backend fout: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Kan backend niet bereiken. Zorg dat de server draait.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
