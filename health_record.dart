
class HealthRecord {
  final String id;
  final String birdId;
  final String type;
  final String symptoms;
  final String diagnosis;
  final String medicine;
  final String dosage;
  final String duration;
  final DateTime date;
  final DateTime? nextDate;
  final String result;
  final String notes;

  HealthRecord({
    required this.id,
    required this.birdId,
    required this.type,
    this.symptoms = '',
    this.diagnosis = '',
    this.medicine = '',
    this.dosage = '',
    this.duration = '',
    required this.date,
    this.nextDate,
    this.result = '',
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'birdId': birdId,
      'type': type,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'medicine': medicine,
      'dosage': dosage,
      'duration': duration,
      'date': date.toIso8601String(),
      'nextDate': nextDate?.toIso8601String(),
      'result': result,
      'notes': notes,
    };
  }

  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'] ?? '',
      birdId: map['birdId'] ?? '',
      type: map['type'] ?? '',
      symptoms: map['symptoms'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      medicine: map['medicine'] ?? '',
      dosage: map['dosage'] ?? '',
      duration: map['duration'] ?? '',
      date: DateTime.parse(map['date']),
      nextDate: map['nextDate'] == null
          ? null
          : DateTime.parse(map['nextDate']),
      result: map['result'] ?? '',
      notes: map['notes'] ?? '',
    );
  }
}
