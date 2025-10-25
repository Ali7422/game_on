import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/riverpod_timer.dart';

class OffsideChallengeScreen extends ConsumerStatefulWidget {
  const OffsideChallengeScreen({super.key});

  @override
  ConsumerState<OffsideChallengeScreen> createState() => _OffsideScreenState();
}

class _OffsideScreenState extends ConsumerState<OffsideChallengeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(riskTimerProvider.notifier).startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(riskTimerProvider);
    final timerNotifier = ref.read(riskTimerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.darkPitch,
      appBar: AppBar(
        backgroundColor: AppColors.darkPitch,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/categories'),
        ),
        title: const Text(
          'أوفسايد',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTimerControlBar(context, timerState, timerNotifier),
            const SizedBox(height: 24),
            ...List.generate(10, (index) => _buildQuestionCard(context, index)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerControlBar(
      BuildContext context, int timerSeconds, RiskTimerNotifier timerNotifier) {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(riskTimerProvider.notifier);
        final seconds = ref.watch(riskTimerProvider);

        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16),
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
                    color: seconds <= 10
                        ? AppColors.red
                        : AppColors.brightGold,
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
                      icon: notifier.isRunning
                          ? Icons.pause
                          : Icons.play_arrow,
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

  Widget _buildQuestionCard(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'هل كان هذا اللاعب في موقف تسلل؟ 🤔 (${index + 1})',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
