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
    final opties = List<String>.from(json['opties'] as List);
    // Backend stuurt juist_antwoord als string (bv. "A. ..."), zet om naar index
    final juistRaw = json['juist_antwoord'] ?? json['juistAntwoord'];
    int juistIndex = 0;
    if (juistRaw is int) {
      juistIndex = juistRaw;
    } else if (juistRaw is String) {
      juistIndex = opties.indexWhere((o) => o == juistRaw);
      if (juistIndex < 0) juistIndex = 0;
    }
    return Question(
      vraag: json['vraag'] as String,
      opties: opties,
      juistAntwoord: juistIndex,
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
