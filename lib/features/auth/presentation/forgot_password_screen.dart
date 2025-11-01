import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/game_on_theme.dart';

class ForgotPasswordScreen extends StatelessWidget {
	const ForgotPasswordScreen({super.key});

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
								Text('نسيت كلمة المرور', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
								const SizedBox(height: 8),
								Text(
									'أدخل بريدك الإلكتروني أو رقم هاتفك لاستعادة الوصول',
									textAlign: TextAlign.center,
									style: Theme.of(context).textTheme.bodyMedium,
								),
								const SizedBox(height: 24),
								TextField(
									keyboardType: TextInputType.emailAddress,
									textInputAction: TextInputAction.done,
									style: const TextStyle(color: GameOnColors.textPrimary),
									decoration: const InputDecoration(hintText: 'البريد الإلكتروني / رقم الهاتف'),
								),
								const Spacer(),
								ElevatedButton(
									style: GameOnTheme.primaryButtonStyle,
									onPressed: () {
										context.go('/otp');
									},
									child: const Text('إرسال'),
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


