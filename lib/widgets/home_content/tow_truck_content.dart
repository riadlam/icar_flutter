import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/tow_truck_service.dart' as model;
import 'package:icar_instagram_ui/widgets/cards/tow_truck_service_card.dart';
import 'package:icar_instagram_ui/widgets/tow_truck/tow_truck_filters_sheet.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/services/api/services/tow_truck_service.dart'
    as api_service;

class TowTruckContent extends StatefulWidget {
  const TowTruckContent({Key? key}) : super(key: key);

  @override
  State<TowTruckContent> createState() => _TowTruckContentState();
}

class _TowTruckContentState extends State<TowTruckContent> {
  final api_service.TowTruckService _towTruckService =
      serviceLocator.towTruckService;
  List<model.TowTruckService> _services = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadTowTruckProfiles();
  }

  Future<void> _loadTowTruckProfiles({String? city}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profiles =
          await _towTruckService.getAllTowTruckProfiles(city: city);
      if (mounted) {
        setState(() {
          _services = profiles
              .map((profile) => model.TowTruckService(
                    id: profile['id'].toString(),
                    businessName:
                        profile['business_name'] ?? 'Unnamed Business',
                    driverName: profile['driver_name'] ?? 'No Name',
                    phoneNumber: profile['mobile'] ?? 'No Phone',
                    location: profile['city'] ?? 'No Location',
                    imageUrl:
                        'https://images.unsplash.com/photo-1570129477492-45c003edd2be',
                    isFavorite: false,
                  ))
              .toList();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error =
              'Failed to load tow truck profiles: ${e is Exception ? e.toString().split(':').last.trim() : 'Unknown error'}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TowTruckFiltersSheet(
        initialCity: _selectedCity,
        onApplyFilters: (filters) {
          setState(() {
            _selectedCity = filters['city'];
            // Reload profiles with the selected city filter
            _loadTowTruckProfiles(city: _selectedCity);
          });
        },
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedCity = null;
      // Reload profiles without any filters
      _loadTowTruckProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Force LTR direction for the entire widget
    return Directionality(
      textDirection: TextDirection.ltr,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTowTruckProfiles,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Filter buttons row
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showFilterSheet,
                    icon: const Icon(Icons.filter_list, size: 20),
                    label: Text(
                        'Filter${_selectedCity != null ? ' (${_selectedCity})' : ''}'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: _selectedCity != null
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                        width: _selectedCity != null ? 2.0 : 1.0,
                      ),
                    ),
                  ),
                ),
                if (_selectedCity != null) ...[
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: _resetFilters,
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
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                return RefreshIndicator(
                  onRefresh: _loadTowTruckProfiles,
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      final service = _services[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TowTruckServiceCard(
                          service: service,
                          onTap: () {
                            // Handle service tap
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
