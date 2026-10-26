import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/tank.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

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
                  _buildSection('Aquarium Tanks'),
                  const SizedBox(height: 12),
                  ...TankType.values.map((type) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildTankCard(context, type),
                      )),
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
          Icon(Icons.upgrade, color: Colors.cyan, size: 28),
          SizedBox(width: 12),
          Text(
            'Upgrade',
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

  Widget _buildSection(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTankCard(BuildContext context, TankType type) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        final tank =
            gameProvider.tanks.firstWhere((t) => t.type == type, orElse: () {
          final newTank = Tank(id: 'tank_${type.index}', type: type);
          return newTank;
        });

        final isUnlocked = tank.isUnlocked;
        final canAfford = gameProvider.coins >= type.unlockCost;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getTankColor(type).withValues(alpha: 0.2),
                _getTankColor(type).withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getTankColor(type).withValues(alpha: 0.3),
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
                      color: _getTankColor(type).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTankIcon(type),
                      color: _getTankColor(type),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Capacity: ${type.capacity} fish',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isUnlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Unlocked',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              if (!isUnlocked) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: canAfford
                        ? () => _unlockTank(context, gameProvider, tank)
                        : null,
                    icon: const Icon(Icons.lock_open),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Unlock for '),
                        const Icon(Icons.monetization_on, size: 16),
                        Text(' ${type.unlockCost}'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAfford
                          ? _getTankColor(type)
                          : Colors.grey.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _unlockTank(BuildContext context, GameProvider gameProvider, Tank tank) {
    if (gameProvider.spendCoins(tank.type.unlockCost)) {
      gameProvider.tanks.add(tank);
      tank.isUnlocked = true;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${tank.type.displayName} unlocked!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getTankColor(TankType type) {
    switch (type) {
      case TankType.freshwater:
        return Colors.green;
      case TankType.tropical:
        return Colors.orange;
      case TankType.deepSea:
        return Colors.blue;
      case TankType.crystal:
        return Colors.cyan;
      case TankType.legendary:
        return Colors.purple;
    }
  }

  IconData _getTankIcon(TankType type) {
    switch (type) {
      case TankType.freshwater:
        return Icons.water;
      case TankType.tropical:
        return Icons.wb_sunny;
      case TankType.deepSea:
        return Icons.waves;
      case TankType.crystal:
        return Icons.diamond;
      case TankType.legendary:
        return Icons.star;
    }
  }
}
