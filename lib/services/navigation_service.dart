import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final navigationService = NavigationService();

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final _log = Logger('NavigationService');

  // Navigation methods
  void goToHome() => _navigateTo('/home');
  void goToLogin() => _navigateTo('/google-login');
  void goToRoleSelection() => _navigateTo('/role-selection');
  void goToForm(dynamic role) => _navigateTo('/form', extra: role);

  // Helper method for navigation
  void _navigateTo(String path, {Object? extra}) {
    _log.fine('Navigating to: $path');
    navigatorKey.currentState?.pushNamed(
      path,
      arguments: extra,
    );
  }

  // Go back to previous screen
  void goBack() {
    _log.fine('Going back');
    navigatorKey.currentState?.pop();
  }

  // Check current route
  String? get currentRoute => GoRouterState.of(navigatorKey.currentContext!).uri.path;

  // Check if current route matches a pattern
  bool isCurrentRoute(String route) => currentRoute == route;
}
