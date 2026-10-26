enum FishRarity {
  common,
  uncommon,
  rare,
  epic,
  elite,
  legend,
  mythic;

  String get displayName {
    switch (this) {
      case FishRarity.common:
        return 'Common';
      case FishRarity.uncommon:
        return 'Uncommon';
      case FishRarity.rare:
        return 'Rare';
      case FishRarity.epic:
        return 'Epic';
      case FishRarity.elite:
        return 'Elite';
      case FishRarity.legend:
        return 'Legend';
      case FishRarity.mythic:
        return 'Mythic';
    }
  }
}

enum FishSuit {
  hearts,
  spades,
  diamonds,
  clubs;

  String get symbol {
    switch (this) {
      case FishSuit.hearts:
        return '♥';
      case FishSuit.spades:
        return '♠';
      case FishSuit.diamonds:
        return '♦';
      case FishSuit.clubs:
        return '♣';
    }
  }

  String get habitat {
    switch (this) {
      case FishSuit.hearts:
        return 'Tropical';
      case FishSuit.spades:
        return 'Ocean';
      case FishSuit.diamonds:
        return 'Cold Water';
      case FishSuit.clubs:
        return 'Mystery';
    }
  }
}

class FishSpecies {
  final String id;
  final String name;
  final String assetPath;
  final FishRarity rarity;
  final FishSuit suit;
  final String description;
  final int coinValue;

  const FishSpecies({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.rarity,
    required this.suit,
    required this.description,
    required this.coinValue,
  });

  static FishRarity getRarityFromCard(String cardName) {
    if (cardName.startsWith('2_') ||
        cardName.startsWith('3_') ||
        cardName.startsWith('4_')) {
      return FishRarity.common;
    } else if (cardName.startsWith('5_') ||
        cardName.startsWith('6_') ||
        cardName.startsWith('7_') ||
        cardName.startsWith('8_')) {
      return FishRarity.uncommon;
    } else if (cardName.startsWith('9_') || cardName.startsWith('10_')) {
      return FishRarity.rare;
    } else if (cardName.startsWith('jack_')) {
      return FishRarity.epic;
    } else if (cardName.startsWith('queen_')) {
      return FishRarity.elite;
    } else if (cardName.startsWith('king_')) {
      return FishRarity.legend;
    } else if (cardName.startsWith('ace_')) {
      return FishRarity.mythic;
    }
    return FishRarity.common;
  }

  static FishSuit getSuitFromCard(String cardName) {
    if (cardName.contains('hearts')) {
      return FishSuit.hearts;
    } else if (cardName.contains('spades')) {
      return FishSuit.spades;
    } else if (cardName.contains('diamonds')) {
      return FishSuit.diamonds;
    } else {
      return FishSuit.clubs;
    }
  }

  static String getFishNameFromCard(String cardName) {
    final suit = getSuitFromCard(cardName);
    final rarity = getRarityFromCard(cardName);

    final Map<String, Map<FishRarity, String>> fishNames = {
      'hearts': {
        FishRarity.common: 'Clownfish',
        FishRarity.uncommon: 'Butterflyfish',
        FishRarity.rare: 'Angelfish',
        FishRarity.epic: 'Parrotfish',
        FishRarity.elite: 'Rainbow Fish',
        FishRarity.legend: 'Golden Tang',
        FishRarity.mythic: 'Golden Coral Fish',
      },
      'spades': {
        FishRarity.common: 'Blue Snapper',
        FishRarity.uncommon: 'Sea Bass',
        FishRarity.rare: 'Tuna',
        FishRarity.epic: 'Marlin',
        FishRarity.elite: 'Swordfish',
        FishRarity.legend: 'King Whale',
        FishRarity.mythic: 'Ocean Guardian',
      },
      'diamonds': {
        FishRarity.common: 'Silver Trout',
        FishRarity.uncommon: 'Arctic Char',
        FishRarity.rare: 'Crystal Carp',
        FishRarity.epic: 'Ice Pike',
        FishRarity.elite: 'Frost Salmon',
        FishRarity.legend: 'Ice Shark',
        FishRarity.mythic: 'Frozen Leviathan',
      },
      'clubs': {
        FishRarity.common: 'Glowfish',
        FishRarity.uncommon: 'Ghost Fish',
        FishRarity.rare: 'Moonfish',
        FishRarity.epic: 'Shadow Eel',
        FishRarity.elite: 'Galaxy Fish',
        FishRarity.legend: 'Void Dragon',
        FishRarity.mythic: 'Ancient Sea Beast',
      },
    };

    final suitKey = suit == FishSuit.hearts
        ? 'hearts'
        : suit == FishSuit.spades
            ? 'spades'
            : suit == FishSuit.diamonds
                ? 'diamonds'
                : 'clubs';

    return fishNames[suitKey]?[rarity] ?? 'Unknown Fish';
  }

  int get rarityValue {
    switch (rarity) {
      case FishRarity.common:
        return 10;
      case FishRarity.uncommon:
        return 25;
      case FishRarity.rare:
        return 50;
      case FishRarity.epic:
        return 100;
      case FishRarity.elite:
        return 200;
      case FishRarity.legend:
        return 500;
      case FishRarity.mythic:
        return 1000;
    }
  }
}

class Fish {
  final FishSpecies species;
  int growth;
  int hunger;
  int happiness;

  Fish({
    required this.species,
    this.growth = 0,
    this.hunger = 100,
    this.happiness = 100,
  });

  bool get isBaby => growth < 33;
  bool get isYoung => growth >= 33 && growth < 66;
  bool get isAdult => growth >= 66;

  String get growthStage {
    if (isBaby) return 'Baby';
    if (isYoung) return 'Young';
    return 'Adult';
  }

  void feed() {
    hunger = 100;
    growth = (growth + 10).clamp(0, 100);
    happiness = (happiness + 5).clamp(0, 100);
  }

  void update() {
    hunger = (hunger - 1).clamp(0, 100);
    if (hunger < 30) {
      happiness = (happiness - 2).clamp(0, 100);
    }
  }

  // Calculate sell price based on growth and happiness
  int get sellPrice {
    final basePrice = species.coinValue;

    // Growth multiplier
    double growthMultiplier = 0.5; // Baby
    if (isAdult) {
      growthMultiplier = 2.0; // Adult = 2x
    } else if (isYoung) {
      growthMultiplier = 1.2; // Young = 1.2x
    }

    // Happiness bonus
    double happinessBonus = 1.0;
    if (happiness > 80) {
      happinessBonus = 1.3; // +30% if very happy
    } else if (happiness > 50) {
      happinessBonus = 1.1; // +10% if happy
    }

    final finalPrice = (basePrice * growthMultiplier * happinessBonus).round();
    return finalPrice;
  }
}
