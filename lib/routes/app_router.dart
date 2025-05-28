import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import '../screens/language_selection_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/google_login_screen.dart';
import '../screens/role_selection_screen.dart';
import '../screens/forms/conditional_form_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_wrapper_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/seller_profile_screen.dart';
import '../screens/car_detail_screen.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../screens/add/add_screen.dart';
import '../models/user_role.dart' as models;
import '../models/car_post.dart';

final _log = Logger('AppRouter');

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/language-selection',
    debugLogDiagnostics: true,
    observers: [
      _RouteLogger(),
    ],
    routes: [
      // Public routes
      GoRoute(
        path: '/language-selection',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/google-login',
        builder: (context, state) => const GoogleLoginScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/form',
        builder: (context, state) {
          final role = state.extra as models.UserRole?;
          if (role == null) return const RoleSelectionScreen();
          return ConditionalFormScreen(role: role);
        },
      ),
      GoRoute(
        path: '/car-detail',
        builder: (context, state) {
          final carPost = state.extra as CarPost;
          return CarDetailScreen(post: carPost);
        },
      ),
      
      // Shell route for main app with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainWrapperScreen(
            child: child,
          );
        },
        routes: [
          // Main tabs
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
          GoRoute(
            path: '/add',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AddScreen(),
            ),
          ),
          // Seller profile route with parameters
          GoRoute(
            name: 'seller-profile',
            path: '/seller-profile/:sellerName/:sellerPhone',
            pageBuilder: (context, state) {
              try {
                // Get parameters from path
                final sellerName = Uri.decodeComponent(state.pathParameters['sellerName'] ?? 'Unknown Seller');
                final sellerPhone = Uri.decodeComponent(state.pathParameters['sellerPhone'] ?? '');
                
                // Get cars from extra data
                List<CarPost> sellerCars = [];
                if (state.extra != null) {
                  try {
                    final extra = state.extra as Map<String, dynamic>? ?? {};
                    final carsData = extra['sellerCars'] as List<dynamic>? ?? [];
                    sellerCars = carsData.map((e) => CarPost.fromJson(e)).toList();
                  } catch (e) {
                    _log.severe('Error parsing seller cars data: $e');
                  }
                }
                
                return NoTransitionPage(
                  key: ValueKey('seller-profile-$sellerName-${DateTime.now().millisecondsSinceEpoch}'),
                  child: Scaffold(
                    body: SellerProfileScreen(
                      sellerName: sellerName,
                      sellerPhone: sellerPhone,
                      sellerCars: sellerCars,
                    ),
                    bottomNavigationBar: BottomNavigationBarWidget(
                      currentIndex: 3, // Profile tab is active
                      onTap: (index) {
                        // Use the context from the builder
                        switch (index) {
                          case 0:
                            context.go('/home');
                            break;
                          case 1:
                            context.go('/wishlist');
                            break;
                          case 2:
                            context.go('/add');
                            break;
                          case 3:
                            // Already on profile, do nothing
                            break;
                        }
                      },
                      showProfile: true,
                    ),
                  ),
                );
              } catch (e, stackTrace) {
                _log.severe('Error in seller profile route', e, stackTrace);
                return NoTransitionPage(
                  key: ValueKey('error-${DateTime.now().millisecondsSinceEpoch}'),
                  child: Scaffold(
                    body: Center(
                      child: Text('Error loading profile. Please try again.'),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      
      // Add more routes here as needed
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}

class _RouteLogger extends NavigatorObserver {
  final _log = Logger('RouteLogger');

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log.fine('Route pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log.fine('Route popped: ${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log.fine('Route removed: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _log.fine('Route replaced: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}
