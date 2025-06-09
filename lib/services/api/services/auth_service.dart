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

  /// Signs in with Google and returns user data including is_new_user flag
  /// Returns a Map containing:
  /// - token: String
  /// - user: Map<String, dynamic>
  /// - is_new_user: bool
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
      final token = response['token'] as String?;
      if (token == null || token.isEmpty) {
        if (kDebugMode) {
          print('⚠️ No token received in the response');
        }
        throw Exception('No auth token received from server');
      }
      
      if (kDebugMode) {
        print('🔑 [AUTH] Storing auth token in secure storage');
        print('   🔒 Token key: auth_token');
        print('   📏 Token length: ${token.length}');
        print('   🔑 First 10 chars: ${token.length > 10 ? token.substring(0, 10) + '...' : token}');
      }
      
      try {
        // Use the same token key as the main AuthService
        await _storage.write(
          key: 'auth_token',
          value: token,
        );
        
        // Verify the token was stored correctly
        final storedToken = await _storage.read(key: 'auth_token');
        
        if (kDebugMode) {
          if (storedToken == token) {
            print('✅ [AUTH] Auth token verified in secure storage');
            print('   🔄 Token matches the one we tried to store');
          } else if (storedToken != null) {
            print('⚠️ [AUTH] Token stored but verification failed - token mismatch');
            print('   🔄 Stored token length: ${storedToken.length}');
          } else {
            print('❌ [AUTH] Failed to store token - verification returned null');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ [AUTH] Error storing token: $e');
        }
        rethrow;
      }
      
      // Store user data
      final userData = response['user'] as Map<String, dynamic>;
      await _storage.write(
        key: 'user_data',
        value: json.encode(userData),
      );
      
      // Ensure the response includes the role if available in user data
      final Map<String, dynamic> responseWithRole = Map.from(response);
      if (userData['role'] != null) {
        responseWithRole['role'] = userData['role'];
      }
      
      if (kDebugMode) {
        print('6. User data stored successfully');
        if (userData['role'] != null) {
          print('Role from backend: ${userData['role']}');
        }
      }
      
      return responseWithRole;
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
      if (kDebugMode) {
        print('🔍 Retrieving auth token from secure storage');
      }
      
      final token = await _storage.read(key: 'auth_token');
      
      if (kDebugMode) {
        if (token == null) {
          print('⚠️ No auth token found in secure storage');
        } else {
          print('✅ Retrieved auth token');
          print('   Token length: ${token.length}');
          print('   First 10 chars: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');
        }
      }
      
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error retrieving auth token: $e');
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
