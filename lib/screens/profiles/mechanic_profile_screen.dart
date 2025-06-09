import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/models/tow_truck_service.dart';
import 'package:icar_instagram_ui/screens/profiles/seller_profile_screen.dart';
import 'package:icar_instagram_ui/widgets/cards/tow_truck_service_card.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/add_card_form_sheet.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

extension TowTruckServiceX on TowTruckService {
  TowTruckService copyWith({
    String? businessName,
    String? phoneNumber,
    String? location,
    bool? isFavorite,
  }) {
    return TowTruckService(
      businessName: businessName ?? this.businessName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl,
      id: id,
      driverName: driverName,
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

  List<TowTruckService> _towTruckProfiles = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadTowTruckProfiles();
  }

  Future<void> _loadTowTruckProfiles() async {
    print('Loading tow truck profiles...');
    
    if (!mounted) {
      print('Widget not mounted, aborting profile load');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      print('Fetching profiles from API...');
      final profiles = await serviceLocator.towTruckService.getTowTruckProfiles();
      print('Received ${profiles.length} profiles from API');

      if (!mounted) return;

      setState(() {
        _towTruckProfiles = profiles.map((profile) {
          print('Processing profile: ${profile['id']} - ${profile['business_name']}');
          return TowTruckService(
            id: profile['id']?.toString() ?? 'unknown',
            businessName: profile['business_name']?.toString() ?? 'Unnamed Business',
            driverName: profile['driver_name']?.toString() ?? 'No Name',
            phoneNumber: profile['mobile']?.toString() ?? 'No Phone',
            location: profile['city']?.toString() ?? 'No Location',
            imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be',
            isFavorite: false,
          );
        }).toList();
        print('Successfully loaded ${_towTruckProfiles.length} profiles');
      });
    } catch (e, stackTrace) {
      print('Error loading profiles: $e');
      print('Stack trace: $stackTrace');
      
      if (!mounted) return;
      
      setState(() {
        _error = 'Failed to load tow truck profiles. Please try again later.';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading profiles: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _refreshProfiles() {
    _loadTowTruckProfiles();
  }

  Future<void> _handleUpdateService(
    String name,
    String city,
    String phone, {
    String? id,
  }) async {
    print('_handleUpdateService called with name: $name, city: $city, phone: $phone, id: $id');
    
    if (!mounted) {
      print('Widget not mounted, aborting');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      dynamic response;
      if (id == null) {
        print('Creating new profile');
        // Create new profile
        response = await serviceLocator.towTruckService.createOrUpdateTowTruckProfile(
          businessName: name,
          driverName: name, // Using business name as driver name if not provided
          mobile: phone,
          city: city,
        );
        print('Create profile response: $response');
      } else {
        print('Updating profile with ID: $id');
        // Update existing profile
        response = await serviceLocator.towTruckService.updateTowTruckProfile(
          id: id,
          businessName: name,
          city: city,
          mobile: phone,
        );
        print('Update profile response: $response');
      }
      
      // Close the bottom sheet before refreshing
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(id == null ? 'Profile created successfully' : 'Profile updated successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      // Refresh the list after successful update
      await _loadTowTruckProfiles();
      
    } catch (e, stackTrace) {
      print('Error in _handleUpdateService: $e');
      print('Stack trace: $stackTrace');
      
      if (!mounted) return;
      
      setState(() {
        _error = 'Failed to update profile: ${e.toString()}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showEditForm(TowTruckService service) {
    // Check if this is the last profile by comparing IDs
    final isLastItem = _towTruckProfiles.length == 1 || 
                      _towTruckProfiles.last.id == service.id;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddCardFormSheet(
        initialName: service.businessName,
        initialCity: service.location,
        initialPhone: service.phoneNumber,
        onSubmit: (name, city, phone) => _handleUpdateService(
          name,
          city,
          phone,
          id: service.id,
        ),
        onDelete: () async {
          // Close the bottom sheet
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
          // Call the delete function
          await _deleteProfile(service.id);
        },
        isLastItem: isLastItem,
      ),
    );
  }

  void _showAddCardForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddCardFormSheet(
        initialName: '',
        initialCity: '',
        initialPhone: '',
        onSubmit: (name, city, phone) => _handleUpdateService(name, city, phone),
      ),
    );
  }

  Future<void> _deleteProfile(String id) async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      // Show confirmation dialog
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Profile'),
          content: const Text('Are you sure you want to delete this profile? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (shouldDelete != true) {
        setState(() => _isLoading = false);
        return;
      }

      // Call the delete API
      await serviceLocator.towTruckService.deleteTowTruckProfile(id);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      // Refresh the list
      await _loadTowTruckProfiles();
    } catch (e) {
      print('Error deleting profile: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to delete profile: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(sellerProfileProvider);

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
              if (_isLoading && _towTruckProfiles.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (_error.isNotEmpty)
                Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
              else if (_towTruckProfiles.isEmpty)
                const Center(child: Text('No tow truck profiles found'))
              else ...[
                // Show LAST card first
                TowTruckServiceCard(
                  service: _towTruckProfiles.last,
                  onTap: () {},
                  onFavoritePressed: () {
                    setState(() {
                      final lastIndex = _towTruckProfiles.length - 1;
                      _towTruckProfiles[lastIndex] = _towTruckProfiles[lastIndex].copyWith(
                        isFavorite: !_towTruckProfiles[lastIndex].isFavorite,
                      );
                    });
                  },
                  onEditPressed: () => _showEditForm(_towTruckProfiles.last),
                ),
                const SizedBox(height: 16),

                // Add Card Button
                GestureDetector(
                  onTap: _showAddCardForm,
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
                        const Icon(Icons.add, color: Colors.blueAccent),
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

                const SizedBox(height: 16),

                // Show all EXCEPT last card after button
                ..._towTruckProfiles.take(_towTruckProfiles.length - 1).map((service) => Column(
                  children: [
                    TowTruckServiceCard(
                      service: service,
                      onTap: () {},
                      onFavoritePressed: () {
                        setState(() {
                          final index = _towTruckProfiles.indexWhere((s) => s.id == service.id);
                          if (index != -1) {
                            _towTruckProfiles[index] = _towTruckProfiles[index].copyWith(
                              isFavorite: !_towTruckProfiles[index].isFavorite,
                            );
                          }
                        });
                      },
                      onEditPressed: () => _showEditForm(service),
                    ),
                    const SizedBox(height: 16),
                  ],
                )).toList(),
              ]
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
