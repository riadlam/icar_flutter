import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import '../services/auth_service.dart';
import '../services/api/service_locator.dart';
import '../models/user_role.dart' as models;
import '../providers/role_provider.dart';

class GoogleLoginScreen extends ConsumerStatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  ConsumerState<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends ConsumerState<GoogleLoginScreen> {
  bool _isLoading = false;

  // Helper method to map backend role string to UserRole enum
  models.UserRole? _mapRoleStringToEnum(String role) {
    developer.log('Mapping role string to enum: $role', name: 'GoogleLoginScreen');
    
    // Convert to lowercase for case-insensitive comparison
    final lowerRole = role.toLowerCase().trim();
    
    // Map all possible role strings to our UserRole enum
    switch (lowerRole) {
      case 'seller':
      case 'car_seller':
      case 'spare_parts_seller':
        developer.log('Mapped $role to UserRole.seller', name: 'GoogleLoginScreen');
        return models.UserRole.seller;
        
      case 'mechanic':
      case 'tow_truck':
        developer.log('Mapped $role to UserRole.mechanic', name: 'GoogleLoginScreen');
        return models.UserRole.mechanic;
        
      case 'garage':
      case 'garage_owner':
        developer.log('Mapped $role to UserRole.other (garage)', name: 'GoogleLoginScreen');
        return models.UserRole.other;
        
      case 'buyer':
        developer.log('Mapped $role to UserRole.buyer', name: 'GoogleLoginScreen');
        return models.UserRole.buyer;
        
      default:
        developer.log('Unknown role string: $role', name: 'GoogleLoginScreen');
        // Try to find a matching role by name in the enum values as a fallback
        try {
          final enumValue = models.UserRole.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() == lowerRole,
            orElse: () => throw Exception('No matching role'),
          );
          developer.log('Matched $role to $enumValue using fallback', name: 'GoogleLoginScreen');
          return enumValue;
        } catch (e) {
          developer.log('Error mapping role: $e', name: 'GoogleLoginScreen');
          return null;
        }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (kDebugMode) {
      print('🔄 Starting Google sign in process...');
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Ensure we have a fresh token storage instance
      final storage = const FlutterSecureStorage();
      
      // Clear any existing tokens to prevent conflicts
      await storage.delete(key: 'auth_token');
      if (kDebugMode) {
        print('🔑 Cleared any existing auth tokens');
      }
      if (kDebugMode) {
        print('🔵 Step 1: Calling authService.signInWithGoogle()');
      }
      
      // Sign in with Google and get the response
      final response = await authService.signInWithGoogle();
      
      if (kDebugMode) {
        print('✅ Google sign in completed successfully');
        print('   Response keys: ${response.keys}');
        if (response.containsKey('error')) {
          print('❌ Error in response: ${response['error']}');
        }
      }
      
      // Verify token was stored correctly
      try {
        final storedToken = await storage.read(key: 'auth_token');
        if (kDebugMode) {
          if (storedToken == null) {
            print('❌ ERROR: Token was not stored in secure storage!');
          } else {
            print('🔑 Successfully verified token in secure storage');
            print('   Token length: ${storedToken.length}');
            print('   First 10 chars: ${storedToken.length > 10 ? storedToken.substring(0, 10) + '...' : storedToken}');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error verifying token storage: $e');
        }
      }
      
      if (!mounted) {
        if (kDebugMode) {
          print('⚠️ Widget is no longer mounted, aborting');
        }
        return;
      }
      
      final isNewUser = response['is_new_user'] as bool? ?? true;
      final userData = response['user'] as Map<String, dynamic>?;
      
      if (isNewUser) {
        // New user - go to role selection
        if (kDebugMode) {
          print('👤 New user detected, redirecting to role selection');
        }
        if (mounted) {
          context.go('/role-selection');
        }
        return;
      } else if (userData != null) {
        // Existing user - store profile data locally
        try {
          final prefs = await SharedPreferences.getInstance();
          final role = _mapRoleStringToEnum(userData['role']?.toString() ?? '');
          
          if (role != null) {
            // Match the exact key format used in conditional form
            final storageKey = 'user_profile_data_${role.name}';
            final userDataJson = jsonEncode(userData);
            
            // Store user data with role-specific key (matching conditional form format)
            await prefs.setString(storageKey, userDataJson);
            
            // Store user ID for quick access
            if (userData['id'] != null) {
              await prefs.setString('user_id', userData['id'].toString());
            }
            
            // Log the storage operation
            if (kDebugMode) {
              print('💾 STORED USER PROFILE DATA');
              print('   Storage Key: $storageKey');
              print('   User ID: ${userData['id']}');
              print('   User Role: ${role.name}');
              print('   Data Length: ${userDataJson.length} characters');
              print('   Sample Data: ${userDataJson.length > 100 ? userDataJson.substring(0, 100) + '...' : userDataJson}');
              print('   All Stored Keys:');
              final allKeys = prefs.getKeys();
              allKeys.where((k) => k.startsWith('user_profile_data_') || k == 'user_id')
                     .forEach((k) => print('     - $k'));
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Error storing user profile data: $e');
          }
        }
      }
      
      if (kDebugMode) {
        print('🔍 Existing user, fetching user role...');
      }
      
      // Existing user - fetch and store role
      try {
        final userService = serviceLocator.userService;
        
        if (kDebugMode) {
          print('🔍 Step 2: Fetching user role from backend...');
        }
        
        final roleString = await userService.getUserRole();
        
        if (kDebugMode) {
          print('✅ Received role from backend: $roleString');
        }
        
        if (roleString.isEmpty) {
          final errorMsg = 'Empty role string received from backend';
          if (kDebugMode) {
            print('❌ $errorMsg');
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to get user role')),
            );
          }
          return;
        }
        
        // Map the backend role string to our UserRole enum
        final role = _mapRoleStringToEnum(roleString);
        if (role == null) {
          final errorMsg = 'Failed to map role string to enum: $roleString';
          if (kDebugMode) {
            print('❌ $errorMsg');
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid user role')),
            );
          }
          return;
        }
        
        if (kDebugMode) {
          print('🔑 Step 3: Setting role in provider: $role');
        }
        
        // Set the role in the provider and SharedPreferences
        final container = ProviderScope.containerOf(context, listen: false);
        await container.read(roleProvider.notifier).setRole(role);
        
        if (kDebugMode) {
          print('✅ Role set in provider successfully');
        }
        
        // If user is a seller, fetch and save their profile data
        if (role == models.UserRole.seller) {
          try {
            if (kDebugMode) {
              print('🔄 Step 4: Fetching seller profile data...');
            }
            
            await userService.getSellerProfile();
            
            if (kDebugMode) {
              print('✅ Successfully fetched and saved seller profile data');
            }
          } catch (e, stackTrace) {
            final errorMsg = 'Error fetching seller profile: $e';
            if (kDebugMode) {
              print('⚠️ $errorMsg');
              print('Stack trace: $stackTrace');
            }
            // Continue to home even if profile fetch fails
          }
        }
        
        // Navigate to home screen after role is set
        if (mounted) {
          if (kDebugMode) {
            print('🏠 Navigation to home screen');
          }
          context.go('/home');
        }
      } catch (e, stackTrace) {
        final errorMsg = 'Error during login: $e';
        if (kDebugMode) {
          print('❌ $errorMsg');
          print('Stack trace: $stackTrace');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during login: ${e.toString()}')),
          );
        }
      }
    } on GoogleSignInAccount catch (e) {
      final errorMsg = 'Google sign in cancelled: $e';
      if (kDebugMode) {
        print('⚠️ $errorMsg');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('google_sign_in_cancelled'.tr())),
        );
      }
    } catch (e, stackTrace) {
      final errorMsg = 'Unexpected error during Google sign in: $e';
      if (kDebugMode) {
        print('❌ $errorMsg');
        print('Stack trace: $stackTrace');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            'https://picsum.photos/seed/googlebg/800/1600',
            fit: BoxFit.cover,
          ),
          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          // Centered content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : SignInButton(
                          Buttons.google,
                          text: 'login_with_google'.tr(),
                          onPressed: _handleGoogleSignIn,
                        ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        'signing_in'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
