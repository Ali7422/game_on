import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/game_on_theme.dart';

class LoginScreen extends StatelessWidget {
	const LoginScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Directionality(
			textDirection: TextDirection.rtl,
			child: Scaffold(
				body: SafeArea(
					child: Padding(
						padding: const EdgeInsets.all(GameOnDimens.spacing),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								const SizedBox(height: 12),
								// Header illustration placeholder (muted football / stadium line art)
								Container(
									height: 140,
									decoration: BoxDecoration(
										color: GameOnColors.surface.withOpacity(0.5),
										borderRadius: BorderRadius.circular(GameOnDimens.radius),
									),
									child: Center(
										child: Icon(
											Icons.sports_soccer,
											size: 64,
											color: GameOnColors.textSecondary,
										),
									),
								),
								const SizedBox(height: 20),
								// Branding
								Text(
									'GameOn',
									textAlign: TextAlign.center,
									style: Theme.of(context).textTheme.titleLarge?.copyWith(
										fontSize: 28,
									),
								),
								const SizedBox(height: 8),
								Text(
									'تسجيل الدخول',
									textAlign: TextAlign.center,
									style: Theme.of(context).textTheme.titleLarge,
								),
								const SizedBox(height: 24),
								// Inputs
								TextField(
									keyboardType: TextInputType.emailAddress,
									textInputAction: TextInputAction.next,
									style: const TextStyle(color: GameOnColors.textPrimary),
									decoration: const InputDecoration(
										hintText: 'البريد الإلكتروني / رقم الهاتف',
									),
								),
								const SizedBox(height: 12),
								TextField(
									obscureText: true,
									textInputAction: TextInputAction.done,
									style: const TextStyle(color: GameOnColors.textPrimary),
									decoration: const InputDecoration(
										hintText: 'كلمة المرور',
									),
								),
								const Spacer(),
								// Primary button
								ElevatedButton(
									style: GameOnTheme.primaryButtonStyle,
									onPressed: () => context.go('/home'),
									child: const Text('دخول'),
								),
								const SizedBox(height: 12),
								// Secondary links
								Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										Text(
											'نسيت كلمة المرور؟',
											style: Theme.of(context).textTheme.bodyMedium,
										),
										const SizedBox(width: 8),
										InkWell(
											onTap: () => context.go('/forgot'),
											child: Text(
												'نسيت كلمة المرور؟',
												style: Theme.of(context).textTheme.bodyMedium,
											),
										),
										const SizedBox(width: 8),
										InkWell(
											onTap: () => context.go('/signup'),
											child: const Text(
												'إنشاء حساب',
												style: TextStyle(color: GameOnColors.primaryGreen),
											),
										),
									],
								),
								const SizedBox(height: 12),
							],
						),
					),
				),
			),
		);
	}
}


