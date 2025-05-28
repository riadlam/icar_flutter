import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'services/car_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  
  // Services
  late final AuthService authService;
  late final UserService userService;
  late final CarService carService;
  
  // Dependencies
  late final http.Client _httpClient;
  late final FlutterSecureStorage _storage;
  GoogleSignIn? _googleSignIn;
  
  // Getter for GoogleSignIn instance
  GoogleSignIn? get googleSignIn => _googleSignIn;
  
  factory ServiceLocator() {
    return _instance;
  }
  
  ServiceLocator._internal() {
    // Initialize dependencies
    _httpClient = http.Client();
    _storage = const FlutterSecureStorage();
    
    // Initialize Google Sign-In if not on web
    if (!kIsWeb) {
      try {
        _googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
          serverClientId: '531675145063-7f6dl6uenubrkivmegqkql1sps0ellu2.apps.googleusercontent.com',
        );
        // Sign in silently to initialize the Google Sign-In instance
        _googleSignIn?.signInSilently();
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing Google Sign-In: $e');
        }
      }
    }

    // Initialize services
    authService = AuthService(
      client: _httpClient,
      storage: _storage,
      googleSignIn: _googleSignIn,
    );
    
    userService = UserService(
      client: _httpClient,
      storage: _storage,
    );
    
    carService = CarService(
      client: _httpClient,
      storage: _storage,
    );
  }
  
  // Cleanup resources
  void dispose() {
    _httpClient.close();
    // Sign out from Google when disposing
    _googleSignIn?.signOut();
  }
}

// Global instance
final serviceLocator = ServiceLocator();
