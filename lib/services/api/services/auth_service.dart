import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../endpoints/api_endpoints.dart';
import 'base_api_service.dart';

class AuthService extends BaseApiService {
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _storage;
  
  AuthService({
    required super.client,
    required FlutterSecureStorage storage,
    GoogleSignIn? googleSignIn,
  })  : _storage = storage,
        _googleSignIn = googleSignIn ?? GoogleSignIn(
          scopes: ['email', 'profile'],
          serverClientId: '531675145063-7f6dl6uenubrkivmegqkql1sps0ellu2.apps.googleusercontent.com',
        ),
        super(storage: storage);

  /// Signs in with Google and returns user data
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      if (kDebugMode) {
        print('1. Starting Google Sign In flow');
      }
      
      // Sign in with Google
      final googleUser = await _googleSignIn.signIn();
      
      if (kDebugMode) {
        print('2. Google user: ${googleUser?.email ?? 'No user returned'}');
      }
      
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Get authentication details
      if (kDebugMode) {
        print('3. Getting authentication details');
      }
      
      final googleAuth = await googleUser.authentication;
      
      if (kDebugMode) {
        print('4. Got authentication details');
      }
      
      // Send to backend
      final response = await post(
        ApiEndpoints.googleLogin,
        body: {
          'access_token': googleAuth.accessToken,
          'id_token': googleAuth.idToken,
        },
      );

      if (kDebugMode) {
        print('5. Authentication successful');
      }
      
      // Store the token
      await _storage.write(
        key: 'auth_token',
        value: response['token'],
      );
      
      // Store user data
      await _storage.write(
        key: 'user_data',
        value: json.encode(response['user']),
      );
      
      if (kDebugMode) {
        print('6. User data stored successfully');
      }
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Google sign in error: $e');
      }
      rethrow;
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();
      
      // Call logout endpoint
      try {
        await post(ApiEndpoints.logout);
      } catch (e) {
        if (kDebugMode) {
          print('Error during API logout: $e');
        }
      }
      // Continue with local sign out even if API logout fails
      
      // Clear all storage
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_data');
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      rethrow;
    }
  }

  /// Checks if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  /// Gets the current auth token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'auth_token');
    } catch (e) {
      if (kDebugMode) {
        // developer.log('Error getting auth token: $e');
      }
      return null;
    }
  }
  
  // Check if user is logged in by verifying the auth token
  Future<bool> checkLoginStatus() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking login status: $e');
      }
      return false;
    }
  }
  
  // Get the current user's authentication token
  Future<String?> getAuthToken() async {
    try {
      return await _storage.read(key: 'auth_token');
    } catch (e) {
      if (kDebugMode) {
        print('Error getting auth token: $e');
      }
      return null;
    }
  }
}
