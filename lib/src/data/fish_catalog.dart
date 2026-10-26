import '../models/fish.dart';

class FishCatalog {
  static final List<FishSpecies> allFish = _generateAllFish();

  static List<FishSpecies> _generateAllFish() {
    final List<String> cardAssets = [
      '2_of_hearts.svg',
      '3_of_hearts.svg',
      '4_of_hearts.svg',
      '5_of_hearts.svg',
      '6_of_hearts.svg',
      '7_of_hearts.svg',
      '8_of_hearts.svg',
      '9_of_hearts.svg',
      '10_of_hearts.svg',
      'jack_of_hearts.svg',
      'queen_of_hearts.svg',
      'king_of_hearts.svg',
      'ace_of_hearts.svg',
      '2_of_spades.svg',
      '3_of_spades.svg',
      '4_of_spades.svg',
      '5_of_spades.svg',
      '6_of_spades.svg',
      '7_of_spades.svg',
      '8_of_spades.svg',
      '9_of_spades.svg',
      '10_of_spades.svg',
      'jack_of_spades.svg',
      'queen_of_spades.svg',
      'king_of_spades.svg',
      'ace_of_spades.svg',
      '2_of_diamonds.svg',
      '3_of_diamonds.svg',
      '4_of_diamonds.svg',
      '5_of_diamonds.svg',
      '6_of_diamonds.svg',
      '7_of_diamonds.svg',
      '8_of_diamonds.svg',
      '9_of_diamonds.svg',
      '10_of_diamonds.svg',
      'jack_of_diamonds.svg',
      'queen_of_diamonds.svg',
      'king_of_diamonds.svg',
      'ace_of_diamonds.svg',
      '2_of_clubs.svg',
      '3_of_clubs.svg',
      '4_of_clubs.svg',
      '5_of_clubs.svg',
      '6_of_clubs.svg',
      '7_of_clubs.svg',
      '8_of_clubs.svg',
      '9_of_clubs.svg',
      '10_of_clubs.svg',
      'jack_of_clubs.svg',
      'queen_of_clubs.svg',
      'king_of_clubs.svg',
      'ace_of_clubs.svg',
    ];

    return cardAssets.map((asset) {
      final rarity = FishSpecies.getRarityFromCard(asset);
      final suit = FishSpecies.getSuitFromCard(asset);
      final name = FishSpecies.getFishNameFromCard(asset);
      final description = _getDescription(suit, rarity);

      return FishSpecies(
        id: asset.replaceAll('.svg', ''),
        name: name,
        assetPath: 'packages/aquarium_master/assets/cards/$asset',
        rarity: rarity,
        suit: suit,
        description: description,
        coinValue: rarity.index * 10 + 10,
      );
    }).toList();
  }

  static String _getDescription(FishSuit suit, FishRarity rarity) {
    final habitatDesc = {
      FishSuit.hearts: 'Found in warm tropical waters near coral reefs.',
      FishSuit.spades: 'Roams the deep ocean waters.',
      FishSuit.diamonds: 'Thrives in cold, icy waters.',
      FishSuit.clubs: 'A mysterious species rarely seen.',
    };

    return '${habitatDesc[suit]} ${rarity.displayName} rarity.';
  }

  static List<FishSpecies> getFishBySuit(FishSuit suit) {
    return allFish.where((fish) => fish.suit == suit).toList();
  }

  static List<FishSpecies> getFishByRarity(FishRarity rarity) {
    return allFish.where((fish) => fish.rarity == rarity).toList();
  }

  static FishSpecies? getFishById(String id) {
    try {
      return allFish.firstWhere((fish) => fish.id == id);
    } catch (e) {
      return null;
    }
  }
}
