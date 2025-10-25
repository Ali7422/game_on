import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  int _currentRound = 0;
  bool _isTimerRunning = false;
  int _timerSeconds = 120;
  bool _isAnswerRevealed = false;
  Timer? _timer;

  int _activeTeam = 1;
  // Team 1
  int _team1Streak = 0;
  int _team1CurrentScore = 0;
  int _team1BankedScore = 0;
  // Team 2
  int _team2Streak = 0;
  int _team2CurrentScore = 0;
  int _team2BankedScore = 0;

  static const int _totalQuestions = 12;

  final List<String> _rounds = [
    'Round 1',
    'Round 2',
    'Round 3',
    'Round 4',
    'Round 5',
    'Round 6',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _pauseTimer();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isTimerRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _timerSeconds = 120;
      _isAnswerRevealed = false;
    });
  }

  void _nextRound() {
    if (_currentRound < _rounds.length - 1) {
      setState(() {
        _currentRound++;
        _timerSeconds = 120;
        _isAnswerRevealed = false;
      });
      _startTimer();
    }
  }

  void _previousRound() {
    if (_currentRound > 0) {
      setState(() {
        _currentRound--;
        _timerSeconds = 120;
        _isAnswerRevealed = false;
      });
      _startTimer();
    }
  }

  void _revealAnswer() {
    setState(() {
      _isAnswerRevealed = true;
    });
  }

  void _correctAnswer() {
    setState(() {
      if (_activeTeam == 1) {
        _team1Streak++;
        _team1CurrentScore =
        _team1CurrentScore == 0 ? 1 : (_team1CurrentScore * 2).clamp(0, 2048);
      } else {
        _team2Streak++;
        _team2CurrentScore =
        _team2CurrentScore == 0 ? 1 : (_team2CurrentScore * 2).clamp(0, 2048);
      }
      HapticFeedback.lightImpact();
    });
  }

  void _wrongAnswer() {
    setState(() {
      if (_activeTeam == 1) {
        _team1Streak = 0;
        _team1CurrentScore = 0;
      } else {
        _team2Streak = 0;
        _team2CurrentScore = 0;
      }
      HapticFeedback.mediumImpact();
    });
  }

  void _bankScore() {
    setState(() {
      if (_activeTeam == 1) {
        _team1BankedScore += _team1CurrentScore;
        _team1CurrentScore = 0;
        _team1Streak = 0;
      } else {
        _team2BankedScore += _team2CurrentScore;
        _team2CurrentScore = 0;
        _team2Streak = 0;
      }
      HapticFeedback.heavyImpact();
    });
  }

  // void _finalizeScores() {
  //   final total = _team1BankedScore + _team2BankedScore;
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('Final Scores'),
  //       content: Text(
  //         'Team 1: $_team1BankedScore\nTeam 2: $_team2BankedScore\n\nTotal: $total',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('Close'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.darkPitch,
      appBar: AppBar(
        title: const Text('Bank Challenge'),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRoundsRow(),
                const SizedBox(height: 24),
                _buildTimer(),
                const SizedBox(height: 24),
                _buildScoreRow(),
                const SizedBox(height: 24),
                _buildQuestionCard(),
                const SizedBox(height: 24),
                _buildAnswerButtons(),
                const SizedBox(height: 24),
                _buildScoresSummary(),
                const SizedBox(height: 16),
                // ElevatedButton(
                //   onPressed: (){},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: AppColors.brightGold,
                //     padding:
                //     const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                //   ),
                //   child: const Text(
                //     'Finalize Scores',
                //     style:
                //     TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //   ),
                // ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _rounds.asMap().entries.map((entry) {
          final index = entry.key;
          final round = entry.value;
          final isActive = index == _currentRound;

          return GestureDetector(
            onTap: () {
              setState(() {
                _currentRound = index;
                _timerSeconds = 120;
              });
              _startTimer();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.gameOnGreen
                    : AppColors.darkCard,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isActive
                      ? AppColors.gameOnGreen
                      : AppColors.grey,
                  width: 2,
                ),
              ),
              child: Text(
                round,
                style: TextStyle(
                  color:
                  isActive ? AppColors.black : AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimer() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gameOnGreen.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            _formatTime(_timerSeconds),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: _timerSeconds <= 10
                  ? AppColors.red
                  : AppColors.gameOnGreen,
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildTimerButton(
                icon: _isTimerRunning ? Icons.pause : Icons.play_arrow,
                onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
                color: AppColors.brightGold,
              ),
              _buildTimerButton(
                icon: Icons.refresh,
                onPressed: _resetTimer,
                color: AppColors.red,
              ),
            ],
          ),
        ],
      ),
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
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.black, size: 26),
      ),
    );
  }

  Widget _buildScoreRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTeamScoreColumn(
            teamName: 'Team 1',
            isActive: _activeTeam == 1,
            onTap: () => setState(() => _activeTeam = 1),
            currentScore: _team1CurrentScore,
            streak: _team1Streak,
            color: AppColors.gameOnGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTeamScoreColumn(
            teamName: 'Team 2',
            isActive: _activeTeam == 2,
            onTap: () => setState(() => _activeTeam = 2),
            currentScore: _team2CurrentScore,
            streak: _team2Streak,
            color: AppColors.brightGold,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamScoreColumn({
    required String teamName,
    required bool isActive,
    required VoidCallback onTap,
    required int currentScore,
    required int streak,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isActive ? color : color.withOpacity(0.3),
              width: isActive ? 3 : 2),
          boxShadow: isActive
              ? [
            BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              teamName,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Current: $currentScore',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Streak: $streak',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.gameOnGreen.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'السؤال ${_currentRound + 1}',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                color: AppColors.gameOnGreen,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            _isAnswerRevealed
                ? 'الإجابة: هذا هو النص المثال للإجابة الصحيحة'
                : 'هذا هو النص المثال للسؤال في لعبة البنك. يجب على اللاعبين الإجابة على السؤال خلال الوقت المحدد.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

        ],
      ),
    );
  }

  Widget _buildAnswerButtons() {
    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _correctAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              ),
              child: const Text('إجابة صحيحة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: _wrongAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              ),
              child: const Text('إجابة غلط',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: _bankScore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brightGold,
              padding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            ),
            child: const Text('Bank',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildScoresSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.brightGold.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Text('Team 1 Banked: $_team1BankedScore',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.gameOnGreen,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Team 2 Banked: $_team2BankedScore',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.brightGold,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('Active Team: $_activeTeam',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.white)),
        ],
      ),
    );
  }
}
