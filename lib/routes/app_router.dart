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
import '../screens/car_brands_screen.dart';
import '../screens/car_models_screen.dart';
import '../screens/subcategory_screen.dart';
import '../screens/add/add_screen.dart';
import '../screens/car_notification_screen.dart';
import '../screens/car_search_results_screen.dart';
import '../screens/spare_parts_list_screen.dart';
import '../screens/wishlist_screen.dart';

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
    observers: [_RouteLogger()],
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
      GoRoute(
        path: '/car-brands',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return CarBrandsScreen(
            category: args['categoryName'] as String? ?? '',
            subcategory: args['subcategoryName'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/car-models',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return CarModelsScreen(
            brand: args['brand'] as String,
            category: args['category'] as String? ?? '',
            subcategory: args['subcategory'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/spare-parts-list',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return SparePartsListScreen(args: args);
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
      
      // Private routes (require authentication)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainWrapperScreen(
          child: child,
        ),
        routes: [
          // Main tab routes
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          // Subcategory flow
          GoRoute(
            path: '/subcategory',
            pageBuilder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return NoTransitionPage(
                child: SubcategoryScreen(
                  categoryId: args['categoryId'],
                  categoryName: args['categoryName'],
                  subcategories: args['subcategories'],
                ),
              );
            },
          ),
          // Car brands screen
          GoRoute(
            path: '/car-brands',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CarBrandsScreen(),
            ),
          ),
          // Car models screen
          GoRoute(
            path: '/car-models',
            pageBuilder: (context, state) => NoTransitionPage(
              child: CarModelsScreen(brand: state.extra as String),
            ),
          ),
          // Profile screen
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
          // Wishlist screen
          GoRoute(
            path: '/wishlist',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WishlistScreen(),
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
