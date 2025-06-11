import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'api/service_locator.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userPhotoKey = 'user_photo';
  
  // Google Sign-In is now managed by the service locator
  GoogleSignIn get _googleSignIn => serviceLocator.googleSignIn!;
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  // Google Sign In
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      if (kDebugMode) {
        print('🔵 Starting Google sign in flow in main AuthService');
      }
      
      final authService = serviceLocator.authService;
      final response = await authService.signInWithGoogle();
      
      if (kDebugMode) {
        print('🔵 Google sign in response received');
        print('   Response keys: ${response.keys}');
      }
      
      // The token is already stored in FlutterSecureStorage by the API's AuthService
      // Verify we can retrieve it
      final token = await getToken();
      if (kDebugMode) {
        if (token == null) {
          print('⚠️ WARNING: Token not found in secure storage after Google sign in');
        } else {
          print('✅ Token verified in secure storage');
        }
      }
      
      // If the response includes a role, save it to SharedPreferences
      if (response.containsKey('role') && response['role'] != null) {
        final role = response['role'].toString();
        await _prefs.setString('user_role', role);
        if (kDebugMode) {
          print('💾 Saved user role to SharedPreferences: $role');
        }
      } else if (kDebugMode) {
        print('ℹ️ No role found in Google sign in response');
      }
      
      // Store user email and name if available
      if (response.containsKey('user')) {
        final user = response['user'] as Map<String, dynamic>;
        final email = user['email'] ?? '';
        final name = user['name'] ?? '';
        final photoUrl = user['photoUrl'] ?? user['picture'] ?? '';
        
        if (kDebugMode) {
          print('👤 User info:');
          print('   Email: $email');
          print('   Name: $name');
          print('   Photo URL: ${photoUrl.isNotEmpty ? '${photoUrl.substring(0, photoUrl.length > 30 ? 30 : photoUrl.length)}...' : 'N/A'}');
        }
        
        await _saveUserInfo(
          email: email,
          name: name,
          photoUrl: photoUrl,
        );
      } else if (kDebugMode) {
        print('ℹ️ No user data found in Google sign in response');
      }
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Google sign in error: $e');
      }
      rethrow;
    }
  }

  // Get auth token - checks both possible storage locations for backward compatibility
  Future<String?> getToken() async {
    if (kDebugMode) {
      print('\n🔍 [AUTH] ===== TOKEN RETRIEVAL STARTED =====');
    }
    
    try {
      // Try to get token from secure storage (current method)
      if (kDebugMode) {
        print('  1. Checking main secure storage...');
      }
      
      Stopwatch stopwatch = Stopwatch()..start();
      String? token = await _storage.read(key: _tokenKey);
      stopwatch.stop();
      
      if (kDebugMode) {
        if (token != null) {
          print('  ✅ Found token in main storage (${stopwatch.elapsedMilliseconds}ms)');
          print('     🔑 Token length: ${token.length}');
          print('     🔒 First 10 chars: ${token.length > 10 ? token.substring(0, 10) + '...' : token}');
        } else {
          print('  ℹ️ Token not found in main storage, checking API service...');
        }
      }
      
      // Fall back to API service if not found in secure storage
      if (token == null) {
        try {
          if (kDebugMode) {
            print('  2. Falling back to API service token...');
          }
          
          final apiAuthService = serviceLocator.authService;
          token = await apiAuthService.getToken();
          
          // If found via API service, store it in the main storage for next time
          if (token != null) {
            if (kDebugMode) {
              print('  🔄 Migrating token to main storage...');
            }
            
            await _storage.write(key: _tokenKey, value: token);
            
            if (kDebugMode) {
              print('  ✅ Token migrated to main storage successfully');
              print('     🔑 Token length: ${token.length}');
              print('     🔒 First 10 chars: ${token.length > 10 ? token.substring(0, 10) + '...' : token}');
            }
          } else if (kDebugMode) {
            print('  ⚠️ API service returned null token');
          }
        } catch (e, stackTrace) {
          if (kDebugMode) {
            print('  ❌ Error getting token from API service: $e');
            print('     Stack trace: $stackTrace');
          }
        }
      }
      
      if (kDebugMode) {
        print('\n📋 [AUTH] ===== TOKEN RETRIEVAL SUMMARY =====');
        if (token == null) {
          print('  ❌ No auth token available in any storage location');
        } else {
          print('  ✅ Auth token retrieved successfully');
          print('     📏 Length: ${token.length} characters');
          print('     🔑 Starts with: ${token.length > 10 ? token.substring(0, 10) + '...' : token}');
          print('     🔒 Ends with: ${token.length > 10 ? '...' + token.substring(token.length - 4) : token}');
        }
        print('=======================================\n');
      }
      
      return token;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('\n❌ [AUTH] ===== TOKEN RETRIEVAL FAILED =====');
        print('  Error: $e');
        print('  Stack trace: $stackTrace');
        print('====================================\n');
      }
      return null;
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userData = await _storage.read(key: _userDataKey);
      if (userData != null) {
        return json.decode(userData);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  // Save user info to SharedPreferences
  Future<void> _saveUserInfo({
    required String email,
    required String name,
    String photoUrl = '',
  }) async {
    await _prefs.setString(_userEmailKey, email);
    await _prefs.setString(_userNameKey, name);
    if (photoUrl.isNotEmpty) {
      await _prefs.setString(_userPhotoKey, photoUrl);
    }
  }

  // Get user email
  String? get userEmail => _prefs.getString(_userEmailKey);
  
  // Get user name
  String? get userName => _prefs.getString(_userNameKey);
  
  // Get user photo URL
  String? get userPhotoUrl => _prefs.getString(_userPhotoKey);
  
  // Sign out
  Future<void> signOut() async {
    if (kDebugMode) {
      print('🔄 Starting sign out process...');
    }
    
    try {
      // 1. Sign out from Google
      try {
        await _googleSignIn.signOut();
        if (kDebugMode) {
          print('✅ Successfully signed out from Google');
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Error signing out from Google: $e');
        }
      }
      
      // 2. Clear secure storage
      try {
        await Future.wait([
          _storage.delete(key: _tokenKey),
          _storage.delete(key: _userDataKey),
          _storage.delete(key: 'auth_token'),  // Ensure auth token is deleted
        ]);
        if (kDebugMode) {
          print('✅ Cleared secure storage (tokens and auth data)');
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Error clearing secure storage: $e');
        }
      }
      
      // 3. Clear all user-related data from SharedPreferences
      try {
        // Get all keys
        final allKeys = _prefs.getKeys();
        
        // Filter keys to remove (all user-related data)
        final keysToRemove = allKeys.where((key) => 
          key.startsWith('user_') || 
          key == 'selected_services' ||
          key == 'favorites' ||
          key == 'recent_searches' ||
          key == 'notifications_enabled' ||
          key == 'dark_mode_enabled' ||
          key == 'language_code' ||
          key == 'first_launch'
        ).toList();
        
        // Add specific profile data keys
        keysToRemove.addAll([
          _userEmailKey,
          _userNameKey,
          _userPhotoKey,
          'user_role',
          'user_id',
          'user_profile_data_buyer',
          'user_profile_data_seller',
          'user_profile_data_mechanic',
          'user_profile_data_other',
          'user_profile_data_garage',
          'user_profile_data_tow_truck',
          'selected_services',
          'fcm_token',
          'notification_settings',
        ]);
        
        // Remove all keys
        await Future.wait(keysToRemove.map((key) => _prefs.remove(key)));
        
        // Clear all SharedPreferences (alternative approach if needed)
        // await _prefs.clear();
        
        if (kDebugMode) {
          print('✅ Cleared all user data from SharedPreferences');
          print('   Removed keys: $keysToRemove');
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Error clearing SharedPreferences: $e');
        }
      }
      
      // 4. Clear any cached data from services
      try {
        // Clear any cached data in services
        // Example: await someService.clearCache();
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Error clearing service caches: $e');
        }
      }
      
      if (kDebugMode) {
        print('✅ Sign out completed successfully');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error during sign out: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  // Update user role
  Future<Map<String, dynamic>> updateUserRole(int roleIndex) async {
    try {
      final userService = serviceLocator.userService;
      return await userService.updateUserRole(roleIndex);
    } catch (e) {
      debugPrint('Error updating role: $e');
      rethrow;
    }
  }
  

}

// Singleton instance
final authService = AuthService()..init();
