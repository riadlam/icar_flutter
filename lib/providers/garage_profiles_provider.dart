import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/garage_profile.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

final garageProfilesProvider = FutureProvider.autoDispose<List<GarageProfile>>((ref) async {
  debugPrint('🔄 Initializing garageProfilesProvider');
  
  // Ensure the service locator is initialized
  try {
    await serviceLocator.ensureInitialized();
  } catch (e, stackTrace) {
    debugPrint('❌ Failed to initialize service locator: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }

  // Get the garage service
  final garageService = serviceLocator.garageService;
  
  try {
    debugPrint('📡 Fetching garage profiles from service...');
    final profiles = await garageService.getGarageProfiles();
    debugPrint('✅ Successfully fetched ${profiles.length} garage profiles');
    return profiles;
  } catch (e, stackTrace) {
    debugPrint('❌ Error in garageProfilesProvider: $e');
    debugPrint('Stack trace: $stackTrace');
    
    // Convert specific errors to more user-friendly messages if needed
    if (e.toString().contains('Connection closed') || 
        e.toString().contains('SocketException')) {
      throw Exception('Unable to connect to the server. Please check your internet connection.');
    } else if (e.toString().contains('401')) {
      throw Exception('Session expired. Please log in again.');
    }
    
    rethrow;
  }
});

// A provider for the selected garage profile
final selectedGarageProfileProvider = StateProvider<GarageProfile?>((ref) => null);

// A provider family for getting a specific garage profile by ID
final garageProfileByIdProvider = FutureProvider.family<GarageProfile?, String>((ref, id) async {
  debugPrint('🔄 Fetching garage profile with ID: $id');
  
  try {
    // Get all profiles
    final profilesAsync = await ref.watch(garageProfilesProvider.future);
    
    // Find the profile with the matching ID
    final profile = profilesAsync.firstWhere(
      (profile) => profile.id.toString() == id,
      orElse: () => throw Exception('Garage profile not found'),
    );
    
    return profile;
  } catch (e, stackTrace) {
    debugPrint('❌ Error in garageProfileByIdProvider: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
});
