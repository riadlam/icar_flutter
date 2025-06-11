import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icar_instagram_ui/models/garage_service.dart';
import 'package:icar_instagram_ui/models/garage_profile.dart';
import 'package:icar_instagram_ui/widgets/cards/garage_service_card.dart';
import 'package:icar_instagram_ui/widgets/garage/add_garage_form_sheet.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';
import 'package:icar_instagram_ui/providers/garage_profiles_provider.dart';

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
      final googleEmail = prefs.getString('user_email') ?? '';

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
        _currentService = _currentService.copyWith(
          businessName: 'error_loading_profile'.tr(),
          ownerName: 'n/a'.tr(),
          phoneNumber: 'n/a'.tr(),
          location: 'please_try_again_later'.tr(),
        );
      });
    }
    debugPrint('❌ Error loading garage profile data: $e');
  }
}


  Future<void> _handleUpdateService(
    String name,
    String city,
    String phone,
    List<String> services,
  ) async {
    if (mounted) {
      setState(() {
        _currentService = _currentService.copyWith(
          businessName: name,
          services: services,
          ownerName: name, // Using the same name for business and owner for now
          phoneNumber: phone,
          location: city,
        );
      });
    }
  }

  // Convert GarageProfile to GarageService for editing
  GarageService _profileToService(GarageProfile profile) {
    return GarageService(
      id: profile.id.toString(),
      businessName: profile.businessName,
      ownerName: profile.mechanicName,
      phoneNumber: profile.mobile,
      location: profile.city,
      imageUrl: 'https://example.com/garage_placeholder.jpg',
      services: profile.services ?? [],
    );
  }

  /// Converts a [GarageService] back to a [GarageProfile] after editing
  GarageProfile _serviceToProfile(GarageService service, GarageProfile originalProfile) {
    // Ensure we have valid values for all required fields
    final now = DateTime.now();
    final businessName = service.businessName.isEmpty ? 'No Business Name' : service.businessName;
    final mechanicName = service.ownerName.isEmpty ? 'No Name' : service.ownerName;
    final phoneNumber = service.phoneNumber.isEmpty ? 'N/A' : service.phoneNumber;
    final location = service.location.isEmpty ? 'No City' : service.location;
    
    return GarageProfile(
      id: int.tryParse(service.id) ?? 0,
      userId: originalProfile.userId,
      businessName: businessName,
      mechanicName: mechanicName,
      mobile: phoneNumber,
      city: location,
      services: service.services,
      createdAt: originalProfile.createdAt,
      updatedAt: now,
    );
  }

  void _showEditForm(GarageProfile profile) {
    final service = _profileToService(profile);
    // Get the first part of the location (city) or empty string if location is empty
    final city = service.location.split(',').firstOrNull?.trim() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddGarageFormSheet(
        initialName: service.businessName,
        initialCity: city,
        initialPhone: service.phoneNumber,
        initialServices: service.services ?? [],
        onSubmit: (name, city, phone, services) {
          _handleUpdateService(name, city, phone, services);
        },
      ),
    );
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
                                onSubmit: _handleUpdateService,
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
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Add Garage Profile',
                                  style: TextStyle(
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
