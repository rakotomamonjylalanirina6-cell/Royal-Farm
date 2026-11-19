
class Bird {
  final String id;
  final String name;
  final String breed;
  final String gender;
  final DateTime birthDate;
  final DateTime entryDate;
  final String fatherId;
  final String motherId;
  final String photoPath;
  final String notes;

  Bird({
    required this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.birthDate,
    required this.entryDate,
    this.fatherId = '',
    this.motherId = '',
    this.photoPath = '',
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
      'entryDate': entryDate.toIso8601String(),
      'fatherId': fatherId,
      'motherId': motherId,
      'photoPath': photoPath,
      'notes': notes,
    };
  }

  factory Bird.fromMap(Map<String, dynamic> map) {
    return Bird(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      breed: map['breed'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: DateTime.parse(map['birthDate']),
      entryDate: DateTime.parse(map['entryDate']),
      fatherId: map['fatherId'] ?? '',
      motherId: map['motherId'] ?? '',
      photoPath: map['photoPath'] ?? '',
      notes: map['notes'] ?? '',
    );
  }
}
