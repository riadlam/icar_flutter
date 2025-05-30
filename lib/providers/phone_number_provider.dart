import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:logging/logging.dart';

final _logger = Logger('PhoneNumberNotifier');

final phoneNumberProvider = StateNotifierProvider<PhoneNumberNotifier, AsyncValue<List<String>>>(
  (ref) => PhoneNumberNotifier(),
);

class PhoneNumberNotifier extends StateNotifier<AsyncValue<List<String>>> {
  PhoneNumberNotifier() : super(const AsyncLoading()) {
    _initialize();
  }

  final _carProfileService = serviceLocator.carProfileService;
  
  Future<void> _initialize() async {
    try {
      await _carProfileService.initialize();
      await _loadPhoneNumbers();
    } catch (e, stackTrace) {
      _logger.severe('Failed to initialize PhoneNumberNotifier', e, stackTrace);
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> _loadPhoneNumbers() async {
    try {
      state = const AsyncLoading();
      
      // TODO: Implement loading phone numbers from API
      // For now, initialize with an empty list
      state = const AsyncData([]);
    } catch (e, stackTrace) {
      _logger.severe('Failed to load phone numbers', e, stackTrace);
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> addPhoneNumber(String phoneNumber) async {
    if (state.isLoading) return;
    
    try {
      // Show loading state
      state = const AsyncLoading();
      
      // Call the API to add the phone number
      final response = await _carProfileService.addPhoneNumber(phoneNumber);
      
      if (response['success'] == true) {
        // Parse the response and update the state
        final currentNumbers = await _getCurrentPhoneNumbers();
        if (!currentNumbers.contains(phoneNumber)) {
          state = AsyncData([...currentNumbers, phoneNumber]);
        } else {
          state = AsyncData(currentNumbers);
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to add phone number');
      }
    } catch (e, stackTrace) {
      _logger.severe('Failed to add phone number', e, stackTrace);
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<List<String>> _getCurrentPhoneNumbers() async {
    return state.when(
      data: (numbers) => List<String>.from(numbers),
      loading: () => [],
      error: (_, __) => [],
    );
  }

  Future<void> removePhoneNumber(String phoneNumber) async {
    if (state.isLoading) return;
    
    try {
      // TODO: Implement remove phone number API call
      // For now, just update the local state
      final currentNumbers = await _getCurrentPhoneNumbers();
      state = AsyncData(
        currentNumbers.where((number) => number != phoneNumber).toList(),
      );
    } catch (e, stackTrace) {
      _logger.severe('Failed to remove phone number', e, stackTrace);
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }
}
