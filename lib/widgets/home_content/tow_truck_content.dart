import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/tow_truck_service.dart' as model;
import 'package:icar_instagram_ui/widgets/cards/tow_truck_service_card.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/services/api/services/tow_truck_service.dart' as api_service;

class TowTruckContent extends StatefulWidget {
  const TowTruckContent({Key? key}) : super(key: key);

  @override
  State<TowTruckContent> createState() => _TowTruckContentState();
}

class _TowTruckContentState extends State<TowTruckContent> {
  final api_service.TowTruckService _towTruckService = serviceLocator.towTruckService;
  List<model.TowTruckService> _services = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTowTruckProfiles();
  }

  Future<void> _loadTowTruckProfiles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profiles = await _towTruckService.getAllTowTruckProfiles();
      setState(() {
        _services = profiles.map((profile) => model.TowTruckService(
          id: profile['id'].toString(),
          businessName: profile['business_name'] ?? 'Unnamed Business',
          driverName: profile['driver_name'] ?? 'No Name',
          phoneNumber: profile['mobile'] ?? 'No Phone',
          location: profile['city'] ?? 'No Location',
          imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be',
          isFavorite: false,
        )).toList();
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load tow truck profiles: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
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

    if (_services.isEmpty) {
      return const Center(
        child: Text('No tow truck services available'),
      );
    }

    return Consumer(
      builder: (context, ref, _) {
        return RefreshIndicator(
          onRefresh: _loadTowTruckProfiles,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
    );
  }
}
