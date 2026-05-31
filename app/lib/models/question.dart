class Question {
  final String vraag;
  final List<String> opties;
  final int juistAntwoord;

  const Question({
    required this.vraag,
    required this.opties,
    required this.juistAntwoord,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      vraag: json['vraag'] as String,
      opties: List<String>.from(json['opties'] as List),
      juistAntwoord: json['juistAntwoord'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vraag': vraag,
      'opties': opties,
      'juistAntwoord': juistAntwoord,
    };
  }
}
