import 'decoration.dart';

enum TankType {
  freshwater,
  tropical,
  deepSea,
  crystal,
  legendary;

  String get displayName {
    switch (this) {
      case TankType.freshwater:
        return 'Freshwater Tank';
      case TankType.tropical:
        return 'Tropical Tank';
      case TankType.deepSea:
        return 'Deep Sea Tank';
      case TankType.crystal:
        return 'Crystal Tank';
      case TankType.legendary:
        return 'Legendary Tank';
    }
  }

  int get capacity {
    switch (this) {
      case TankType.freshwater:
        return 6;
      case TankType.tropical:
        return 8;
      case TankType.deepSea:
        return 10;
      case TankType.crystal:
        return 12;
      case TankType.legendary:
        return 16;
    }
  }

  int get unlockCost {
    switch (this) {
      case TankType.freshwater:
        return 0;
      case TankType.tropical:
        return 500;
      case TankType.deepSea:
        return 2000;
      case TankType.crystal:
        return 5000;
      case TankType.legendary:
        return 10000;
    }
  }
}

class Tank {
  final String id;
  final TankType type;
  final List<String> fishIds;
  final List<AquariumDecoration> decorations;
  bool isUnlocked;

  Tank({
    required this.id,
    required this.type,
    List<String>? fishIds,
    List<AquariumDecoration>? decorations,
    this.isUnlocked = false,
  })  : fishIds = fishIds ?? [],
        decorations = decorations ?? [];

  bool get isFull => fishIds.length >= type.capacity;
  int get availableSpace => type.capacity - fishIds.length;

  void addFish(String fishId) {
    if (!isFull) {
      fishIds.add(fishId);
    }
  }

  void removeFish(String fishId) {
    fishIds.remove(fishId);
  }

  void addAquariumDecoration(AquariumDecoration decoration) {
    decorations.add(decoration);
  }

  void removeAquariumDecoration(String decorationId) {
    decorations.removeWhere((d) => d.id == decorationId);
  }

  int get totalHappinessBonus {
    return decorations.fold(0, (sum, d) => sum + d.type.happinessBonus);
  }
}
