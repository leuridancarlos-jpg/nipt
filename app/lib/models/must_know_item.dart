enum MustKnowStatus { todo, inProgress, done }

class MustKnowItem {
  final String titel;
  final MustKnowStatus status;

  const MustKnowItem({
    required this.titel,
    this.status = MustKnowStatus.todo,
  });

  MustKnowItem copyWith({
    String? titel,
    MustKnowStatus? status,
  }) {
    return MustKnowItem(
      titel: titel ?? this.titel,
      status: status ?? this.status,
    );
  }

  factory MustKnowItem.fromJson(Map<String, dynamic> json) {
    return MustKnowItem(
      titel: json['titel'] as String,
      status: MustKnowStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String? ?? 'todo'),
        orElse: () => MustKnowStatus.todo,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titel': titel,
      'status': status.name,
    };
  }
}
