import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/additional_phone.dart';
import 'package:icar_instagram_ui/providers/car_profile_provider.dart';

class AdditionalPhonesNotifier extends StateNotifier<AsyncValue<List<AdditionalPhone>>> {
  final Ref ref;
  
  AdditionalPhonesNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadPhones('1'); // Default to user ID 1, you might want to make this dynamic
  }

  Future<void> loadPhones(String userId) async {
    state = const AsyncValue.loading();
    try {
      final carProfileService = ref.read(carProfileProvider);
      final response = await carProfileService.getUserAdditionalPhones(userId);
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
