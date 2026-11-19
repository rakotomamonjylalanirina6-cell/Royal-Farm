
class EggRecord {
  final String id;
  final String henId;
  final DateTime date;
  final int eggCount;
  final String notes;

  EggRecord({
    required this.id,
    required this.henId,
    required this.date,
    required this.eggCount,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'henId': henId,
      'date': date.toIso8601String(),
      'eggCount': eggCount,
      'notes': notes,
    };
  }

  factory EggRecord.fromMap(Map<String, dynamic> map) {
    return EggRecord(
      id: map['id'] ?? '',
      henId: map['henId'] ?? '',
      date: DateTime.parse(map['date']),
      eggCount: map['eggCount'] ?? 0,
      notes: map['notes'] ?? '',
    );
  }
}
