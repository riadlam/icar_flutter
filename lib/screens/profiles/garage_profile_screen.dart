import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/models/garage_service.dart';
import 'package:icar_instagram_ui/models/garage_profile.dart';
import 'package:icar_instagram_ui/widgets/cards/garage_service_card.dart';
import 'package:icar_instagram_ui/widgets/garage/add_garage_form_sheet.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';
import 'package:icar_instagram_ui/providers/garage_profiles_provider.dart';
import 'package:go_router/go_router.dart';

// Extension to make it easier to create a copy of the service with updated fields
extension GarageServiceX on GarageService {
  GarageService copyWith({
    String? businessName,
    String? ownerName,
    String? phoneNumber,
    String? location,
    String? email,
    bool? isFavorite,
    List<String>? services,
  }) {
    return GarageService(
      id: id,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      services: services ?? this.services,
      rating: rating,
      reviews: reviews,
    );
  }
}

class GarageProfileScreen extends ConsumerStatefulWidget {
  const GarageProfileScreen({super.key});

  @override
  ConsumerState<GarageProfileScreen> createState() => _GarageProfileScreenState();
}

class _GarageProfileScreenState extends ConsumerState<GarageProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  late GarageService _currentService;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    // Initialize with default values that will be overridden by the provider
    _currentService = GarageService(
      id: '1',
      businessName: 'Loading...',
      ownerName: '',
      phoneNumber: '',
      location: '',
      isFavorite: false,
      imageUrl: 'https://images.unsplash.com/photo-1584917865445-d0a8a01f2a9a',
      services: const [],
      rating: 4.5,
      reviews: 128,
    );
    
    // Load profile data if available
    _loadProfileData();
  }

