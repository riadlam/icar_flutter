import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/widgets/car/car_form_sheet.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/services/api/services/car_service.dart';

// Using the existing StringCasingExtension from car_post.dart

class BuyerAddScreen extends StatefulWidget {
  const BuyerAddScreen({super.key});

  @override
  State<BuyerAddScreen> createState() => _BuyerAddScreenState();
}

class _BuyerAddScreenState extends State<BuyerAddScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CarService _carService = serviceLocator.carService;
  
  bool _isLoading = false;
  List<CarPost> _sellerCars = [];

  void _showAddCarForm() {
    final context = _scaffoldKey.currentContext;
    if (context == null || !context.mounted) return;
    
    if (_isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait...')),
      );
      return;
    }
    
    CarFormSheet.show(
      context,
      onSuccess: () async {
        if (!mounted) return;
        setState(() => _isLoading = true);
        
        try {
          await _loadSellerCars();
          if (!mounted) return;
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Car listed successfully!')),
          );
        } catch (e) {
          if (!mounted) return;
          log('Error loading seller cars: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error refreshing car list')),
          );
        } finally {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      },
      onError: (error) {
        if (!mounted) return;
        log('Error adding car: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to list car: ${error.toString()}')),
        );
      },
    );
  }
  
  @override
  void initState() {
    super.initState();
    // Load seller's cars when the screen is first displayed
    _loadSellerCars();
  }

  // Load seller's cars from the API
  Future<void> _loadSellerCars() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });
    
    final context = _scaffoldKey.currentContext;
    if (context == null) {
      setState(() => _isLoading = false);
      return;
    }
    
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Loading your cars...'),
        duration: Duration(seconds: 2),
      ),
    );
    
    try {
      final carsData = await _carService.getSellerCars();
      if (!mounted) return;
      
      final now = DateTime.now();
      final cars = carsData.map<CarPost>((car) {
        final carId = car['id'] is int ? car['id'] as int : int.tryParse(car['id']?.toString() ?? '0') ?? 0;
        final type = car['type']?.toString() == 'rent' ? 'rent' : 'sale';
        
        final images = List<String>.from(car['images'] ?? []);
        return CarPost(
          id: carId.toString(),
          type: type,
          brand: car['brand']?.toString() ?? '',
          model: car['model']?.toString() ?? '',
          price: (car['price'] is num ? (car['price'] as num).toDouble() : 0.0),
          mileage: car['mileage'] is int ? car['mileage'] as int : 
                 car['mileage'] is String ? int.tryParse(car['mileage'].toString()) ?? 0 : 0,
          year: car['year'] is int ? car['year'] as int : 
                car['year'] is String ? int.tryParse(car['year'].toString()) ?? DateTime.now().year : DateTime.now().year,
          transmission: car['transmission']?.toString().toLowerCase() ?? 'automatic',
          fuel: car['fuel']?.toString().toLowerCase() ?? 'gasoline',
          description: car['description']?.toString() ?? 'No description provided',
          imageUrls: images,
          enabled: car['enabled'] is bool ? car['enabled'] as bool : true,
          createdAt: car['created_at'] is String ? DateTime.tryParse(car['created_at']) ?? now : now,
          updatedAt: car['updated_at'] is String ? DateTime.tryParse(car['updated_at']) ?? now : now,
          isWishlisted: car['is_wishlisted'] is bool ? car['is_wishlisted'] as bool : false,
        );
      }).toList();
      
      if (mounted) {
        setState(() {
          _sellerCars = cars;
          _isLoading = false;
        });
        
        await Future.delayed(const Duration(milliseconds: 500));
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load cars: ${e.toString()}'),
          backgroundColor: Colors.red,
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
        title: 'iCar',
      ),
      endDrawer: TowTruckNavBar.buildDrawer(context),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Add Car Button
                  ElevatedButton(
                    onPressed: _showAddCarForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'List a Car for Sale/Rent',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Show message if no cars are listed
                 
                ],
              ),
            ),
    );
  }

  Widget _buildCarCard(CarPost car) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car image
          _buildCarImage(car),
          _buildCarDetails(car),
        ],
      ),
    );
  }

  Widget _buildCarImage(CarPost car) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        color: Colors.grey[200],
      ),
      child: car.images.isNotEmpty
          ? ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                car.images.first,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
              ),
            )
          : _buildErrorImage(),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildCarDetails(CarPost car) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${car.brand} ${car.model} (${car.year})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${car.year} • ${car.formattedMileage} • ${car.fuel.toTitleCase()}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            car.formattedPrice,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
