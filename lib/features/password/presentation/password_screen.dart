import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final List<String> _playerNames = [
    'Lionel Messi',
    'Cristiano Ronaldo',
    'Neymar Jr',
    'Kylian Mbappé',
    'Mohamed Salah',
    'Robert Lewandowski',
    'Kevin De Bruyne',
    'Virgil van Dijk',
    'Luka Modrić',
    'Erling Haaland',
  ];

  final List<bool> _revealedBoxes = List.generate(10, (index) => false);
  int _currentPlayerIndex = 0;

  @override
  void initState() {
    super.initState();
    _resetGrid();
  }

  void _resetGrid() {
    setState(() {
      _revealedBoxes.fillRange(0, 10, false);
      _currentPlayerIndex = 0;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleBox(int index) {
    if (!_revealedBoxes[index]) {
      setState(() {
        _revealedBoxes[index] = true;
      });
      HapticFeedback.lightImpact();
    }
  }

  String _getPlayerName(int index) {
    return _playerNames[index];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.darkPitch,
      appBar: AppBar(
        title: const Text('Password Challenge'),
        backgroundColor: AppColors.darkPitch,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/categories'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight * 0.9,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInstructions(),
                const SizedBox(height: 24),
                _buildGrid(),
                const SizedBox(height: 32),
                _buildNewPlayersButton(),
                const SizedBox(height: 32),
                _buildProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Icon(
            Icons.lock,
            color: AppColors.gameOnGreen,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            'Password Challenge',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gameOnGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap on the numbered boxes to reveal the player names. Guess the password by identifying the pattern!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.lightGrey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final crossAxisCount =
    MediaQuery.of(context).size.width > 600 ? 3 : 2; // Responsive grid
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.brightGold.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildGridBox(index + 1);
        },
      ),
    );
  }

  Widget _buildGridBox(int number) {
    final index = number - 1;
    final isRevealed = _revealedBoxes[index];

    return GestureDetector(
      onTap: () => _toggleBox(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: isRevealed
              ? AppColors.cardGradient
              : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.brightGold,
              AppColors.brightGold.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRevealed
                ? AppColors.grey.withOpacity(0.3)
                : AppColors.brightGold,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isRevealed
                  ? Colors.black.withOpacity(0.2)
                  : AppColors.brightGold.withOpacity(0.3),
              blurRadius: isRevealed ? 4 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isRevealed
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                color: AppColors.gameOnGreen,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                _getPlayerName(index),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gameOnGreen,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
              : Text(
            '$number',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewPlayersButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _resetGrid,
        icon: const Icon(Icons.refresh),
        label: const Text(
          'لاعبين جدد',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gameOnGreen,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final revealedCount = _revealedBoxes.where((revealed) => revealed).length;
    final progress = revealedCount / 10;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$revealedCount/10',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.gameOnGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.grey.withOpacity(0.3),
            valueColor:
            AlwaysStoppedAnimation<Color>(AppColors.gameOnGreen),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            progress == 1.0
                ? 'All players revealed! Great job!'
                : 'Keep revealing to find the pattern!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.lightGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