Future<void> _loadProfileData() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Check if garage owner profile exists and is not empty
    String? data = prefs.getString('user_profile_data_garage_owner');
    if (data != null && data.isNotEmpty) {
      debugPrint('📦 Loaded from user_profile_data_garage_owner: $data');

      final decodedData = jsonDecode(data) as Map<String, dynamic>;
      
      // Get the profile ID, defaulting to 0 if not found (which will trigger creation of a new profile)
      final profileId = decodedData['id']?.toString() ?? '0';
      debugPrint('🔑 Loaded profile ID: $profileId');

      if (mounted) {
        setState(() {
          final services = decodedData['services'] is List
              ? List<String>.from(decodedData['services'])
              : <String>[];

          // Create a new GarageService instance with the updated data
          _currentService = GarageService(
            id: profileId,
            businessName: decodedData['mechanic_name']?.toString() ?? '',
            ownerName: decodedData['mechanic_name']?.toString() ?? '',
            phoneNumber: decodedData['mobile']?.toString() ?? '',
            location: decodedData['city']?.toString() ?? 'location_not_set'.tr(),
            imageUrl: _currentService.imageUrl, // Keep the existing image URL
            services: services,
          );
        });
      }
      return; // Exit early since data was found
    }

    // Fallback to garage
    data = prefs.getString('user_profile_data_garage');
    if ((data == null || data.isEmpty) && prefs.containsKey('user_profile_data_other')) {
      data = prefs.getString('user_profile_data_other');
    }

    final googleEmail = prefs.getString('user_email') ?? '';

    if (data != null && data.isNotEmpty) {
      debugPrint('📦 Loaded from garage/other fallback: $data');

      final decodedData = jsonDecode(data) as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          final services = decodedData['services'] is List
              ? List<String>.from(decodedData['services'])
              : <String>[];

          _currentService = _currentService.copyWith(
            businessName: decodedData['mechanic_name']?.toString() ?? '',
            ownerName: decodedData['mechanic_name']?.toString() ?? '',
            phoneNumber: decodedData['mobile']?.toString() ?? '',
            location: decodedData['city']?.toString() ?? 'location_not_set'.tr(),
            email: googleEmail.isNotEmpty ? googleEmail : (decodedData['email']?.toString() ?? ''),
            services: services,
          );
        });
      }
    } else {
      // Fallback to buyer
      final buyerData = prefs.getString('user_profile_data_buyer');
      if (buyerData != null && buyerData.isNotEmpty) {
        debugPrint('📦 Loaded from buyer fallback: $buyerData');

        final decodedData = jsonDecode(buyerData) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            final services = decodedData['services'] is List
                ? List<String>.from(decodedData['services'])
                : <String>[];

            _currentService = _currentService.copyWith(
              businessName: decodedData['showroomName']?.toString() ?? 'garage'.tr(),
              ownerName: decodedData['fullName']?.toString() ?? '',
              phoneNumber: decodedData['mobile']?.toString() ?? '',
              location: decodedData['city']?.toString() ?? 'location_not_set'.tr(),
              email: decodedData['email']?.toString() ?? '',
              services: services,
            );
          });
        }
      }
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _currentService = GarageService(
          id: _currentService.id,
          businessName: 'error_loading_profile'.tr(),
          ownerName: 'n/a'.tr(),
          phoneNumber: 'n/a'.tr(),
          location: 'please_try_again_later'.tr(),
          imageUrl: _currentService.imageUrl,
          services: _currentService.services,
        );
      });
    }
    debugPrint('❌ Error loading garage profile data: $e');
  }
}


  Future<void> _showEditForm(GarageProfile profile) async {
    // Don't allow opening multiple edit forms
    if (_isUpdating) return;

    debugPrint('🔄 _showEditForm called for profile ID: ${profile.id} (${profile.id.runtimeType})');
    
    // Store the profile ID before any async operations
    final profileId = profile.id;
    debugPrint('🔑 Stored profile ID for update: $profileId (${profileId.runtimeType})');
    
    // Validate the profile ID
    if (profileId <= 0) {
      debugPrint('❌ Invalid profile ID: $profileId - Must be greater than 0');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Invalid profile ID. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    
    // Convert to service for the form
    final service = _profileToService(profile);
    debugPrint('🔍 Converted to service with ID: ${service.id} (${service.id.runtimeType})');
    
    // Get the first part of the location (city) or empty string if location is empty
    final parts = service.location.split(',');
    final city = parts.isNotEmpty ? parts.first.trim() : '';
    final profilesValue = ref.read(garageProfilesProvider).value;
    final isLastProfile = profilesValue != null && profile == profilesValue.last;

    // Create a GlobalKey to access the form state
    final formKey = GlobalKey<FormState>();
    
    // Show the edit form
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddGarageFormSheet(
        key: formKey,
        initialName: service.businessName,
        initialCity: city,
        initialPhone: service.phoneNumber,
        initialServices: service.services ?? [],
        profileId: profileId, // Pass the profileId to the form
        onSubmit: (name, city, phone, services) {
          // Validate the form
          if (formKey.currentState?.validate() ?? false) {
            // Return the form data to the caller
            Navigator.of(context).pop({
              'name': name,
              'city': city,
              'phone': phone,
              'services': services,
            });
          }
        },
        showDeleteButton: !isLastProfile,
        onDelete: isLastProfile
            ? null
            : () {
                Navigator.of(context).pop(null); // Close with null to indicate delete
              },
      ),
    );

    // Handle the form submission
    if (result == null) {
      // Delete was requested (null is returned when delete is pressed)
      _deleteProfile(profile);
    } else if (result.isNotEmpty) {
      // Update was requested - use the stored profile ID
      debugPrint('🔄 Calling _handleUpdateService with profileId: $profileId (${profileId.runtimeType})');
      try {
        await _handleUpdateService(
          profileId.toString(),  // Convert to string for consistency
          result['name'] as String,
          result['city'] as String,
          result['phone'] as String,
          (result['services'] as List).cast<String>(),
        );
      } catch (e) {
        debugPrint('❌ Error in _handleUpdateService: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleUpdateService(
    String profileId,
    String name,
    String city,
    String phone,
    List<String> services,
  ) async {
    debugPrint('🔄 _handleUpdateService called with profileId: $profileId (${profileId.runtimeType})');
    if (!mounted || _isUpdating) return;

    setState(() => _isUpdating = true);

    // Get the current context before any async operations
    final currentContext = context;
    final router = GoRouter.of(currentContext);
    
    try {
      debugPrint('🔍 Current _currentService.id: ${_currentService.id} (${_currentService.id.runtimeType})');
      
      // Validate the profile ID
      if (profileId.isEmpty || profileId == '0') {
        throw Exception('Invalid profile ID: $profileId - Cannot be empty or zero');
      }
      
      // Get the garage service instance using service locator
      final garageService = serviceLocator.garageService;
      
      // Parse the profile ID to int for the API call
      debugPrint('🔍 Attempting to parse profileId: $profileId');
      final profileIdInt = int.tryParse(profileId);
      
      if (profileIdInt == null) {
        throw Exception('Invalid profile ID format: $profileId - Must be a number');
      }
      
      debugPrint('✅ Successfully parsed profileIdInt: $profileIdInt (${profileIdInt.runtimeType})');
      
      // Log the data being sent to the API
      debugPrint('📤 Sending update request with:');
      debugPrint('  - ID: $profileIdInt');
      debugPrint('  - Business Name: $name');
      debugPrint('  - City: $city');
      debugPrint('  - Phone: $phone');
      debugPrint('  - Services: ${services.join(', ')}');
      
      // Make the API call
      final response = await garageService.updateGarageProfile(
        id: profileIdInt,
        businessName: name,
        mechanicName: name,
        mobile: phone,
        city: city,
        services: services,
      );

      debugPrint('✅ API Response: $response');
      
      if (!mounted) return;
      
      // Close any open dialogs or bottom sheets safely
      if (Navigator.of(currentContext, rootNavigator: true).canPop()) {
        debugPrint('🔽 Closing any open dialogs or bottom sheets');
        Navigator.of(currentContext, rootNavigator: true).pop();
        // Wait for the navigation to complete
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      // Invalidate the provider to force a refresh
      debugPrint('🔄 Invalidating garageProfilesProvider to refresh data');
      ref.invalidate(garageProfilesProvider);
      
      // Show success message
      if (mounted) {
        // Use a post-frame callback to ensure the UI is stable
        WidgetsBinding.instance.addPostFrameCallback((_) {
          debugPrint('🎉 Showing success message');
          // Show the success message
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Force a refresh of the profile data
          debugPrint('🔄 Refreshing profile data after update');
          _loadProfileData();
        });
      }
    } catch (e) {
      if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  // Convert GarageProfile to GarageService for editing
  GarageService _profileToService(GarageProfile profile) {
    debugPrint('🔄 Converting GarageProfile to GarageService');
    debugPrint('  - Profile ID: ${profile.id} (${profile.id.runtimeType})');
    debugPrint('  - Business Name: ${profile.businessName}');
    debugPrint('  - Services: ${profile.services?.join(', ') ?? 'None'}');
    
    final service = GarageService(
      id: profile.id.toString(),
      businessName: profile.businessName,
      ownerName: profile.mechanicName,
      phoneNumber: profile.mobile,
      location: profile.city,
      imageUrl: 'https://example.com/garage_placeholder.jpg',
      services: profile.services ?? [],
      isFavorite: false,
      rating: 0.0,
      reviews: 0,
    );
    
    debugPrint('  - Created GarageService with ID: ${service.id} (${service.id.runtimeType})');
    return service;
  }

  /// Converts a [GarageService] back to a [GarageProfile] after editing
  GarageProfile _serviceToProfile(GarageService service, GarageProfile originalProfile) {
    debugPrint('🔄 Converting GarageService to GarageProfile');
    debugPrint('  - Service ID: ${service.id} (${service.id.runtimeType})');
    debugPrint('  - Original Profile ID: ${originalProfile.id} (${originalProfile.id.runtimeType})');
    
    // Ensure we have valid values for all required fields
    final now = DateTime.now();
    final businessName = service.businessName.isEmpty ? 'No Business Name' : service.businessName;
    final mechanicName = service.ownerName.isEmpty ? 'No Name' : service.ownerName;
    final phoneNumber = service.phoneNumber.isEmpty ? 'N/A' : service.phoneNumber;
    final location = service.location.isEmpty ? 'No City' : service.location;
    
    // Parse the ID, ensuring we don't lose it during conversion
    final parsedId = int.tryParse(service.id) ?? originalProfile.id;
    debugPrint('  - Parsed ID: $parsedId (${parsedId.runtimeType})');
    
    final profile = GarageProfile(
      id: parsedId,
      userId: originalProfile.userId,
      businessName: businessName,
      mechanicName: mechanicName,
      mobile: phoneNumber,
      city: location,
      services: service.services,
      createdAt: originalProfile.createdAt,
      updatedAt: now,
    );
    
    debugPrint('  - Created GarageProfile with ID: ${profile.id} (${profile.id.runtimeType})');
    return profile;
  }

  Future<void> _deleteProfile(GarageProfile profile) async {
    if (!mounted) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_profile'.tr()),
        content: Text('delete_profile_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Use a local context reference
    final currentContext = this.context;
    final scaffoldMessenger = ScaffoldMessenger.of(currentContext);
    
    // Show loading indicator
    showDialog(
      context: currentContext,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Call the delete API
      final success = await serviceLocator.garageService
          .deleteGarageProfile(profile.id.toString());
      
      if (!mounted) return;
      
      // Close loading dialog
      Navigator.of(context, rootNavigator: true).pop();
      
      if (success) {
        // Show success message
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('profile_deleted_successfully'.tr()),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Invalidate the provider to refresh the list
        ref.invalidate(garageProfilesProvider);
        
        // Close the bottom sheet if it's still open
        if (Navigator.of(currentContext).canPop()) {
          Navigator.of(currentContext).pop();
        }
      } else {
        throw Exception('Failed to delete profile');
      }
    } catch (e) {
      if (!mounted) return;
      
      // Close loading dialog if still open
      if (Navigator.of(currentContext, rootNavigator: true).canPop()) {
        Navigator.of(currentContext, rootNavigator: true).pop();
      }
      
      // Show error message
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('error_deleting_profile'.tr() + ': ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TowTruckNavBar(
        scaffoldKey: _scaffoldKey,
        title: 'app_title'.tr(),
      ),
      endDrawer: TowTruckNavBar.buildDrawer(context),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            final profilesAsync = ref.watch(garageProfilesProvider);
            
            return profilesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (profiles) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (profiles.isEmpty)
                        const Center(child: Text('No garage profiles found'))
                      else ...[
                        // Show LAST card first
                        GarageServiceCard(
                          service: _profileToService(profiles.last),
                          onTap: () {},
                          onFavoritePressed: () {
                            // Handle favorite
                          },
                          onEditPressed: () => _showEditForm(profiles.last),
                          isProfileView: true,
                        ),
                        const SizedBox(height: 16),
                        
                        // Add Garage Button
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => AddGarageFormSheet(
                                onSubmit: (name, city, phone, services) {
                                  // When the form is submitted, call _handleUpdateService with the profile ID
                                  return _handleUpdateService(
                                    _currentService.id.toString(),
                                    name,
                                    city,
                                    phone,
                                    services,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'add_garage_profile'.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Show all EXCEPT last card after button
                        ...profiles.take(profiles.length - 1).map((profile) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GarageServiceCard(
                              service: _profileToService(profile),
                              onTap: () {},
                              onFavoritePressed: () {
                                // Handle favorite
                              },
                              onEditPressed: () => _showEditForm(profile),
                              isProfileView: true,
                            ),
                          ),
                        ).toList(),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
