import 'package:flutter/material.dart';
import '../widgets/fish_avatar.dart';
import '../widgets/feed_fish_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/fish.dart';

class AquariumScreen extends StatefulWidget {
  const AquariumScreen({super.key});

  @override
  State<AquariumScreen> createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
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
            Expanded(
              child: _buildAquarium(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'My Aquarium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on,
                        color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${gameProvider.coins}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAquarium() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        final activeTank = gameProvider.tanks.firstWhere((t) => t.isUnlocked);
        final myFish = gameProvider.myFish;

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1A4D6F),
                const Color(0xFF0D2942),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.cyan.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                _buildWaterEffect(),
                if (myFish.isEmpty)
                  _buildEmptyState()
                else
                  _buildFishGrid(myFish),
                _buildTankInfo(activeTank, myFish.length),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaterEffect() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: WaterEffectPainter(_waveController.value),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: 80,
            color: Colors.cyan.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Your aquarium is empty',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Go explore to catch fish!',
            style: TextStyle(
              color: Colors.cyan.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFishGrid(List<Fish> myFish) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: myFish.length,
      itemBuilder: (context, index) {
        return _buildFishCard(myFish[index]);
      },
    );
  }

  Widget _buildFishCard(Fish fish) {
    return GestureDetector(
      onTap: () => _showFishDetails(fish),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getRarityColor(fish.species.rarity).withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FishAvatar(
              species: fish.species,
              size: 60,
              showShadow: false,
            ),
            const SizedBox(height: 4),
            Text(
              fish.species.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              fish.growthStage,
              style: TextStyle(
                color: Colors.cyan.shade300,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTankInfo(dynamic tank, int fishCount) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tank.type.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$fishCount / ${tank.type.capacity}',
              style: const TextStyle(
                color: Colors.cyan,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFishDetails(Fish fish) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FeedFishDialog(fish: fish),
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

class WaterEffectPainter extends CustomPainter {
  final double animation;

  WaterEffectPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      final path = Path();
      final yOffset = size.height * 0.3 * (i + 1) + animation * 20;

      path.moveTo(0, yOffset);
      for (double x = 0; x <= size.width; x += 10) {
        final y = yOffset + 10 * (i + 1) *
            (0.5 + 0.5 * (animation + x / size.width));
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(WaterEffectPainter oldDelegate) =>
      animation != oldDelegate.animation;
}
