import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkPitch,
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ResponsivePadding(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: Responsive.getAvatarSize(context) * 2.4,
                        height: Responsive.getAvatarSize(context) * 2.4,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(Responsive.getAvatarSize(context) * 0.48),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gameOnGreen.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.sports_soccer,
                          size: Responsive.getAvatarSize(context) * 1.2,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: Responsive.getSpacing(context) * 2),
                      ResponsiveText(
                        'GameOn',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: 2,
                          fontSize: Responsive.getTitleSize(context) * 1.5,
                        ),
                      ),
                      SizedBox(height: Responsive.getSpacing(context) * 0.5),
                      ResponsiveText(
                        'Football Quiz & Challenges',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.lightGrey,
                          letterSpacing: 1,
                          fontSize: Responsive.getBodySize(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
