import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import '../models/user_role.dart';

final roleProvider =
    StateNotifierProvider<RoleNotifier, AsyncValue<UserRole?>>((ref) {
  return RoleNotifier()..loadRole();
});

class RoleNotifier extends StateNotifier<AsyncValue<UserRole?>> {
  static const String _roleKey = 'user_role';

  RoleNotifier() : super(const AsyncValue.loading());

  // Map role strings to UserRole enum
  /// Maps a raw role string (from backend or other sources) to the UserRole enum.
  /// Adds detailed logs to trace the mapping process and help with debugging.
  UserRole _mapRoleString(String roleString) {
    print('[Role Mapping] Mapping role string: $roleString');
    try {
      // If the string is already in the format 'UserRole.role', extract the role name and match directly.
      if (roleString.startsWith('UserRole.')) {
        final roleName = roleString.split('.').last.toLowerCase();
        // Try to find the UserRole enum value that matches the extracted role name.
        return UserRole.values.firstWhere(
          (role) => role.toString().toLowerCase() == 'userrole.$roleName',
        );
      }

      // Normalize the role string for consistent comparison (lowercase, trimmed).
      final lowerRole = roleString.toLowerCase().trim();

      // Log the normalized role string being checked.
      developer.log(
          '[Role Mapping] Checking normalized role string: $lowerRole',
          name: 'RoleNotifier');

      // Map all possible role strings to our UserRole enum, with logs for each mapping path.
      switch (lowerRole) {
        // Buyer roles
        case 'car_seller':
        case 'userrole.buyer':
          developer.log('[Role Mapping] "$lowerRole" mapped to UserRole.buyer',
              name: 'RoleNotifier');
          return UserRole.buyer;
        case 'spare_parts_seller':
          developer.log(
              '[Role Mapping] "spare_parts_seller" mapped to UserRole.seller',
              name: 'RoleNotifier');
          return UserRole.seller;

        // seller role
        case 'userrole.seller':
          developer.log('[Role Mapping] "$lowerRole" mapped to UserRole.seller',
              name: 'RoleNotifier');
          return UserRole.seller;

        // Mechanic roles
        case 'mechanic':
        case 'tow_truck':
        case 'userrole.mechanic':
          developer.log(
              '[Role Mapping] "$lowerRole" mapped to UserRole.mechanic',
              name: 'RoleNotifier');
          return UserRole.mechanic;

        // Other/garage roles
        case 'garage':
        case 'garage_owner':
        case 'userrole.other':
          developer.log('[Role Mapping] "$lowerRole" mapped to UserRole.other',
              name: 'RoleNotifier');
          return UserRole.other;

        // Fallback: Try to match the normalized string to any UserRole enum value.
        default:
          developer.log(
              '[Role Mapping] "$lowerRole" did not match any direct case, attempting enum fallback...',
              name: 'RoleNotifier');
          final mappedRole = UserRole.values.firstWhere(
            (role) =>
                role.toString().toLowerCase() ==
                'userrole.${lowerRole.toLowerCase()}',
            orElse: () => UserRole.other,
          );
          developer.log('[Role Mapping] Fallback mapping result: $mappedRole',
              name: 'RoleNotifier');
          return mappedRole;
      }
    } catch (e) {
      // Log errors if mapping fails for any reason.
      developer.log('Error mapping role string: $roleString',
          name: 'RoleNotifier');
      developer.log('Error details: $e', name: 'RoleNotifier');
      // Default to 'other' on any error to avoid crashes.
      return UserRole.other;
    }
  }

  Future<void> loadRole() async {
    print('[RoleNotifier] Loading role from SharedPreferences...');
    try {
      state = const AsyncValue.loading();
      final prefs = await SharedPreferences.getInstance();
      final roleString = prefs.getString(_roleKey);
      print('[RoleNotifier] Loaded role string from SharedPreferences: '
          '\x1B[32m\x1B[1m$roleString\x1B[0m');

      if (roleString == null) {
        developer.log('No saved role found in SharedPreferences',
            name: 'RoleNotifier');
        state = const AsyncValue.data(null);
        return;
      }

      // Use our mapping function to handle different role string formats
      final role = _mapRoleString(roleString);
      print('[RoleNotifier] Mapped role string to enum: '
          '\x1B[36m\x1B[1m$role\x1B[0m');
      developer.log('Successfully mapped role: $roleString -> $role',
          name: 'RoleNotifier');
      state = AsyncValue.data(role);
    } catch (e, stackTrace) {
      developer.log('Error loading role: $e',
          name: 'RoleNotifier', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setRole(UserRole role) async {
    try {
      state = AsyncValue.data(role);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_roleKey, role.toString());
      developer.log('Saved role to SharedPreferences: $role',
          name: 'RoleNotifier');
    } catch (e, stackTrace) {
      developer.log('Error saving role: $e',
          name: 'RoleNotifier', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> clearRole() async {
    try {
      state = const AsyncValue.data(null);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_roleKey);
      developer.log('Cleared role from SharedPreferences',
          name: 'RoleNotifier');
    } catch (e, stackTrace) {
      developer.log('Error clearing role: $e',
          name: 'RoleNotifier', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
