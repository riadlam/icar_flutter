import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_role.dart';

final roleProvider = StateNotifierProvider<RoleNotifier, UserRole?>((ref) {
  return RoleNotifier();
});

class RoleNotifier extends StateNotifier<UserRole?> {
  RoleNotifier() : super(null);

  void setRole(UserRole role) {
    state = role;
  }

  UserRole? get currentRole => state;
}
