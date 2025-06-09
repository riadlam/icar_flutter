import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import '../models/user_role.dart';

final roleProvider = StateNotifierProvider<RoleNotifier, AsyncValue<UserRole?>>((ref) {
  return RoleNotifier()..loadRole();
});

class RoleNotifier extends StateNotifier<AsyncValue<UserRole?>> {
  static const String _roleKey = 'user_role';
  
  RoleNotifier() : super(const AsyncValue.loading());

  // Map role strings to UserRole enum
  UserRole _mapRoleString(String roleString) {
    try {
      // First, check if the string is already in the format 'UserRole.role'
      if (roleString.startsWith('UserRole.')) {
        final roleName = roleString.split('.').last.toLowerCase();
        return UserRole.values.firstWhere(
          (role) => role.toString().toLowerCase() == 'userrole.$roleName',
        );
      }
      
      // Handle raw role strings (from backend or other sources)
      final lowerRole = roleString.toLowerCase().trim();
      
      // Map all possible role strings to our UserRole enum
      switch (lowerRole) {
        case 'seller':
        case 'car_seller':
        case 'spare_parts_seller':
        case 'userrole.seller':
          return UserRole.seller;
          
        case 'mechanic':
        case 'tow_truck':
        case 'userrole.mechanic':
          return UserRole.mechanic;
          
        case 'garage':
        case 'garage_owner':
        case 'userrole.other':
          return UserRole.other;
          
        case 'buyer':
        case 'userrole.buyer':
          return UserRole.buyer;
          
        default:
          // Try to find a matching role by name in the enum values as a fallback
          return UserRole.values.firstWhere(
            (e) => e.toString().toLowerCase() == 'userrole.$lowerRole',
            orElse: () => UserRole.other, // Default to 'other' if no match found
          );
      }
    } catch (e) {
      developer.log('Error mapping role string: $roleString', name: 'RoleNotifier');
      developer.log('Error details: $e', name: 'RoleNotifier');
      return UserRole.other; // Default to 'other' on any error
    }
  }

  Future<void> loadRole() async {
    try {
      state = const AsyncValue.loading();
      final prefs = await SharedPreferences.getInstance();
      final roleString = prefs.getString(_roleKey);
      
      if (roleString == null) {
        developer.log('No saved role found in SharedPreferences', name: 'RoleNotifier');
        state = const AsyncValue.data(null);
        return;
      }
      
      // Use our mapping function to handle different role string formats
      final role = _mapRoleString(roleString);
      
      developer.log('Successfully mapped role: $roleString -> $role', name: 'RoleNotifier');
      state = AsyncValue.data(role);
    } catch (e, stackTrace) {
      developer.log('Error loading role: $e', 
                   name: 'RoleNotifier', 
                   error: e, 
                   stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setRole(UserRole role) async {
    try {
      state = AsyncValue.data(role);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_roleKey, role.toString());
      developer.log('Saved role to SharedPreferences: $role', name: 'RoleNotifier');
    } catch (e, stackTrace) {
      developer.log('Error saving role: $e', 
                   name: 'RoleNotifier', 
                   error: e, 
                   stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> clearRole() async {
    try {
      state = const AsyncValue.data(null);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_roleKey);
      developer.log('Cleared role from SharedPreferences', name: 'RoleNotifier');
    } catch (e, stackTrace) {
      developer.log('Error clearing role: $e', 
                   name: 'RoleNotifier', 
                   error: e, 
                   stackTrace: stackTrace);
      rethrow;
    }
  }
}
