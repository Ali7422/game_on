import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/challenge_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/riverpod_timer.dart';

class RiskChallengeScreen extends ConsumerStatefulWidget {
  const RiskChallengeScreen({super.key});

  @override
  ConsumerState<RiskChallengeScreen> createState() => _RiskChallengeScreenState();
}

class _RiskChallengeScreenState extends ConsumerState<RiskChallengeScreen> {
  int _activeTeam = 1;
  int _team1Score = 0;
  int _team2Score = 0;

  final Set<String> _doubledCards = {};
  final Set<String> _usedCards = {};
  int? _selectedCategoryIndex;
  int? _selectedButtonIndex;
  bool _isDoubleUsed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(riskTimerProvider.notifier).startTimer();
    });
  }

  final List<String> _categories = const [
    'Football Legends',
    'World Cup Winners',
    'Premier League',
    'Champions League',
  ];

  final List<int> _pointValues = const [5, 10, 20, 40];

  String _cardKey(int categoryIndex, int buttonIndex) => '$categoryIndex-$buttonIndex';

  bool _isCardDoubled(int categoryIndex, int buttonIndex) {
    return _doubledCards.contains(_cardKey(categoryIndex, buttonIndex));
  }

  bool _isCardUsed(int categoryIndex, int buttonIndex) {
    return _usedCards.contains(_cardKey(categoryIndex, buttonIndex));
  }

  void _toggleDoubleCard(int categoryIndex, int buttonIndex) {
    if (_isDoubleUsed && !_isCardDoubled(categoryIndex, buttonIndex)) {
      _showDoubleUsedWarning();
      return;
    }

    final key = _cardKey(categoryIndex, buttonIndex);
    setState(() {
      if (_doubledCards.contains(key)) {
        _doubledCards.remove(key);
        _isDoubleUsed = false;
      } else {
        _doubledCards.clear();
        _doubledCards.add(key);
        _isDoubleUsed = true;
      }
    });
  }

  void _showDoubleUsedWarning() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F0F0F),
        title: const Text('Double Already Used', style: TextStyle(color: Colors.white)),
        content: const Text('You can only use the double option once per game. Remove the current double first to assign it to another question.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onCardTap(int categoryIndex, int buttonIndex) {
    if (_isCardUsed(categoryIndex, buttonIndex)) {
      return;
    }

    setState(() {
      _selectedCategoryIndex = categoryIndex;
      _selectedButtonIndex = buttonIndex;
    });

    showDialog(
      context: context,
      builder: (ctx) {
        final points = _pointValues[buttonIndex];
        final doubled = _isCardDoubled(categoryIndex, buttonIndex);
        return AlertDialog(
          backgroundColor: const Color(0xFF0F0F0F),
          title: Text(_categories[categoryIndex], style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Question for $points points${doubled ? " (x2)" : ""}:',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              Text('Who scored the winning goal in the final?', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              Text('Answer: Example Player', style: const TextStyle(color: Colors.greenAccent)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  void _onCorrectPressed() {
    if (_selectedCategoryIndex == null || _selectedButtonIndex == null) return;
    final cat = _selectedCategoryIndex!;
    final btn = _selectedButtonIndex!;
    int points = _pointValues[btn];
    final wasDoubled = _isCardDoubled(cat, btn);
    if (wasDoubled) points *= 2;

    setState(() {
      if (_activeTeam == 1) {
        _team1Score += points;
      } else {
        _team2Score += points;
      }
      _usedCards.add(_cardKey(cat, btn));

      if (wasDoubled) {
        _doubledCards.remove(_cardKey(cat, btn));
        _isDoubleUsed = false;
      }
      _selectedCategoryIndex = null;
      _selectedButtonIndex = null;
    });
  }
  void _onWrongPressed() {
    if (_selectedCategoryIndex == null || _selectedButtonIndex == null) return;
    final cat = _selectedCategoryIndex!;
    final btn = _selectedButtonIndex!;
    final wasDoubled = _isCardDoubled(cat, btn);

    setState(() {
      _usedCards.add(_cardKey(cat, btn));

      if (wasDoubled) {
        _doubledCards.remove(_cardKey(cat, btn));
        _isDoubleUsed = false;
      }

      // Deselect
      _selectedCategoryIndex = null;
      _selectedButtonIndex = null;
    });
  }

  Widget _buildTimerControlBar(BuildContext context, int timerSeconds, RiskTimerNotifier timerNotifier) {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(riskTimerProvider.notifier);
        final seconds = ref.watch(riskTimerProvider);

        return Container(
          padding: EdgeInsets.all(Responsive.getSpacing(context)),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.gameOnGreen.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                notifier.formattedTime,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: seconds <= 10 ? AppColors.red : AppColors.gameOnGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                children: [
                  _buildTimerButton(
                    icon: notifier.isRunning ? Icons.pause : Icons.play_arrow,
                    onPressed: () {
                      if (notifier.isRunning) {
                        notifier.pauseTimer();
                      } else {
                        notifier.resumeTimer();
                      }
                      setState(() {});
                    },
                    color: AppColors.brightGold,
                  ),
                  _buildTimerButton(
                    icon: Icons.refresh,
                    onPressed: () {
                      notifier.resetTimer();
                      setState(() {});
                    },
                    color: AppColors.red,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildTimerButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0,4))],
        ),
        child: Icon(icon, color: AppColors.black, size: 26),
      ),
    );
  }

  Widget _buildScoreInputFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTeamScoreField(context, 'Team 1', _team1Score, 1),
        ),
        SizedBox(width: Responsive.getSpacing(context)),
        Expanded(
          child: _buildTeamScoreField(context, 'Team 2', _team2Score, 2),
        ),
      ],
    );
  }

  Widget _buildTeamScoreField(BuildContext context, String teamName, int score, int teamNumber) {
    final isActive = _activeTeam == teamNumber;
    return GestureDetector(
      onTap: () {
        setState(() => _activeTeam = teamNumber);
      },
      child: Container(
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        decoration: BoxDecoration(
          color: teamNumber == 1 ? const Color(0xFF1A1A1A) : const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? (teamNumber == 1 ? AppColors.gameOnGreen : AppColors.brightGold)
                : AppColors.grey.withOpacity(0.3),
            width: isActive ? 2.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              teamName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: teamNumber == 1 ? AppColors.gameOnGreen : AppColors.brightGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Responsive.getSpacing(context) * 0.5),
            Text(
              '$score',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: teamNumber == 1 ? AppColors.gameOnGreen : AppColors.brightGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            if (isActive)
              Text('Active', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: Responsive.getSpacing(context),
        mainAxisSpacing: Responsive.getSpacing(context),
      ),
      itemCount: 4,
      itemBuilder: (context, categoryIndex) {
        return _buildCategoryCard(context, categoryIndex);
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, int categoryIndex) {
    final category = _categories[categoryIndex];

    return Container(
      padding: EdgeInsets.all(Responsive.getSpacing(context)),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey.withOpacity(0.3), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0,4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Responsive.getSpacing(context) * 0.5),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildCardButton(context, categoryIndex, 0)), // 5 points
                      const SizedBox(width: 8),
                      Expanded(child: _buildCardButton(context, categoryIndex, 1)), // 10 points
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildCardButton(context, categoryIndex, 2)), // 20 points
                      const SizedBox(width: 8),
                      Expanded(child: _buildCardButton(context, categoryIndex, 3)), // 40 points
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardButton(BuildContext context, int categoryIndex, int buttonIndex) {
    final points = _pointValues[buttonIndex];
    final doubled = _isCardDoubled(categoryIndex, buttonIndex);
    final isUsed = _isCardUsed(categoryIndex, buttonIndex);

    return GestureDetector(
      onTap: () => _onCardTap(categoryIndex, buttonIndex),
      onLongPress: isUsed ? null : () => _toggleDoubleCard(categoryIndex, buttonIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isUsed
              ? AppColors.grey.withOpacity(0.3)
              : (doubled ? AppColors.gameOnGreen : const Color(0xFF2A2A2A)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isUsed
                ? AppColors.grey.withOpacity(0.2)
                : (doubled ? AppColors.gameOnGreen : AppColors.grey.withOpacity(0.3)),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isUsed
                  ? Colors.transparent
                  : (doubled ? AppColors.gameOnGreen.withOpacity(0.25) : Colors.transparent),
              blurRadius: 4,
              offset: const Offset(0,2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '${doubled ? points * 2 : points}',
                style: TextStyle(
                  color: isUsed
                      ? AppColors.grey.withOpacity(0.5)
                      : (doubled ? AppColors.black : AppColors.white),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (doubled && !isUsed)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.brightGold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'x2',
                    style: TextStyle(
                        fontSize: 8, // حجم أصغر
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerControlsAndSummary(BuildContext context) {
    final total = _team1Score + _team2Score;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _onCorrectPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              child: const Text('إجابة صحيحة', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _onWrongPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              child: const Text('إجابة غلط', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.brightGold.withOpacity(0.3), width: 2),
          ),
          child: Column(
            children: [
              Text('Team 1: $_team1Score',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.gameOnGreen, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Team 2: $_team2Score',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.brightGold, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Active Team: $_activeTeam', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.white)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(riskTimerProvider);
    final timerNotifier = ref.read(riskTimerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.darkPitch,
      appBar: AppBar(
        title: const Text('Risk Challenge'),
        backgroundColor: AppColors.darkPitch,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/categories'),
        ),
      ),
      body: ResponsiveContainer(
        child: ResponsivePadding(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: Responsive.getSpacing(context)),
                _buildTimerControlBar(context, timerState, timerNotifier),
                SizedBox(height: Responsive.getSpacing(context) * 2),
                _buildScoreInputFields(context),
                SizedBox(height: Responsive.getSpacing(context) * 2),
                _buildCategoriesGrid(context),
                SizedBox(height: Responsive.getSpacing(context) * 2),
                _buildAnswerControlsAndSummary(context),
                SizedBox(height: Responsive.getSpacing(context) * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}