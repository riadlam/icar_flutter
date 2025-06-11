import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
  // Handle authentication token storage and logging
  Future<void> _handleAuthToken(FlutterSecureStorage storage, Map<String, dynamic> response, SharedPreferences prefs) async {
    final token = await storage.read(key: 'auth_token');
    
    // Check if we need to save the auth token
    if (token == null) {
      // If token is not in secure storage, try to get it from the response
      final authToken = response['token'] as String?;
      if (authToken != null && authToken.isNotEmpty) {
        await storage.write(key: 'auth_token', value: authToken);
        if (kDebugMode) {
          print('🔑 Saved auth token to secure storage');
          // Log the first 10 characters and last 5 characters of the token for verification
          final tokenPreview = '${authToken.substring(0, 10 < authToken.length ? 10 : authToken.length)}...${authToken.length > 15 ? authToken.substring(authToken.length - 5) : ''}';
          print('   Token preview: $tokenPreview (${authToken.length} chars)');
        }
      } else if (kDebugMode) {
        print('⚠️ No auth token found in response');
      }
    }
  }

  // Handle user ID storage and logging
  Future<void> _handleUserId(Map<String, dynamic> response, SharedPreferences prefs) async {
    final userId = prefs.getString('user_id');
    if (userId == null || userId.isEmpty) {
      // Try to get user ID from the response
      if (response['user'] is Map) {
        final newUserId = response['user']['id'].toString();
        await prefs.setString('user_id', newUserId);
        if (kDebugMode) {
          print('👤 Saved user ID to SharedPreferences: $newUserId');
        }
      } else if (kDebugMode) {
        print('⚠️ No user ID found in response');
      }
    }
  }
  bool _isLoading = false;

  /// Maps the backend role string to the app's UserRole enum
  /// 
  /// Role mappings:
  /// - car_seller → UserRole.seller
  /// - tow_truck → UserRole.mechanic
  /// - garage_owner → UserRole.other
  /// 
  /// Returns UserRole.other if no match is found
  models.UserRole _mapRoleStringToEnum(String role) {
    if (kDebugMode) {
      print('🔍 Mapping role string to enum: $role');
    }
    
    // Convert to lowercase for case-insensitive comparison
    final lowerRole = role.toLowerCase().trim();
    
    // Map role strings to UserRole enum
    switch (lowerRole) {
      case 'car_seller':
      case 'spare_parts_seller':
        if (kDebugMode) {
          print('✅ Mapped $role to UserRole.seller');
        }
        return models.UserRole.seller;
        
      case 'tow_truck':
      case 'mechanic':
        if (kDebugMode) {
          print('🔧 Mapped $role to UserRole.mechanic');
        }
        return models.UserRole.mechanic;
        
      case 'garage_owner':
      case 'garage':
        if (kDebugMode) {
          print('🏢 Mapped $role to UserRole.other (garage)');
        }
        return models.UserRole.other;
        
      // Handle any other cases or unknown roles
      default:
        if (kDebugMode) {
          print('⚠️ Unknown role string: $role');
        }
        // Try to find a matching role by name in the enum values as a fallback
        try {
          final enumValue = models.UserRole.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() == lowerRole,
            orElse: () => models.UserRole.other,
          );
          if (kDebugMode) {
            print('ℹ️ Mapped $role to $enumValue using fallback');
          }
          return enumValue;
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Error mapping role, defaulting to UserRole.other: $e');
          }
          return models.UserRole.other;
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
      
      if (!mounted) return;
      
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
        // Existing user - fetch profile data and then go to home
        if (kDebugMode) {
          print('👤 Existing user detected, fetching profile data...');
        }
        
        try {
          // Get user service and auth service from the service locator
          final userService = serviceLocator.userService;
          final storage = FlutterSecureStorage();
          
          // Get the user's role
          final role = await userService.getUserRole();
          if (kDebugMode) {
            print('🔍 Fetched user role: $role');
          }
          
          // Initialize SharedPreferences once
          final prefs = await SharedPreferences.getInstance();
          
          // Handle authentication token
          await _handleAuthToken(storage, response, prefs);
          
          // Handle user ID
          await _handleUserId(response, prefs);
          
          // Fetch profile data based on role
          await userService.getUserProfileByRole(role);
          
          if (kDebugMode) {
            print('✅ Successfully fetched and stored profile data');
          }
          
          // Map the role string to UserRole enum and save it
          final userRole = _mapRoleStringToEnum(role);
          if (kDebugMode) {
            print('🔀 Mapped role "$role" to UserRole: $userRole');
          }
          
          // Save the mapped role to SharedPreferences
          await prefs.setString('user_role', userRole.toString());
          
          // Also update the role provider
          if (mounted) {
            ref.read(roleProvider.notifier).setRole(userRole);
          }
          
          if (kDebugMode) {
            print('✅ Saved user role: ${userRole.toString()}');
            print('🏠 Redirecting to home screen');
          }
          
          if (mounted) {
            context.go('/home');
          }
        } catch (e, stackTrace) {
          if (kDebugMode) {
            print('❌ Error during login process: $e');
            print('Stack trace: $stackTrace');
          }
          
          if (mounted) {
            // Still go to home even if there's an error
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An error occurred during login'),
                backgroundColor: Colors.red,
              ),
            );
            context.go('/home');
          }
        }
        return;
      }
      
      if (userData != null) {
        try {
          final prefs = await SharedPreferences.getInstance();
          final role = _mapRoleStringToEnum(userData['role']?.toString() ?? '');
          
          if (role != null) {
            final storageKey = 'user_profile_data_${role.name}';
            final userDataJson = jsonEncode(userData);
            
            await prefs.setString(storageKey, userDataJson);
            
            if (userData['id'] != null) {
              await prefs.setString('user_id', userData['id'].toString());
            }
            
            if (kDebugMode) {
              print('💾 STORED USER PROFILE DATA');
              print('   Storage Key: $storageKey');
              print('   User ID: ${userData['id']}');
              print('   User Role: ${role.name}');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Error storing user profile data: $e');
          }
        }
      }
      
      if (kDebugMode) {
        print('✅ Existing user login complete');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error during login: $e');
        print('Stack trace: $stackTrace');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during login: ${e.toString()}')),
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
