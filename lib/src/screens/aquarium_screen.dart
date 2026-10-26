import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/fish.dart';
import '../models/decoration.dart';
import '../widgets/animated_fish_widget.dart';
import '../widgets/decoration_widget.dart';
import '../widgets/feed_fish_dialog.dart';

class AquariumScreen extends StatefulWidget {
  const AquariumScreen({super.key});

  @override
  State<AquariumScreen> createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _bubbleController;
  bool _showAquariumDecorationMenu = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _bubbleController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _bubbleController.dispose();
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
      floatingActionButton: _buildFloatingButtons(),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    _buildWaterEffect(),
                    _buildBubbles(),
                    // AquariumDecorations
                    ...activeTank.decorations.asMap().entries.map((entry) {
                      final decoration = entry.value;
                      return AquariumDecorationWidget(
                        key: ValueKey(decoration.id),
                        decoration: decoration,
                        onDragEnd: (x, y) {
                          final gameProvider = Provider.of<GameProvider>(
                            context,
                            listen: false,
                          );
                          gameProvider.updateAquariumDecorationPosition(
                            activeTank.id,
                            decoration.id,
                            x,
                            y,
                          );
                        },
                        onTap: () {
                          _showRemoveDecorationDialog(
                            activeTank.id,
                            decoration,
                          );
                        },
                      );
                    }),
                    // Animated fish
                    if (myFish.isNotEmpty)
                      ...myFish.map((fish) {
                        return AnimatedFishWidget(
                          key: ObjectKey(fish),
                          fish: fish,
                          containerSize: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          onTap: () => _showFishDetails(fish),
                        );
                      })
                    else
                      _buildEmptyState(),
                    _buildTankInfo(activeTank, myFish.length),
                  ],
                );
              },
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

  Widget _buildBubbles() {
    return AnimatedBuilder(
      animation: _bubbleController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: BubblePainter(_bubbleController.value),
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

  Widget _buildTankInfo(dynamic tank, int fishCount) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.black.withValues(alpha: 0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.cyan.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tank.type.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (tank.totalHappinessBonus > 0)
                  Text(
                    'Happiness +${tank.totalHappinessBonus}%',
                    style: TextStyle(
                      color: Colors.green.shade300,
                      fontSize: 11,
                    ),
                  ),
              ],
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

  Widget _buildFloatingButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showAquariumDecorationMenu) ...[
          _buildAquariumDecorationButton(AquariumDecorationType.plant),
          const SizedBox(height: 8),
          _buildAquariumDecorationButton(AquariumDecorationType.rock),
          const SizedBox(height: 8),
          _buildAquariumDecorationButton(AquariumDecorationType.coral),
          const SizedBox(height: 8),
          _buildAquariumDecorationButton(AquariumDecorationType.shell),
          const SizedBox(height: 8),
          _buildAquariumDecorationButton(AquariumDecorationType.castle),
          const SizedBox(height: 8),
          _buildAquariumDecorationButton(AquariumDecorationType.treasure),
          const SizedBox(height: 16),
        ],
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _showAquariumDecorationMenu = !_showAquariumDecorationMenu;
            });
          },
          backgroundColor: Colors.cyan,
          child: Icon(
            _showAquariumDecorationMenu ? Icons.close : Icons.add_circle,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAquariumDecorationButton(AquariumDecorationType type) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        final canAfford = gameProvider.coins >= type.cost;
        return FloatingActionButton.small(
          onPressed: canAfford
              ? () {
                  gameProvider.buyAquariumDecoration(type);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${type.emoji} ${type.displayName} added!'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              : null,
          backgroundColor:
              canAfford ? Colors.blue : Colors.grey.withValues(alpha: 0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(type.emoji, style: const TextStyle(fontSize: 20)),
              Text(
                '${type.cost}',
                style: const TextStyle(fontSize: 8, color: Colors.white),
              ),
            ],
          ),
        );
      },
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

  void _showRemoveDecorationDialog(
    String tankId,
    AquariumDecoration decoration,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D2942),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Remove ${decoration.type.displayName}?',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'Do you want to remove this decoration from your aquarium?',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.cyan)),
          ),
          TextButton(
            onPressed: () {
              final gameProvider =
                  Provider.of<GameProvider>(context, listen: false);
              gameProvider.removeAquariumDecoration(tankId, decoration.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${decoration.type.emoji} ${decoration.type.displayName} removed'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
        final y = yOffset +
            10 * (i + 1) * (0.5 + 0.5 * (animation + x / size.width));
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

class BubblePainter extends CustomPainter {
  final double animation;

  BubblePainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final x = (size.width / 5) * i + 20;
      final y = size.height - (animation * size.height + i * 50) % size.height;
      canvas.drawCircle(Offset(x, y), 3 + i.toDouble(), paint);
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) =>
      animation != oldDelegate.animation;
}
