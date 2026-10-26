import 'package:flutter/material.dart';
import '../models/fish.dart';

class FishAvatar extends StatelessWidget {
  final FishSpecies species;
  final double size;
  final bool showShadow;

  const FishAvatar({
    super.key,
    required this.species,
    this.size = 80,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _getRarityColor(species.rarity).withValues(alpha: 0.3),
            _getRarityColor(species.rarity).withValues(alpha: 0.1),
          ],
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: _getRarityColor(species.rarity).withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          _getFishEmoji(species.suit, species.rarity),
          style: TextStyle(fontSize: size * 0.6),
        ),
      ),
    );
  }

  String _getFishEmoji(FishSuit suit, FishRarity rarity) {
    // All fish icons - only fish emojis
    final Map<FishSuit, Map<FishRarity, String>> fishEmojis = {
      FishSuit.hearts: {
        // Tropical fish
        FishRarity.common: '🐠', // Tropical fish
        FishRarity.uncommon: '🐟', // Regular fish
        FishRarity.rare: '🐡', // Blowfish
        FishRarity.epic: '🦈', // Shark
        FishRarity.elite: '🐠', // Tropical fish
        FishRarity.legend: '🐡', // Blowfish
        FishRarity.mythic: '🐠', // Tropical fish
      },
      FishSuit.spades: {
        // Ocean/Deep sea fish
        FishRarity.common: '🐟', // Regular fish
        FishRarity.uncommon: '🐟', // Fish
        FishRarity.rare: '🐋', // Whale
        FishRarity.epic: '🦈', // Shark
        FishRarity.elite: '🐟', // Fish
        FishRarity.legend: '🐋', // Whale
        FishRarity.mythic: '🐋', // Whale
      },
      FishSuit.diamonds: {
        // Cold water fish
        FishRarity.common: '🐟', // Fish
        FishRarity.uncommon: '🐟', // Fish
        FishRarity.rare: '🐡', // Blowfish
        FishRarity.epic: '🐟', // Fish
        FishRarity.elite: '🐡', // Blowfish
        FishRarity.legend: '🦈', // Shark
        FishRarity.mythic: '🐋', // Whale
      },
      FishSuit.clubs: {
        // Mystery fish
        FishRarity.common: '🐟', // Fish
        FishRarity.uncommon: '🐟', // Fish
        FishRarity.rare: '🐡', // Blowfish
        FishRarity.epic: '🐟', // Fish
        FishRarity.elite: '🐠', // Tropical fish
        FishRarity.legend: '🦈', // Shark
        FishRarity.mythic: '🐋', // Whale
      },
    };

    return fishEmojis[suit]?[rarity] ?? '🐠';
  }

  Color _getRarityColor(FishRarity rarity) {
    switch (rarity) {
      case FishRarity.common:
        return Colors.grey;
      case FishRarity.uncommon:
        return Colors.green;
      case FishRarity.rare:
        return Colors.blue;
      case FishRarity.epic:
        return Colors.purple;
      case FishRarity.elite:
        return Colors.pink;
      case FishRarity.legend:
        return Colors.orange;
      case FishRarity.mythic:
        return Colors.amber;
    }
  }
}

class FishCard extends StatelessWidget {
  final FishSpecies species;
  final VoidCallback? onTap;

  const FishCard({
    super.key,
    required this.species,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getRarityColor(species.rarity).withValues(alpha: 0.2),
              _getRarityColor(species.rarity).withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getRarityColor(species.rarity).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FishAvatar(
              species: species,
              size: 70,
            ),
            const SizedBox(height: 8),
            Text(
              species.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(FishRarity rarity) {
    switch (rarity) {
      case FishRarity.common:
        return Colors.grey;
      case FishRarity.uncommon:
        return Colors.green;
      case FishRarity.rare:
        return Colors.blue;
      case FishRarity.epic:
        return Colors.purple;
      case FishRarity.elite:
        return Colors.pink;
      case FishRarity.legend:
        return Colors.orange;
      case FishRarity.mythic:
        return Colors.amber;
    }
  }
}
