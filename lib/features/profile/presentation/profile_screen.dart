import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/persistent_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkPitch,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildUserInfoCard(context),
                    const SizedBox(height: 24),
                    _buildStatsSection(context),
                    const SizedBox(height: 24),
                    _buildSettingsSection(context),
                    const SizedBox(height: 24),
                    _buildLogoutButton(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const PersistentBottomNavBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkCardSecondary, // #1A1A1A
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gameOnGreen.withOpacity(0.2),
              border: Border.all(
                color: AppColors.gameOnGreen,
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.person,
              size: 50,
              color: AppColors.gameOnGreen,
            ),
          ),
          const SizedBox(height: 16),
          // Username
          Text(
            'علي عليوة',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          // Total Points
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: AppColors.brightGold,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '1,250 Points',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.brightGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatChip(
                icon: Icons.games_rounded,
                label: 'Games',
                value: '47',
                color: AppColors.gameOnGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatChip(
                icon: Icons.trending_up_rounded,
                label: 'Wins',
                value: '32',
                color: AppColors.brightGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatChip(
                icon: Icons.percent_rounded,
                label: 'Win Rate',
                value: '68%',
                color: AppColors.gameOnGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatChip(
                icon: Icons.local_fire_department_rounded,
                label: 'Streak',
                value: '5',
                color: AppColors.brightGold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        _SettingsItem(
          icon: Icons.notifications_rounded,
          label: 'Notifications',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _SettingsItem(
          icon: Icons.security_rounded,
          label: 'Privacy & Security',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _SettingsItem(
          icon: Icons.language_rounded,
          label: 'Language',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _SettingsItem(
          icon: Icons.help_outline_rounded,
          label: 'Help & Support',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle logout
          context.go('/login');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red.withOpacity(0.2),
          foregroundColor: AppColors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.red, width: 2),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.gameOnGreen, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.lightGrey,
            ),
          ],
        ),
      ),
    );
  }
}

