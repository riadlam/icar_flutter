import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/tow_truck_service.dart';
import 'package:icar_instagram_ui/providers/tow_truck_wishlist_provider.dart';
import 'package:icar_instagram_ui/widgets/cards/tow_truck_service_card.dart';
import 'package:icar_instagram_ui/outils/appbar_custom.dart' show AnimatedSearchAppBar;
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/services/api/services/tow_truck_service.dart' as api_service;

class TowTruckWishlistScreen extends ConsumerStatefulWidget {
  const TowTruckWishlistScreen({super.key});

  @override
  ConsumerState<TowTruckWishlistScreen> createState() => _TowTruckWishlistScreenState();
}

class _TowTruckWishlistScreenState extends ConsumerState<TowTruckWishlistScreen> {
  final api_service.TowTruckService _towTruckService = serviceLocator.towTruckService;
  List<TowTruckService> _services = [];
  bool _isLoading = false;
  String? _error;
  
  // Track the current wishlist state
  Set<String> _wishlistIds = {};

  @override
  void initState() {
    super.initState();
    _loadWishlistServices();
  }

  Future<void> _loadWishlistServices() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _wishlistIds = ref.read(towTruckWishlistProvider);
      final profiles = await _towTruckService.getAllTowTruckProfiles();
      
      if (!mounted) return;
      
      setState(() {
        _services = profiles
            .where((profile) => _wishlistIds.contains(profile['id'].toString()))
            .map((profile) => TowTruckService(
                  id: profile['id'].toString(),
                  businessName: profile['business_name'] ?? 'Unnamed Business',
                  driverName: profile['driver_name'] ?? 'No Name',
                  phoneNumber: profile['mobile'] ?? 'No Phone',
                  location: profile['city'] ?? 'No Location',
                  imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be',
                  isFavorite: true,
                ))
            .toList();
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load wishlist: $e';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to wishlist changes
    ref.listen<Set<String>>(towTruckWishlistProvider, (_, newWishlistIds) {
      if (mounted && newWishlistIds != _wishlistIds) {
        _wishlistIds = newWishlistIds;
        _loadWishlistServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: AnimatedSearchAppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: const AnimatedSearchAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadWishlistServices,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const AnimatedSearchAppBar(),
      body: _services.isEmpty
          ? const Center(
              child: Text('Your tow truck wishlist is empty'),
            )
          : RefreshIndicator(
              onRefresh: _loadWishlistServices,
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
                        // Handle tap on wishlist item
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
