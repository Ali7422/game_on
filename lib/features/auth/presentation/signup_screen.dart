import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/game_on_theme.dart';

class SignUpScreen extends StatelessWidget {
	const SignUpScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Directionality(
			textDirection: TextDirection.rtl,
			child: Scaffold(
				resizeToAvoidBottomInset: true,
				body: SafeArea(
					child: LayoutBuilder(
						builder: (context, constraints) {
							return SingleChildScrollView(
								physics: const BouncingScrollPhysics(),
								child: ConstrainedBox(
									constraints: BoxConstraints(
										minHeight: constraints.maxHeight,
									),
									child: Padding(
										padding: const EdgeInsets.all(GameOnDimens.spacing),
										child: IntrinsicHeight(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.stretch,
												children: [
													const SizedBox(height: 12),
													// Branding
													Text(
														'إنشاء حساب',
														textAlign: TextAlign.center,
														style: Theme.of(context).textTheme.titleLarge,
													),
													const SizedBox(height: 24),
													TextField(
														textInputAction: TextInputAction.next,
														style: const TextStyle(color: GameOnColors.textPrimary),
														decoration: const InputDecoration(hintText: 'الاسم الكامل'),
													),
													const SizedBox(height: 12),
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
														decoration: const InputDecoration(hintText: 'كلمة المرور'),
													),
													const Spacer(),
													ElevatedButton(
														style: GameOnTheme.primaryButtonStyle,
														onPressed: () => context.go('/otp'),
														child: const Text('إنشاء الحساب'),
													),
													const SizedBox(height: 12),
													Row(
														mainAxisAlignment: MainAxisAlignment.center,
														children: [
															const Text(
																'لديك حساب بالفعل؟ ',
																style: TextStyle(color: GameOnColors.textSecondary),
															),
															InkWell(
																onTap: () => context.go('/login'),
																child: const Text(
																	'تسجيل الدخول',
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
						},
					),
				),
			),
		);
	}
}
