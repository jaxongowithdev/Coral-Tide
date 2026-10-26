import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/fish.dart';
import '../models/food.dart';
import '../providers/game_provider.dart';
import 'fish_avatar.dart';

class FeedFishDialog extends StatefulWidget {
  final Fish fish;

  const FeedFishDialog({super.key, required this.fish});

  @override
  State<FeedFishDialog> createState() => _FeedFishDialogState();
}

class _FeedFishDialogState extends State<FeedFishDialog>
    with SingleTickerProviderStateMixin {
  FoodType? selectedFoodType;
  FoodItem? selectedFood;
  late AnimationController _animationController;
  bool _isFeeding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D2942),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          FishAvatar(
            species: widget.fish.species,
            size: 120,
          ),
          const SizedBox(height: 16),
          Text(
            widget.fish.species.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildStats(),
          const SizedBox(height: 16),
          _buildSellInfo(),
          const SizedBox(height: 24),
          const Text(
            'Choose Food',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFoodOptions(),
          if (selectedFoodType != null) ...[
            const SizedBox(height: 16),
            _buildSelectedFoodPreview(),
            const SizedBox(height: 16),
            _buildFeedButton(),
          ],
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          _buildSellButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Growth', widget.fish.growth, Colors.green),
          _buildStatItem('Hunger', widget.fish.hunger, Colors.orange),
          _buildStatItem('Happy', widget.fish.happiness, Colors.pink),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value%',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodOptions() {
    return Row(
      children: [
        Expanded(child: _buildFoodTypeCard(FoodType.basic)),
        const SizedBox(width: 8),
        Expanded(child: _buildFoodTypeCard(FoodType.premium)),
        const SizedBox(width: 8),
        Expanded(child: _buildFoodTypeCard(FoodType.deluxe)),
        const SizedBox(width: 8),
        Expanded(child: _buildFoodTypeCard(FoodType.special)),
      ],
    );
  }

  Widget _buildFoodTypeCard(FoodType type) {
    final isSelected = selectedFoodType == type;
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final canAfford = gameProvider.coins >= type.cost;

    return GestureDetector(
      onTap: canAfford
          ? () {
              setState(() {
                selectedFoodType = type;
                final foods = FoodItem.getAllFood()
                    .where((f) => f.type == type)
                    .toList()
                  ..shuffle();
                selectedFood = foods.first;
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? _getFoodColor(type).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? _getFoodColor(type)
                : canAfford
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _getFoodIcon(type),
              color: canAfford
                  ? _getFoodColor(type)
                  : Colors.grey.withValues(alpha: 0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              type.displayName.split(' ')[0],
              style: TextStyle(
                color: canAfford ? Colors.white : Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on,
                    size: 10,
                    color: canAfford ? Colors.amber : Colors.grey),
                Text(
                  '${type.cost}',
                  style: TextStyle(
                    color: canAfford ? Colors.amber : Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFoodPreview() {
    if (selectedFood == null) return const SizedBox();

    return Column(
      children: [
        Container(
          width: 100,
          height: 140,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getFoodColor(selectedFoodType!)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getFoodColor(selectedFoodType!)
                  .withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: SvgPicture.asset(
            selectedFood!.cardAsset,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Growth +${selectedFoodType!.growthBonus}%',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Happy +${selectedFoodType!.happinessBonus}%',
                style: const TextStyle(
                  color: Colors.pink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedButton() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isFeeding ? null : () => _feedFish(gameProvider),
        icon: const Icon(Icons.restaurant),
        label: Text(_isFeeding ? 'Feeding...' : 'Feed Fish'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _feedFish(GameProvider gameProvider) {
    if (selectedFoodType == null || selectedFood == null) return;

    final cost = selectedFoodType!.cost;
    if (gameProvider.coins < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough coins!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isFeeding = true);
    _animationController.forward();

    // Apply food effects
    widget.fish.hunger = 100;
    widget.fish.growth = (widget.fish.growth + selectedFoodType!.growthBonus)
        .clamp(0, 100);
    widget.fish.happiness =
        (widget.fish.happiness + selectedFoodType!.happinessBonus)
            .clamp(0, 100);

    // Pay for food
    gameProvider.spendCoins(cost);

    // Earn bonus coins based on fish rarity
    final bonus = widget.fish.species.rarityValue ~/ 2;
    gameProvider.addCoins(bonus);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _animationController.reverse();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${widget.fish.species.name} is happy! +$bonus coins'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  Color _getFoodColor(FoodType type) {
    switch (type) {
      case FoodType.basic:
        return Colors.grey;
      case FoodType.premium:
        return Colors.blue;
      case FoodType.deluxe:
        return Colors.purple;
      case FoodType.special:
        return Colors.amber;
    }
  }

  IconData _getFoodIcon(FoodType type) {
    switch (type) {
      case FoodType.basic:
        return Icons.fastfood;
      case FoodType.premium:
        return Icons.restaurant;
      case FoodType.deluxe:
        return Icons.dinner_dining;
      case FoodType.special:
        return Icons.cake;
    }
  }

  Widget _buildSellInfo() {
    final sellPrice = widget.fish.sellPrice;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.sell, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Sell Value',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                '$sellPrice',
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
    );
  }

  Widget _buildSellButton() {
    final sellPrice = widget.fish.sellPrice;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showSellConfirmDialog(),
        icon: const Icon(Icons.sell),
        label: Text('Sell Fish for $sellPrice coins'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showSellConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D2942),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Sell Fish?',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to sell ${widget.fish.species.name}?',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'You will receive:',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.fish.sellPrice}',
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
            const SizedBox(height: 8),
            Text(
              '⚠️ This action cannot be undone!',
              style: TextStyle(
                color: Colors.orange.withValues(alpha: 0.8),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.cyan)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close confirm dialog
              _sellFish();
            },
            child: const Text('Sell', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _sellFish() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final sellPrice = widget.fish.sellPrice;

    // Sell the fish
    gameProvider.sellFish(widget.fish);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.fish.species.name} sold for $sellPrice coins!',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Close the feed dialog
    Navigator.pop(context);
  }
}
