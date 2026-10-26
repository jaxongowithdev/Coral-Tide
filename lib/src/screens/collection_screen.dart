import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/fish.dart';
import '../data/fish_catalog.dart';
import '../widgets/fish_avatar.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1929),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllTab(),
                  _buildSuitTab(FishSuit.hearts),
                  _buildSuitTab(FishSuit.spades),
                  _buildSuitTab(FishSuit.diamonds),
                  _buildSuitTab(FishSuit.clubs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        final discovered = gameProvider.discoveredFish.length;
        final percentage = (discovered * 100 / 52).round();

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Collection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$discovered',
                              style: const TextStyle(
                                color: Colors.cyan,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              ' / 52',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Species Discovered',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.cyan.withValues(alpha: 0.3),
                        width: 4,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            '$percentage%',
                            style: const TextStyle(
                              color: Colors.cyan,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CircularProgressIndicator(
                          value: discovered / 52,
                          strokeWidth: 4,
                          backgroundColor: Colors.transparent,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.cyan),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicator: BoxDecoration(
          color: Colors.cyan.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.cyan,
        unselectedLabelColor: Colors.white60,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: '♥ Tropical'),
          Tab(text: '♠ Ocean'),
          Tab(text: '♦ Cold'),
          Tab(text: '♣ Mystery'),
        ],
      ),
    );
  }

  Widget _buildAllTab() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: 52,
          itemBuilder: (context, index) {
            final allFish = FishCatalog.allFish;
            final fish = allFish[index];
            final isDiscovered =
                gameProvider.discoveredFish.any((f) => f.id == fish.id);

            return _buildFishCard(fish, isDiscovered);
          },
        );
      },
    );
  }

  Widget _buildSuitTab(FishSuit suit) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        final suitFish = FishCatalog.getFishBySuit(suit);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: suitFish.length,
          itemBuilder: (context, index) {
            final fish = suitFish[index];
            final isDiscovered =
                gameProvider.discoveredFish.any((f) => f.id == fish.id);

            return _buildFishCard(fish, isDiscovered);
          },
        );
      },
    );
  }

  Widget _buildFishCard(FishSpecies fish, bool isDiscovered) {
    return GestureDetector(
      onTap: isDiscovered ? () => _showFishDetails(fish) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isDiscovered
              ? _getRarityColor(fish.rarity).withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDiscovered
                ? _getRarityColor(fish.rarity).withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isDiscovered) ...[
              Expanded(
                child: Center(
                  child: FishAvatar(
                    species: fish,
                    size: 70,
                    showShadow: false,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      fish.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fish.suit.symbol,
                      style: TextStyle(
                        color: _getSuitColor(fish.suit),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Icon(
                Icons.help_outline,
                size: 48,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 8),
              Text(
                '???',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFishDetails(FishSpecies fish) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0D2942),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: FishAvatar(
                species: fish,
                size: 150,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                fish.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRarityColor(fish.rarity)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      fish.rarity.displayName,
                      style: TextStyle(
                        color: _getRarityColor(fish.rarity),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getSuitColor(fish.suit).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${fish.suit.symbol} ${fish.suit.habitat}',
                      style: TextStyle(
                        color: _getSuitColor(fish.suit),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fish.description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Coin Value:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.monetization_on,
                    color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${fish.coinValue}',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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

  Color _getSuitColor(FishSuit suit) {
    switch (suit) {
      case FishSuit.hearts:
        return Colors.pink;
      case FishSuit.spades:
        return Colors.blue;
      case FishSuit.diamonds:
        return Colors.cyan;
      case FishSuit.clubs:
        return Colors.purple;
    }
  }
}
