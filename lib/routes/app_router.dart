import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/language_selection_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/google_login_screen.dart';
import '../screens/role_selection_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/forms/conditional_form_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_wrapper_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/seller_profile_screen.dart';
import '../screens/car_detail_screen.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../screens/add/add_screen.dart';
import '../screens/tow_truck_wishlist_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/car_notification_screen.dart';
import '../screens/car_search_results_screen.dart';
import '../models/user_role.dart' as models;
import '../models/car_post.dart';
import '../providers/car_detail_provider.dart';
import '../services/auth_service.dart';

final _log = Logger('AppRouter');

class AppRouter {
  static final AuthService _authService = AuthService()..init();
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static bool _isAuthScreen(String path) {
    final authPaths = [
      '/language-selection',
      '/google-login',
      '/welcome',
      '/splash',
    ];
    return authPaths.contains(path);
  }

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) async {
      // Skip redirection for these paths
      final isSplash = state.uri.path == '/splash';
      final isLanguageSelection = state.uri.path == '/language-selection';
      final isGoogleLogin = state.uri.path == '/google-login';
      final isWelcome = state.uri.path == '/welcome';
      
      if (isSplash || isLanguageSelection || isGoogleLogin || isWelcome) {
        return null;
      }
      
      // Check auth state
      final isLoggedIn = await _authService.isLoggedIn();
      
      if (!isLoggedIn) {
        // If not logged in, redirect to language selection
        return '/language-selection';
      }
      
      // If user is logged in but trying to access auth screens, redirect to home
      if (_isAuthScreen(state.uri.path)) {
        return '/home';
      }
      
      return null;
    },
    observers: [
      _RouteLogger(),
    ],
    routes: [
      // Splash screen (initial route)
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
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

      // Car detail route
      GoRoute(
        path: '/car-detail/:id',
        name: 'carDetail',
        builder: (context, state) {
          // First try to get the carPost from extra (for existing code)
          if (state.extra is CarPost) {
            return CarDetailScreen(post: state.extra as CarPost);
          }
          
          // Get the car ID from the path parameters
          final carId = int.tryParse(state.pathParameters['id'] ?? '');
          if (carId == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Invalid car ID')),
            );
          }
          
          // Use the carDetailProvider to fetch the car details
          return ProviderScope(
            child: Consumer(
              builder: (context, ref, _) {
                final carAsync = ref.watch(carDetailProvider(carId));
                
                return carAsync.when(
                  data: (car) => CarDetailScreen(post: car),
                  loading: () => Scaffold(
                    appBar: AppBar(title: const Text('Car Details')),
                    body: const Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stackTrace) => Scaffold(
                    appBar: AppBar(title: const Text('Error')),
                    body: Center(
                      child: Text('Failed to load car details: $error'),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/search-results/:query',
        name: 'searchResults',
        builder: (context, state) {
          final query = state.pathParameters['query'] ?? '';
          final decodedQuery = Uri.decodeComponent(query);
          if (decodedQuery.isEmpty) {
            _log.warning('Search results route called with empty query.');
          }
          return CarSearchResultsScreen(searchQuery: decodedQuery);
        },
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const CarNotificationScreen(),
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
            path: '/wishlist',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WishlistScreen(),
            ),
          ),
          GoRoute(
            path: '/tow-truck-wishlist',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TowTruckWishlistScreen(),
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
        ],
      ),
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
