class MustKnowItem {
  final String titel;
  final String status;

  const MustKnowItem({required this.titel, required this.status});

  factory MustKnowItem.fromJson(Map<String, dynamic> json) => MustKnowItem(
        titel: json['titel'] as String,
        status: json['status'] as String,
      );

  Map<String, dynamic> toJson() => {'titel': titel, 'status': status};
}
