
class Chick {
  final String id;
  final DateTime hatchDate;
  final String fatherId;
  final String motherId;
  final int maleCount;
  final int femaleCount;
  final int aliveCount;
  final int deadCount;
  final String notes;

  Chick({
    required this.id,
    required this.hatchDate,
    this.fatherId = '',
    this.motherId = '',
    this.maleCount = 0,
    this.femaleCount = 0,
    this.aliveCount = 0,
    this.deadCount = 0,
    this.notes = '',
  });

  int get totalCount => maleCount + femaleCount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hatchDate': hatchDate.toIso8601String(),
      'fatherId': fatherId,
      'motherId': motherId,
      'maleCount': maleCount,
      'femaleCount': femaleCount,
      'aliveCount': aliveCount,
      'deadCount': deadCount,
      'notes': notes,
    };
  }

  factory Chick.fromMap(Map<String, dynamic> map) {
    return Chick(
      id: map['id'] ?? '',
      hatchDate: DateTime.parse(map['hatchDate']),
      fatherId: map['fatherId'] ?? '',
      motherId: map['motherId'] ?? '',
      maleCount: map['maleCount'] ?? 0,
      femaleCount: map['femaleCount'] ?? 0,
      aliveCount: map['aliveCount'] ?? 0,
      deadCount: map['deadCount'] ?? 0,
      notes: map['notes'] ?? '',
    );
  }
}
