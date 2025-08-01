import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/models/garage_profile.dart';
import 'package:icar_instagram_ui/models/garage_service.dart';
import 'package:icar_instagram_ui/widgets/cards/garage_service_card.dart';
import 'package:icar_instagram_ui/widgets/garage/garage_filters_sheet.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

class GarageContent extends StatefulWidget {
  const GarageContent({Key? key}) : super(key: key);

  @override
  State<GarageContent> createState() => _GarageContentState();
}

class _GarageContentState extends State<GarageContent> {
  String? _selectedCity;
  String? _selectedService;

  Future<List<GarageProfile>> _loadProfiles() async {
    try {
      // Pass filters directly to the API
      return await serviceLocator.garageService.getPublicGarageProfiles(
        city: _selectedCity,
        service: _selectedService,
      );
    } catch (e) {
      debugPrint('Error loading garage profiles: $e');
      rethrow;
    }
  }

  Future<void> _refreshProfiles() {
    setState(() {});
    return Future.value();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => GarageFiltersSheet(
        initialCity: _selectedCity,
        initialService: _selectedService,
        onApplyFilters: (filters) {
          setState(() {
            _selectedCity = filters['city'];
            _selectedService = filters['services'];
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // Force LTR direction
      child: RefreshIndicator(
      onRefresh: _refreshProfiles,
      child: FutureBuilder<List<GarageProfile>>(
        future: _loadProfiles(),
        builder: (context, snapshot) {
          // Data loading and processing
          if (snapshot.hasData) {
            // No need to extract cities and services anymore
            // as we're using the hardcoded lists from FilterConstants
          }

          Widget content;

          if (snapshot.connectionState == ConnectionState.waiting) {
            content = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            content = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Failed to load garage profiles',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshProfiles,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            final profiles = snapshot.data ?? [];

            if (profiles.isEmpty) {
              content = const Center(
                child: Text('No garage profiles found'),
              );
            } else {
              content = ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  // Convert GarageProfile to GarageService
                  final garageService = GarageService(
                    id: profile.id.toString(),
                    businessName: profile.businessName,
                    ownerName: profile.mechanicName,
                    phoneNumber: profile.mobile,
                    location: profile.city,
                    imageUrl:
                        'https://via.placeholder.com/300x150?text=${Uri.encodeComponent(profile.businessName)}',
                    services: profile.services ?? [],
                    rating: 4.5, // Default rating
                    reviews: 10, // Default reviews
                  );

                  return GarageServiceCard(
                    service: garageService,
                    onTap: () {
                      // Handle tap
                    },
                    // The card from cards/ already has built-in favorite functionality
                  );
                },
              );
            }
          }

          return Column(
            children: [
              // Filter button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showFilterSheet,
                        icon: const Icon(Icons.filter_list, size: 20),
                        label: const Text('Filter'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: (_selectedCity != null ||
                                    _selectedService != null)
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                            width: (_selectedCity != null ||
                                    _selectedService != null)
                                ? 2.0
                                : 1.0,
                          ),
                        ),
                      ),
                    ),
                    if (_selectedCity != null || _selectedService != null) ...[
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedCity = null;
                            _selectedService = null;
                          });
                        },
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text('Reset'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Content
              Expanded(child: content),
            ],
          );
        },
      ),
    ));
  }
}
