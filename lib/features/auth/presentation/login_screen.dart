import 'package:flutter/material.dart';
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
					child: LayoutBuilder(
						builder: (context, constraints) {
							return SingleChildScrollView(
								physics: const BouncingScrollPhysics(),
								child: ConstrainedBox(
									constraints: BoxConstraints(minHeight: constraints.maxHeight),
									child: Padding(
										padding: const EdgeInsets.all(GameOnDimens.spacing),
										child: IntrinsicHeight(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.stretch,
												children: [
													const SizedBox(height: 12),
													Container(
														height: 140,
														decoration: BoxDecoration(
															color: GameOnColors.surface.withOpacity(0.5),
															borderRadius:
															BorderRadius.circular(GameOnDimens.radius),
														),
														child: const Center(
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
														style: Theme.of(context)
																.textTheme
																.titleLarge
																?.copyWith(fontSize: 28),
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
															InkWell(
																onTap: () => context.go('/forgot'),
																child: const Text(
																	'نسيت كلمة المرور؟',
																	style:
																	TextStyle(color: GameOnColors.primaryGreen),
																),
															),
															const SizedBox(width: 16),
															InkWell(
																onTap: () => context.go('/signup'),
																child: const Text(
																	'إنشاء حساب',
																	style:
																	TextStyle(color: GameOnColors.primaryGreen),
																),
															),
														],
													),
													const SizedBox(height: 16),
													// Divider with "or"
													Row(
														children: const [
															Expanded(
																child:
																Divider(thickness: 1, indent: 40, endIndent: 10),
															),
															Text("أو"),
															Expanded(
																child:
																Divider(thickness: 1, indent: 10, endIndent: 40),
															),
														],
													),
													const SizedBox(height: 20),
													ElevatedButton.icon(
														style: ElevatedButton.styleFrom(
															backgroundColor: Colors.white,
															foregroundColor: Colors.black87,
															minimumSize: const Size(double.infinity, 50),
															shape: RoundedRectangleBorder(
																borderRadius: BorderRadius.circular(
																		GameOnDimens.radius),
															),
															side: const BorderSide(
																color: Colors.black12,
																width: 1,
															),
															shadowColor: Colors.black12,
															elevation: 2,
														),
														onPressed: () {
															//  Add Google sign-in logic
														},
														icon: Image.asset(
															"assets/images/google.png",
															height: 24,
															width: 24,
														),
														label: const Text(
															"تسجيل الدخول باستخدام Google",
															style: TextStyle(
																fontSize: 16,
																fontWeight: FontWeight.w600,
															),
														),
													),
													const SizedBox(height: 24),
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
