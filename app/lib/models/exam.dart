import 'must_know_item.dart';
import 'question.dart';

class Exam {
  final String id;
  final String subject;
  final DateTime date;
  final String leerstofText;
  final String oldTestText;
  final String knownAlready;
  final List<MustKnowItem> mustKnow;
  final List<String> canSkip;
  final List<Question> questions;

  const Exam({
    required this.id,
    required this.subject,
    required this.date,
    required this.leerstofText,
    this.oldTestText = '',
    this.knownAlready = '',
    this.mustKnow = const [],
    this.canSkip = const [],
    this.questions = const [],
  });

  Exam copyWith({
    List<MustKnowItem>? mustKnow,
    List<String>? canSkip,
    List<Question>? questions,
  }) =>
      Exam(
        id: id,
        subject: subject,
        date: date,
        leerstofText: leerstofText,
        oldTestText: oldTestText,
        knownAlready: knownAlready,
        mustKnow: mustKnow ?? this.mustKnow,
        canSkip: canSkip ?? this.canSkip,
        questions: questions ?? this.questions,
      );

  bool get isAnalyzed => mustKnow.isNotEmpty;

  int get daysUntil => date.difference(DateTime.now()).inDays;
}
