import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import '../providers/guest_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
                decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Instagram-style logo placeholder
                    Image.asset(
                      'assets/images/djawad-circle.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 48),
                    _StyledButton(
                      text: 'login'.tr(),
                      onPressed: () => context.go('/google-login'),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        ref.read(guestModeProvider.notifier).state = true;
                        context.go('/skip-home');
                      },
                      child: Text(
                        'skip_for_now'.tr(),
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _StyledButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.loginbg,
          foregroundColor: AppColors.logintext,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
} 