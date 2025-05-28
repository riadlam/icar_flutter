import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Instagram-style logo placeholder
                Icon(Icons.directions_car, size: 64, color: Colors.pinkAccent),
                const SizedBox(height: 48),
                _StyledButton(
                  text: 'login'.tr(),
                  onPressed: () => context.go('/google-login'),
                ),
                const SizedBox(height: 16),
                _StyledButton(
                  text: 'sign_up'.tr(),
                  onPressed: () => context.go('/google-login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/role-selection'),
                  child: Text('skip_for_now'.tr(), style: const TextStyle(color: Colors.grey)),
                ),
              ],
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
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
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