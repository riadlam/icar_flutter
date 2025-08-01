import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icar_instagram_ui/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final registrationPhase = prefs.getBool('registration_phase') ?? false;
      if (registrationPhase) {
        if (mounted) {
          context.go('/role-selection');
        }
        return;
      }

      final isLoggedIn = await authService.isLoggedIn();
      if (!mounted) return;
      if (isLoggedIn) {
        // If user is logged in, go to home
        context.go('/home');
      } else {
        // If not logged in, go to language selection
        context.go('/language-selection');
      }
    } catch (e) {
      // If there's an error, still go to language selection
      if (mounted) {
        context.go('/language-selection');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
