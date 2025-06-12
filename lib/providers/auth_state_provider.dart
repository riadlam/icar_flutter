import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../services/auth_service.dart';

final _log = Logger('AuthStateProvider');

class AuthStateNotifier extends StateNotifier<AsyncValue<bool>> {
  final AuthService _authService;
  
  AuthStateNotifier(this._authService) : super(const AsyncValue.loading()) {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      state = const AsyncValue.loading();
      final isLoggedIn = await _authService.isLoggedIn();
      state = AsyncValue.data(isLoggedIn);
    } catch (e, stackTrace) {
      _log.severe('Error checking auth state', e, stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    try {
      state = const AsyncValue.loading();
      await _authService.signOut();
      state = const AsyncValue.data(false);
    } catch (e, stackTrace) {
      _log.severe('Error signing out', e, stackTrace);
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<bool>>((ref) {
  return AuthStateNotifier(authService);
});
