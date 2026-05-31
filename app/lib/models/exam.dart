import 'must_know_item.dart';
import 'question.dart';

class Exam {
  final String id;
  final String subject;
  final DateTime date;
  final String leerstofText;
  final String oldTestText;
  final List<String> knownAlready;
  final List<MustKnowItem> mustKnow;
  final List<String> canSkip;
  final List<Question> questions;

  const Exam({
    required this.id,
    required this.subject,
    required this.date,
    this.leerstofText = '',
    this.oldTestText = '',
    this.knownAlready = const [],
    this.mustKnow = const [],
    this.canSkip = const [],
    this.questions = const [],
  });

  Exam copyWith({
    String? id,
    String? subject,
    DateTime? date,
    String? leerstofText,
    String? oldTestText,
    List<String>? knownAlready,
    List<MustKnowItem>? mustKnow,
    List<String>? canSkip,
    List<Question>? questions,
  }) {
    return Exam(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      date: date ?? this.date,
      leerstofText: leerstofText ?? this.leerstofText,
      oldTestText: oldTestText ?? this.oldTestText,
      knownAlready: knownAlready ?? this.knownAlready,
      mustKnow: mustKnow ?? this.mustKnow,
      canSkip: canSkip ?? this.canSkip,
      questions: questions ?? this.questions,
    );
  }

  int get daysUntil {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final examDay = DateTime(date.year, date.month, date.day);
    return examDay.difference(today).inDays;
  }

  bool get isUrgent => daysUntil <= 3;

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as String,
      subject: json['subject'] as String,
      date: DateTime.parse(json['date'] as String),
      leerstofText: json['leerstofText'] as String? ?? '',
      oldTestText: json['oldTestText'] as String? ?? '',
      knownAlready: List<String>.from(json['knownAlready'] as List? ?? []),
      mustKnow: (json['mustKnow'] as List? ?? [])
          .map((e) => MustKnowItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      canSkip: List<String>.from(json['canSkip'] as List? ?? []),
      questions: (json['questions'] as List? ?? [])
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'date': date.toIso8601String(),
      'leerstofText': leerstofText,
      'oldTestText': oldTestText,
      'knownAlready': knownAlready,
      'mustKnow': mustKnow.map((e) => e.toJson()).toList(),
      'canSkip': canSkip,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}
