import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/meal/meal_model.dart';
import '../../providers/meal/meal_provider.dart';

class MealSwapScreen extends StatefulWidget {
  final int dayNumber;
  final String mealType;
  final Meal currentMeal;

  const MealSwapScreen({
    super.key,
    required this.dayNumber,
    required this.mealType,
    required this.currentMeal,
  });

  @override
  State<MealSwapScreen> createState() => _MealSwapScreenState();
}

class _MealSwapScreenState extends State<MealSwapScreen> {
  String? _selectedMealId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Fetching meals for type: ${widget.mealType}'); // ← ADD
      context.read<MealProvider>().fetchAvailableMeals(
        mealType: widget.mealType,
      );
    });
  }

  String get _mealTypeLabel {
    final map = {
      'BREAKFAST': 'Breakfast',
      'LUNCH': 'Lunch',
      'DINNER': 'Dinner',
      'SNACK': 'Snack',
    };
    return map[widget.mealType] ?? widget.mealType;
  }

  Future<void> _confirmSwap() async {
    if (_selectedMealId == null) return;

    final provider = context.read<MealProvider>();
    final success = await provider.swapMeal(
      dayNumber: widget.dayNumber,
      mealType: widget.mealType,
      newMealId: _selectedMealId!,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true); // return true = swapped
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Meal swapped successfully!'),
          backgroundColor: const Color(0xFFB565A7),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to swap meal'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0F8),
      body: SafeArea(
        child: Column(
          children: [
            // ── header ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB565A7), Color(0xFFE8A0D5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Swap Meal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── current meal ──
                    const Text(
                      'Current Meal',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildCurrentMealCard(),
                    const SizedBox(height: 20),

                    // ── swap arrow ──
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB565A7).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.swap_vert_rounded,
                          color: Color(0xFFB565A7),
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── available meals ──
                    Row(
                      children: [
                        const Text(
                          'Choose Replacement',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB565A7).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _mealTypeLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB565A7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ── meal list ──
                    Consumer<MealProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(
                                color: Color(0xFFB565A7),
                              ),
                            ),
                          );
                        }

                        if (provider.availableMeals.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: Text(
                                'No alternative meals available',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: provider.availableMeals.map((meal) {
                            final isSelected = _selectedMealId == meal.id;
                            final isCurrent = meal.id == widget.currentMeal.id;

                            return GestureDetector(
                              onTap: isCurrent
                                  ? null
                                  : () => setState(
                                      () => _selectedMealId = meal.id,
                                    ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(
                                          0xFFB565A7,
                                        ).withOpacity(0.08)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFB565A7)
                                        : isCurrent
                                        ? Colors.black12
                                        : Colors.transparent,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // icon
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(
                                                0xFFB565A7,
                                              ).withOpacity(0.15)
                                            : const Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.restaurant_outlined,
                                        color: isSelected
                                            ? const Color(0xFFB565A7)
                                            : Colors.black38,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // meal info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  meal.name,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: isSelected
                                                        ? const Color(
                                                            0xFFB565A7,
                                                          )
                                                        : Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              if (isCurrent)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 3,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.06),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'Current',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            meal.description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              if (meal.prepTime != null)
                                                _buildStat(
                                                  Icons.timer_outlined,
                                                  meal.prepTime!,
                                                ),
                                              if (meal.calories != null) ...[
                                                const SizedBox(width: 12),
                                                _buildStat(
                                                  Icons
                                                      .local_fire_department_outlined,
                                                  '${meal.calories} cal',
                                                ),
                                              ],
                                              if (meal.isVeg) ...[
                                                const SizedBox(width: 12),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFE8F5E9,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'Veg',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF4CAF50),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // check icon
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFFB565A7),
                                        size: 22,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 80), // space for button
                  ],
                ),
              ),
            ),

            // ── confirm button ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: const Color(0xFFF5F0F8),
              child: Consumer<MealProvider>(
                builder: (context, provider, _) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: (_selectedMealId == null || provider.isSwapping)
                        ? null
                        : _confirmSwap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B3FA0),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: provider.isSwapping
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.swap_horiz_rounded, size: 18),
                    label: Text(
                      provider.isSwapping ? 'Swapping...' : 'Confirm Swap',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentMealCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB565A7).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFB565A7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant_outlined,
              color: Color(0xFFB565A7),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.currentMeal.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB565A7),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.currentMeal.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    if (widget.currentMeal.prepTime != null)
                      _buildStat(
                        Icons.timer_outlined,
                        widget.currentMeal.prepTime!,
                      ),
                    if (widget.currentMeal.calories != null) ...[
                      const SizedBox(width: 12),
                      _buildStat(
                        Icons.local_fire_department_outlined,
                        '${widget.currentMeal.calories} cal',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.black38),
        const SizedBox(width: 3),
        Text(
          value,
          style: const TextStyle(fontSize: 11, color: Colors.black45),
        ),
      ],
    );
  }
}
