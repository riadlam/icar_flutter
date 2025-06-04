import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icar_instagram_ui/models/garage_service.dart';
import 'package:icar_instagram_ui/widgets/cards/garage_service_card.dart';
import 'package:icar_instagram_ui/widgets/garage/add_garage_form_sheet.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';

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
      
      // Try to load garage profile data first
      var data = prefs.getString('user_profile_data_garage');
      
      // If not found, try loading from 'other' role data
      if ((data == null || data.isEmpty) && prefs.containsKey('user_profile_data_other')) {
        data = prefs.getString('user_profile_data_other');
      }
      
      // Get email from Google login if available
      final googleEmail = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('user_email') ?? '');
          
      if (data != null && data.isNotEmpty) {
        final decodedData = jsonDecode(data) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            final services = decodedData['services'] is List
                ? List<String>.from(decodedData['services'])
                : <String>[];
                
            _currentService = _currentService.copyWith(
              businessName: decodedData['driverName']?.toString() ?? '',
              ownerName: decodedData['driverName']?.toString() ?? '', // Note: using driver_name as owner_name
              phoneNumber: decodedData['mobile']?.toString() ?? '',
              location: decodedData['city']?.toString() ?? 'location_not_set'.tr(),
              email: googleEmail.isNotEmpty ? googleEmail : (decodedData['email']?.toString() ?? ''),
              services: services,
            );
          });
        }
      } else {
        // Fallback to buyer data if no garage or other data found (for testing)
        final buyerData = prefs.getString('user_profile_data_buyer');
        if (buyerData != null && buyerData.isNotEmpty) {
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
      debugPrint('Error loading garage profile data: $e');
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

  void _showEditForm() {
    final locationParts = _currentService.location.split(',');
    final city = locationParts.isNotEmpty ? locationParts[0].trim() : '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddGarageFormSheet(
        initialName: _currentService.businessName,
        initialCity: city,
        initialPhone: _currentService.phoneNumber,
        initialServices: _currentService.services,
        onSubmit: (name, city, phone, services) {
          _handleUpdateService(name, city, phone, services);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: TowTruckNavBar(
          scaffoldKey: _scaffoldKey,
          title: 'app_title'.tr(),
        ),
        endDrawer: TowTruckNavBar.buildDrawer(context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [             
              // Garage Service Card
              GarageServiceCard(
                service: _currentService,
                onTap: () {
                  // Action when card is tapped
                },
                onFavoritePressed: () {
                  setState(() {
                    _currentService = _currentService.copyWith(
                      isFavorite: !_currentService.isFavorite,
                    );
                  });
                },
                onEditPressed: _showEditForm,
              ),
              const SizedBox(height: 24), // spacing between cards
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => AddGarageFormSheet(
                      onSubmit: (name, city, phone, services) {
                        // Handle adding a new garage service
                        _handleUpdateService(name, city, phone, services);
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Text(
                        'add_second_card'.tr(),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
