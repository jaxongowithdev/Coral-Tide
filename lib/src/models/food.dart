enum FoodType {
  basic,
  premium,
  deluxe,
  special;

  String get displayName {
    switch (this) {
      case FoodType.basic:
        return 'Basic Food';
      case FoodType.premium:
        return 'Premium Food';
      case FoodType.deluxe:
        return 'Deluxe Food';
      case FoodType.special:
        return 'Special Food';
    }
  }

  int get cost {
    switch (this) {
      case FoodType.basic:
        return 5;
      case FoodType.premium:
        return 15;
      case FoodType.deluxe:
        return 30;
      case FoodType.special:
        return 50;
    }
  }

  int get growthBonus {
    switch (this) {
      case FoodType.basic:
        return 5;
      case FoodType.premium:
        return 10;
      case FoodType.deluxe:
        return 20;
      case FoodType.special:
        return 30;
    }
  }

  int get happinessBonus {
    switch (this) {
      case FoodType.basic:
        return 5;
      case FoodType.premium:
        return 10;
      case FoodType.deluxe:
        return 15;
      case FoodType.special:
        return 25;
    }
  }
}

class FoodItem {
  final FoodType type;
  final String cardAsset;

  const FoodItem({
    required this.type,
    required this.cardAsset,
  });

  // Map card values to food types
  static FoodType getFoodTypeFromCard(String cardName) {
    if (cardName.startsWith('2_') ||
        cardName.startsWith('3_') ||
        cardName.startsWith('4_') ||
        cardName.startsWith('5_')) {
      return FoodType.basic;
    } else if (cardName.startsWith('6_') ||
        cardName.startsWith('7_') ||
        cardName.startsWith('8_') ||
        cardName.startsWith('9_')) {
      return FoodType.premium;
    } else if (cardName.startsWith('10_') ||
        cardName.startsWith('jack_')) {
      return FoodType.deluxe;
    } else {
      return FoodType.special; // Queen, King, Ace
    }
  }

  static List<FoodItem> getAllFood() {
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
      return FoodItem(
        type: getFoodTypeFromCard(asset),
        cardAsset: 'packages/aquarium_master/assets/cards/$asset',
      );
    }).toList();
  }

  static FoodItem getRandomFood() {
    final allFood = getAllFood();
    allFood.shuffle();
    return allFood.first;
  }
}
