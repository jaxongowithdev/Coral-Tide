import 'fish.dart';
import 'tank.dart';

class GameData {
  int coins;
  int level;
  int experience;
  List<FishSpecies> discoveredFish;
  List<Fish> myFish;
  List<Tank> tanks;
  int playTime;

  GameData({
    this.coins = 100,
    this.level = 1,
    this.experience = 0,
    List<FishSpecies>? discoveredFish,
    List<Fish>? myFish,
    List<Tank>? tanks,
    this.playTime = 0,
  })  : discoveredFish = discoveredFish ?? [],
        myFish = myFish ?? [],
        tanks = tanks ?? [
          Tank(
            id: 'tank_1',
            type: TankType.freshwater,
            isUnlocked: true,
          ),
        ];

  int get experienceToNextLevel => level * 100;

  double get experienceProgress => experience / experienceToNextLevel;

  int get collectionPercentage {
    return (discoveredFish.length * 100 / 52).round();
  }

  void addCoins(int amount) {
    coins += amount;
  }

  void spendCoins(int amount) {
    coins = (coins - amount).clamp(0, coins);
  }

  void addExperience(int amount) {
    experience += amount;
    while (experience >= experienceToNextLevel) {
      experience -= experienceToNextLevel;
      level++;
    }
  }

  void discoverFish(FishSpecies species) {
    if (!discoveredFish.any((f) => f.id == species.id)) {
      discoveredFish.add(species);
      addExperience(species.rarityValue);
    }
  }

  void addFish(Fish fish) {
    myFish.add(fish);
  }

  Tank? get activeTank => tanks.firstWhere((t) => t.isUnlocked);
}
