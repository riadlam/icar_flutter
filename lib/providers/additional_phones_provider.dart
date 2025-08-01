import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icar_instagram_ui/models/additional_phone.dart';
import 'package:icar_instagram_ui/providers/car_profile_provider.dart';

class AdditionalPhonesNotifier extends StateNotifier<AsyncValue<List<AdditionalPhone>>> {
  final Ref ref;
  
  AdditionalPhonesNotifier(this.ref) : super(const AsyncValue.loading());
  
  Future<String?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> loadPhones(String userId) async {
    state = const AsyncValue.loading();
    try {
      final currentUserId = await _getCurrentUserId();
      if (currentUserId == null) {
        throw Exception('User not logged in');
      }
      final carProfileService = ref.read(carProfileProvider);
      final response = await carProfileService.getUserAdditionalPhones(currentUserId);
      if (response['success'] == true) {
        final phonesData = (response['data']['phones'] as List)
            .map((phone) => AdditionalPhone.fromJson(phone))
            .toList();
        state = AsyncValue.data(phonesData);
      } else {
        state = AsyncValue.error(
          response['message'] ?? 'Failed to load phone numbers',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh(String userId) async {
    await loadPhones(userId);
  }

  Future<void> addPhoneNumber(String phoneNumber) async {
    try {
      final carProfileService = ref.read(carProfileProvider);
      final currentUserId = await _getCurrentUserId();
      if (currentUserId == null) {
        throw Exception('User not logged in');
      }
      final response = await carProfileService.addPhoneNumber(phoneNumber);
      if (response['success'] == true) {
        await loadPhones(currentUserId);
      } else {
        throw Exception(response['message'] ?? 'Failed to add phone number');
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> deletePhone(String userId, String phoneId) async {
    try {
      final carProfileService = ref.read(carProfileProvider);
      final response = await carProfileService.deletePhoneNumber(phoneId);
      
      if (response['success'] == true) {
        // Refresh the list after successful deletion
        await loadPhones(userId);
      } else {
        throw Exception(response['message'] ?? 'Failed to delete phone number');
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}

final additionalPhonesProvider = StateNotifierProvider<AdditionalPhonesNotifier, AsyncValue<List<AdditionalPhone>>>(
  (ref) => AdditionalPhonesNotifier(ref),
);
