enum AquariumDecorationType {
  rock,
  plant,
  coral,
  shell,
  castle,
  treasure;

  String get displayName {
    switch (this) {
      case AquariumDecorationType.rock:
        return 'Rock';
      case AquariumDecorationType.plant:
        return 'Plant';
      case AquariumDecorationType.coral:
        return 'Coral';
      case AquariumDecorationType.shell:
        return 'Shell';
      case AquariumDecorationType.castle:
        return 'Castle';
      case AquariumDecorationType.treasure:
        return 'Treasure';
    }
  }

  String get emoji {
    switch (this) {
      case AquariumDecorationType.rock:
        return '🪨';
      case AquariumDecorationType.plant:
        return '🌿';
      case AquariumDecorationType.coral:
        return '🪸';
      case AquariumDecorationType.shell:
        return '🐚';
      case AquariumDecorationType.castle:
        return '🏰';
      case AquariumDecorationType.treasure:
        return '💎';
    }
  }

  int get cost {
    switch (this) {
      case AquariumDecorationType.rock:
        return 20;
      case AquariumDecorationType.plant:
        return 30;
      case AquariumDecorationType.coral:
        return 50;
      case AquariumDecorationType.shell:
        return 40;
      case AquariumDecorationType.castle:
        return 200;
      case AquariumDecorationType.treasure:
        return 500;
    }
  }

  int get happinessBonus {
    switch (this) {
      case AquariumDecorationType.rock:
        return 2;
      case AquariumDecorationType.plant:
        return 5;
      case AquariumDecorationType.coral:
        return 8;
      case AquariumDecorationType.shell:
        return 5;
      case AquariumDecorationType.castle:
        return 15;
      case AquariumDecorationType.treasure:
        return 25;
    }
  }
}

class AquariumDecoration {
  final String id;
  final AquariumDecorationType type;
  final double x;
  final double y;

  AquariumDecoration({
    required this.id,
    required this.type,
    this.x = 0,
    this.y = 0,
  });

  AquariumDecoration copyWith({
    String? id,
    AquariumDecorationType? type,
    double? x,
    double? y,
  }) {
    return AquariumDecoration(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
