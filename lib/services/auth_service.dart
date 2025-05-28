import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      final authService = serviceLocator.authService;
      return await authService.signInWithGoogle();
    } catch (e) {
      debugPrint('Google sign in error: $e');
      rethrow;
    }
  }

  // Get auth token
  Future<String?> getToken() async {
    try {
      final authService = serviceLocator.authService;
      return await authService.getToken();
    } catch (e) {
      debugPrint('Error getting auth token: $e');
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
    try {
      final authService = serviceLocator.authService;
      await authService.signOut();
      
      // Clear local storage
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userDataKey);
      await _prefs.remove(_userEmailKey);
      await _prefs.remove(_userNameKey);
      await _prefs.remove(_userPhotoKey);
    } catch (e) {
      debugPrint('Error during sign out: $e');
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
