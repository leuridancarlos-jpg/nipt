class Question {
  final String vraag;
  final List<String> opties;
  final String juistAntwoord;

  const Question({
    required this.vraag,
    required this.opties,
    required this.juistAntwoord,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        vraag: json['vraag'] as String,
        opties: List<String>.from(json['opties'] as List),
        juistAntwoord: json['juist_antwoord'] as String,
      );

  Map<String, dynamic> toJson() => {
        'vraag': vraag,
        'opties': opties,
        'juist_antwoord': juistAntwoord,
      };
}
