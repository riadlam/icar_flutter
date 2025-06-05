import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:icar_instagram_ui/models/garage_profile.dart';
import 'package:icar_instagram_ui/widgets/cards/garage_service_card.dart';
import 'package:icar_instagram_ui/widgets/garage/add_garage_form_sheet.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/models/garage_service.dart' as garage_service;

class GarageProfileCard extends StatefulWidget {
  final GarageProfile profile;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onEditPressed;
  final bool isFavorite;
  final bool showEditButton;

  const GarageProfileCard({
    Key? key,
    required this.profile,
    this.onTap,
    this.onFavoritePressed,
    this.onEditPressed,
    this.isFavorite = false,
    this.showEditButton = false,
  }) : super(key: key);

  @override
  State<GarageProfileCard> createState() => _GarageProfileCardState();
}

class _GarageProfileCardState extends State<GarageProfileCard> {
  bool _isLoading = false;

  Future<void> _handleUpdateProfile(
    String name,
    String city,
    String phone,
    List<String> services,
  ) async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Call the update API
      await serviceLocator.garageService.updateGarageProfile(
        id: widget.profile.id,
        businessName: name,
        mechanicName: name, // Using same as business name as in the form
        mobile: phone,
        city: city,
        services: services,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        // Refresh the profile list
        widget.onEditPressed?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: AddGarageFormSheet(
          initialName: widget.profile.businessName,
          initialCity: widget.profile.city,
          initialPhone: widget.profile.mobile,
          initialServices: widget.profile.services ?? [],
          onSubmit: _handleUpdateProfile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 Building GarageProfileCard for ${widget.profile.businessName} (${widget.profile.id})');
    
    // Create a mock GarageService to use the existing card
    final mockService = _createMockServiceFromProfile(widget.profile);
    
    return Stack(
      children: [
        GarageServiceCard(
          service: mockService,
          onTap: widget.onTap,
          onFavoritePressed: widget.onFavoritePressed,
          onEditPressed: widget.showEditButton ? widget.onEditPressed : null,
        ),
        if (_isLoading)
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
  
  // Helper method to create a mock GarageService from GarageProfile
  garage_service.GarageService _createMockServiceFromProfile(GarageProfile profile) {
    return garage_service.GarageService(
      id: profile.id.toString(),
      businessName: profile.businessName,
      ownerName: profile.mechanicName,
      phoneNumber: profile.mobile,
      location: profile.city,
      imageUrl: '', // No image URL in GarageProfile model
      isFavorite: widget.isFavorite,
      services: profile.services ?? [],
      rating: 0.0,
      reviews: 0,
    );
  }
}
