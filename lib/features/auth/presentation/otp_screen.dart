import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/game_on_theme.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
	const OtpScreen({super.key, this.digits = 6});

	final int digits;

	@override
	State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
	late List<TextEditingController> _controllers;
	late List<FocusNode> _focusNodes;
	Timer? _timer;
	int _seconds = 59;

	@override
	void initState() {
		super.initState();
		_controllers = List.generate(widget.digits, (_) => TextEditingController());
		_focusNodes = List.generate(widget.digits, (_) => FocusNode());
		_timer = Timer.periodic(const Duration(seconds: 1), (timer) {
			if (!mounted) return;
			setState(() {
				if (_seconds > 0) {
					_seconds--;
				} else {
					timer.cancel();
				}
			});
		});
	}

	@override
	void dispose() {
		for (final c in _controllers) {
			c.dispose();
		}
		for (final f in _focusNodes) {
			f.dispose();
		}
		_timer?.cancel();
		super.dispose();
	}

	void _onChanged(int index, String value) {
		if (value.isNotEmpty && index < widget.digits - 1) {
			_focusNodes[index + 1].requestFocus();
		}
	}

	String get _code => _controllers.map((c) => c.text).join();

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
								Text('رمز التحقق', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
								const SizedBox(height: 8),
								Text(
									'تم إرسال الرمز إلى هاتفك/بريدك الإلكتروني',
									textAlign: TextAlign.center,
									style: Theme.of(context).textTheme.bodyMedium,
								),
								const SizedBox(height: 24),
								Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: List.generate(widget.digits, (i) {
										return Container(
											width: 48,
											height: 56,
											margin: const EdgeInsets.symmetric(horizontal: 6),
											decoration: BoxDecoration(
												color: GameOnColors.surface,
												borderRadius: BorderRadius.circular(GameOnDimens.radius),
												border: Border.all(color: GameOnColors.primaryGreen, width: 2),
											),
											child: Center(
												child: TextField(
													controller: _controllers[i],
													focusNode: _focusNodes[i],
													keyboardType: TextInputType.number,
													textAlign: TextAlign.center,
													maxLength: 1,
													style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
													decoration: const InputDecoration(counterText: '', border: InputBorder.none),
													onChanged: (v) => _onChanged(i, v),
												),
											),
										);
									}),
								),
								const SizedBox(height: 16),
								Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										Text('${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}', style: const TextStyle(color: GameOnColors.accentGold)),
										const SizedBox(width: 12),
										InkWell(
											onTap: _seconds == 0 ? () { setState(() { _seconds = 59; }); _timer?.cancel(); _timer = Timer.periodic(const Duration(seconds: 1), (t) { if (!mounted) return; setState(() { if (_seconds > 0) { _seconds--; } else { t.cancel(); } }); }); } : null,
											child: Text('إعادة إرسال', style: TextStyle(color: _seconds == 0 ? GameOnColors.primaryGreen : GameOnColors.textSecondary)),
										),
									],
								),
								const Spacer(),
								ElevatedButton(
									style: GameOnTheme.primaryButtonStyle,
									onPressed: () => context.go('/home'),
									child: const Text('تحقق'),
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



