import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icar_instagram_ui/services/auth_service.dart';

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
