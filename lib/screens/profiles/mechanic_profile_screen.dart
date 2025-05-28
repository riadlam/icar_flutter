import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icar_instagram_ui/models/tow_truck_service.dart';
import 'package:icar_instagram_ui/screens/profiles/seller_profile_screen.dart';
import 'package:icar_instagram_ui/widgets/cards/tow_truck_service_card.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/add_card_form_sheet.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';

// Extension to make it easier to create a copy of the service with updated fields
extension TowTruckServiceX on TowTruckService {
  TowTruckService copyWith({
    String? businessName,
    String? phoneNumber,
    String? email,
    String? location,
    bool? isFavorite,
  }) {
    return TowTruckService(
      businessName: businessName ?? this.businessName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl,
      id: id,
    );
  }
}

class MechanicProfileScreen extends ConsumerStatefulWidget {
  const MechanicProfileScreen({super.key});

  @override
  ConsumerState<MechanicProfileScreen> createState() =>
      _MechanicProfileScreenState();
}

class _MechanicProfileScreenState
    extends ConsumerState<MechanicProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  late TowTruckService _currentService;

  @override
  void initState() {
    super.initState();
    // Initialize with default values that will be overridden by the provider
    _currentService = TowTruckService(
      businessName: 'Loading...',
      phoneNumber: '',
      email: '',
      location: '',
      isFavorite: false,
      imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be',
      id: '1',
    );

    // Load profile data if available
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('user_profile_data_mechanic');
      
      // Get email from Google login if available
      final googleEmail = prefs.getString('user_email') ?? '';
      
      if (data != null && data.isNotEmpty) {
        final decodedData = jsonDecode(data) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _currentService = _currentService.copyWith(
              businessName: decodedData['driver_name']?.toString() ?? 'Mechanic',
              phoneNumber: decodedData['mobile']?.toString() ?? '',
              location: decodedData['city']?.toString() ?? 'Location not set',
              email: googleEmail.isNotEmpty ? googleEmail : (decodedData['email']?.toString() ?? ''),
            );
          });
        }
      } else {
        // Fallback to buyer data if mechanic data not found (for testing)
        final buyerData = prefs.getString('user_profile_data_buyer');
        if (buyerData != null && buyerData.isNotEmpty) {
          final decodedData = jsonDecode(buyerData) as Map<String, dynamic>;
          if (mounted) {
            setState(() {
              _currentService = _currentService.copyWith(
                businessName: decodedData['fullName']?.toString() ?? 'Mechanic',
                phoneNumber: decodedData['mobile']?.toString() ?? '',
                location: decodedData['city']?.toString() ?? 'Location not set',
                email: decodedData['email']?.toString() ?? '',
              );
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentService = _currentService.copyWith(
            businessName: 'Error loading profile',
            phoneNumber: 'N/A',
            location: 'Please try again later',
          );
        });
      }
      debugPrint('Error loading profile data: $e');
    }
  }

  Future<void> _handleUpdateService(
    String name,
    String city,
    String phone,
    String? additionalPhone,
    String? email,
  ) async {
    if (mounted) {
      setState(() {
        _currentService = _currentService.copyWith(
          businessName: name,
          phoneNumber: phone,
          email: email ?? _currentService.email,
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
      builder: (context) => AddCardFormSheet(
        initialName: _currentService.businessName,
        initialCity: city,
        initialPhone: _currentService.phoneNumber,
        initialEmail: _currentService.email,
        onSubmit: _handleUpdateService,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // Watch for changes to the profile data
    ref.watch(sellerProfileProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: TowTruckNavBar(
          scaffoldKey: _scaffoldKey,
          title: 'iCar',
        ),
        endDrawer: TowTruckNavBar.buildDrawer(context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [             

              // Tow Truck Service Card
              TowTruckServiceCard(
                service: _currentService,
                onTap: () {
                  // Action
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
    builder: (context) => const AddCardFormSheet(),
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
      children: const [
        Icon(Icons.add, color: Colors.blueAccent),
        SizedBox(width: 8),
        Text(
          "Add a second card",
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
