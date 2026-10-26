import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/fish.dart';
import '../widgets/fish_avatar.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1929),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildZoneCard(
                    context,
                    'Coral Reef',
                    'Tropical warm waters',
                    FishSuit.hearts,
                    Colors.pink,
                    Icons.waves,
                  ),
                  const SizedBox(height: 16),
                  _buildZoneCard(
                    context,
                    'Deep Ocean',
                    'Dark mysterious depths',
                    FishSuit.spades,
                    Colors.blue,
                    Icons.water,
                  ),
                  const SizedBox(height: 16),
                  _buildZoneCard(
                    context,
                    'Ice Sea',
                    'Frozen arctic waters',
                    FishSuit.diamonds,
                    Colors.cyan,
                    Icons.ac_unit,
                  ),
                  const SizedBox(height: 16),
                  _buildZoneCard(
                    context,
                    'Hidden Cave',
                    'Ancient underground sea',
                    FishSuit.clubs,
                    Colors.purple,
                    Icons.nights_stay,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          Icon(Icons.explore, color: Colors.cyan, size: 28),
          SizedBox(width: 12),
          Text(
            'Explore',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneCard(
    BuildContext context,
    String name,
    String description,
    FishSuit suit,
    Color color,
    IconData icon,
  ) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        final discovered = gameProvider.getDiscoveredCount(suit);
        final total = gameProvider.getTotalCount(suit);

        return GestureDetector(
          onTap: () => _startExpedition(context, name, suit, color),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: color,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          suit.symbol,
                          style: TextStyle(
                            color: color,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          suit.habitat,
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$discovered/$total discovered',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startExpedition(
    BuildContext context,
    String zoneName,
    FishSuit suit,
    Color color,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExpeditionScreen(
          zoneName: zoneName,
          suit: suit,
          color: color,
        ),
      ),
    );
  }
}

class ExpeditionScreen extends StatefulWidget {
  final String zoneName;
  final FishSuit suit;
  final Color color;

  const ExpeditionScreen({
    super.key,
    required this.zoneName,
    required this.suit,
    required this.color,
  });

  @override
  State<ExpeditionScreen> createState() => _ExpeditionScreenState();
}

class _ExpeditionScreenState extends State<ExpeditionScreen>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  FishSpecies? _caughtFish;
  late AnimationController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1929),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.zoneName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: _caughtFish != null
            ? _buildCaughtFishView()
            : _buildSearchView(),
      ),
    );
  }

  Widget _buildSearchView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isSearching) ...[
            RotationTransition(
              turns: _searchController,
              child: Icon(
                Icons.radar,
                size: 100,
                color: widget.color,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Searching for fish...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 18,
              ),
            ),
          ] else ...[
            Icon(
              Icons.search,
              size: 100,
              color: widget.color.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Ready to explore ${widget.zoneName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: _startSearch,
              icon: const Icon(Icons.search),
              label: const Text('Start Expedition'),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCaughtFishView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FishAvatar(
            species: _caughtFish!,
            size: 200,
          ),
          const SizedBox(height: 32),
          const Text(
            'Fish Caught!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _caughtFish!.name,
            style: const TextStyle(
              color: Colors.cyan,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _getRarityColor(_caughtFish!.rarity)
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _caughtFish!.rarity.displayName,
              style: TextStyle(
                color: _getRarityColor(_caughtFish!.rarity),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _caughtFish!.description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _searchAgain,
                icon: const Icon(Icons.refresh),
                label: const Text('Search Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startSearch() {
    setState(() => _isSearching = true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final gameProvider =
            Provider.of<GameProvider>(context, listen: false);
        final caughtFish = gameProvider.catchRandomFish(widget.suit);

        setState(() {
          _isSearching = false;
          _caughtFish = caughtFish;
        });
      }
    });
  }

  void _searchAgain() {
    setState(() {
      _caughtFish = null;
      _isSearching = false;
    });
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
