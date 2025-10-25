import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/challenge_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

class WhoIsInPictureScreen extends ConsumerWidget {
  const WhoIsInPictureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pictureChallengeProvider);
    final notifier = ref.read(pictureChallengeProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.darkPitch,
      appBar: AppBar(
        title: const Text('Who Is In The Picture'),
        backgroundColor: AppColors.darkPitch,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/categories'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.resetChallenge(),
            tooltip: 'Reset Challenge',
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: ResponsivePadding(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: Responsive.getSpacing(context)),
                _buildImageContainer(context, state),
                SizedBox(height: Responsive.getSpacing(context) * 2),
                _buildRevealButton(context, state, notifier),
                SizedBox(height: Responsive.getSpacing(context) * 2),
                if (state.namesRevealed) _buildPlayerNamesContainer(context, state),
                SizedBox(height: Responsive.getSpacing(context) * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, PictureChallengeState state) {
    return Container(
      width: double.infinity,
      height: Responsive.getScreenHeight(context) * 0.4,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Placeholder for image - in real app, this would be an actual image
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.gameOnGreen.withOpacity(0.3),
                    AppColors.brightGold.withOpacity(0.3),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.sports_soccer,
                  size: 80,
                  color: AppColors.white,
                ),
              ),
            ),
            // Overlay with question
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(Responsive.getSpacing(context)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: ResponsiveText(
                  'Can you identify all the players in this picture?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevealButton(BuildContext context, PictureChallengeState state, PictureChallengeNotifier notifier) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => notifier.toggleNamesReveal(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gameOnGreen,
          foregroundColor: AppColors.black,
          padding: EdgeInsets.symmetric(vertical: Responsive.getSpacing(context) * 1.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: AppColors.gameOnGreen.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.namesRevealed ? Icons.visibility_off : Icons.visibility,
              size: Responsive.getSpacing(context) * 1.25,
            ),
            SizedBox(width: Responsive.getSpacing(context) * 0.5),
            ResponsiveText(
              state.namesRevealed ? 'Hide Names' : 'Reveal Names',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerNamesContainer(BuildContext context, PictureChallengeState state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.getSpacing(context) * 1.25),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.brightGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_search,
                color: AppColors.brightGold,
                size: Responsive.getSpacing(context) * 1.5,
              ),
              SizedBox(width: Responsive.getSpacing(context) * 0.5),
              ResponsiveText(
                'Players in the Picture:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.brightGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.getSpacing(context)),
          ...state.playerNames.asMap().entries.map((entry) {
            final index = entry.key;
            final playerName = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: Responsive.getSpacing(context) * 0.5),
              child: Row(
                children: [
                  Container(
                    width: Responsive.getSpacing(context) * 1.5,
                    height: Responsive.getSpacing(context) * 1.5,
                    decoration: BoxDecoration(
                      color: AppColors.brightGold,
                      borderRadius: BorderRadius.circular(Responsive.getSpacing(context) * 0.75),
                    ),
                    child: Center(
                      child: ResponsiveText(
                        '${index + 1}',
                        style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.getSpacing(context)),
                  ResponsiveText(
                    playerName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
