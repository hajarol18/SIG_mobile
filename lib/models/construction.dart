enum ConstructionType {
  residentiel,
  commercial,
  industriel,
  administratif,
  educatif,
  sanitaire,
  autre;

  String get label {
    switch (this) {
      case ConstructionType.residentiel:
        return 'Résidentiel';
      case ConstructionType.commercial:
        return 'Commercial';
      case ConstructionType.industriel:
        return 'Industriel';
      case ConstructionType.administratif:
        return 'Administratif';
      case ConstructionType.educatif:
        return 'Éducatif';
      case ConstructionType.sanitaire:
        return 'Sanitaire';
      case ConstructionType.autre:
        return 'Autre';
    }
  }

  int get colorValue {
    switch (this) {
      case ConstructionType.residentiel:
        return 0xFFFF0000; // Rouge
      case ConstructionType.commercial:
        return 0xFF0000FF; // Bleu
      case ConstructionType.industriel:
        return 0xFFFFA500; // Orange
      case ConstructionType.administratif:
        return 0xFF008000; // Vert
      case ConstructionType.educatif:
        return 0xFFFF00FF; // Magenta
      case ConstructionType.sanitaire:
        return 0xFF00FFFF; // Cyan
      case ConstructionType.autre:
        return 0xFF808080; // Gris
    }
  }
}

class Construction {
  final int? id;
  final String adresse;
  final String? contact;
  final ConstructionType type;
  final String geometry; // JSON string des coordonnées du polygone
  final DateTime dateCreation;
  final String? notes;

  Construction({
    this.id,
    required this.adresse,
    this.contact,
    required this.type,
    required this.geometry,
    required this.dateCreation,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adresse': adresse,
      'contact': contact,
      'type': type.name,
      'geometry': geometry,
      'date_creation': dateCreation.toIso8601String(),
      'notes': notes,
    };
  }

  factory Construction.fromMap(Map<String, dynamic> map) {
    return Construction(
      id: map['id'] as int?,
      adresse: map['adresse'] as String,
      contact: map['contact'] as String?,
      type: ConstructionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ConstructionType.autre,
      ),
      geometry: map['geometry'] as String,
      dateCreation: DateTime.parse(map['date_creation'] as String),
      notes: map['notes'] as String?,
    );
  }
}
