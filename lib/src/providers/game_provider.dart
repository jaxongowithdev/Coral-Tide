import 'package:flutter/foundation.dart';
import '../models/fish.dart';
import '../models/game_data.dart';
import '../models/tank.dart';
import '../models/decoration.dart';
import '../data/fish_catalog.dart';

class GameProvider extends ChangeNotifier {
  GameData _gameData = GameData();

  GameData get gameData => _gameData;
  int get coins => _gameData.coins;
  int get level => _gameData.level;
  int get experience => _gameData.experience;
  List<FishSpecies> get discoveredFish => _gameData.discoveredFish;
  List<Fish> get myFish => _gameData.myFish;
  List<Tank> get tanks => _gameData.tanks;

  void addCoins(int amount) {
    _gameData.addCoins(amount);
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_gameData.coins >= amount) {
      _gameData.spendCoins(amount);
      notifyListeners();
      return true;
    }
    return false;
  }

  void discoverFish(FishSpecies species) {
    _gameData.discoverFish(species);
    notifyListeners();
  }

  void addFish(Fish fish) {
    _gameData.addFish(fish);
    notifyListeners();
  }

  void feedFish(Fish fish) {
    fish.feed();
    addCoins(fish.species.rarityValue);
    notifyListeners();
  }

  void unlockTank(Tank tank) {
    if (spendCoins(tank.type.unlockCost)) {
      tank.isUnlocked = true;
      notifyListeners();
    }
  }

  FishSpecies? catchRandomFish(FishSuit suit) {
    final fishInSuit = FishCatalog.getFishBySuit(suit);
    if (fishInSuit.isEmpty) return null;

    fishInSuit.shuffle();
    final species = fishInSuit.first;
    discoverFish(species);

    final newFish = Fish(species: species);
    addFish(newFish);

    return species;
  }

  int getDiscoveredCount(FishSuit suit) {
    return discoveredFish.where((f) => f.suit == suit).length;
  }

  int getTotalCount(FishSuit suit) {
    return FishCatalog.getFishBySuit(suit).length;
  }

  bool buyAquariumDecoration(AquariumDecorationType type, {double x = 0, double y = 0}) {
    if (spendCoins(type.cost)) {
      final activeTank = tanks.firstWhere((t) => t.isUnlocked);
      final decoration = AquariumDecoration(
        id: 'deco_${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        x: x,
        y: y,
      );
      activeTank.addAquariumDecoration(decoration);
      notifyListeners();
      return true;
    }
    return false;
  }

  void updateAquariumDecorationPosition(String tankId, String decorationId, double x, double y) {
    final tank = tanks.firstWhere((t) => t.id == tankId);
    final index = tank.decorations.indexWhere((d) => d.id == decorationId);
    if (index != -1) {
      tank.decorations[index] = tank.decorations[index].copyWith(x: x, y: y);
      notifyListeners();
    }
  }

  void removeAquariumDecoration(String tankId, String decorationId) {
    final tank = tanks.firstWhere((t) => t.id == tankId);
    tank.removeAquariumDecoration(decorationId);
    notifyListeners();
  }

  void sellFish(Fish fish) {
    // Add coins from selling
    final price = fish.sellPrice;
    addCoins(price);

    // Remove fish from collection
    _gameData.myFish.remove(fish);

    notifyListeners();
  }
}
