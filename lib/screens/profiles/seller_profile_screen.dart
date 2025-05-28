import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/widgets/car/car_form_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:icar_instagram_ui/providers/seller_cars_provider.dart';

final _log = Logger('SellerProfileScreen');

final sellerProfileProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  try {
    _log.info('Loading profile data...');
    final prefs = await SharedPreferences.getInstance();
    
    // Try to get the data using all possible role-based keys
    final allKeys = prefs.getKeys();
    _log.info('All SharedPreferences keys: $allKeys');
    
    // Look for any user profile data
    for (final key in allKeys) {
      if (key.startsWith('user_profile_data_')) {
        _log.info('Checking key: $key');
        final data = prefs.getString(key);
        if (data != null && data.isNotEmpty) {
          _log.info('Found non-empty data in key: $key');
          try {
            final decodedData = jsonDecode(data) as Map<String, dynamic>;
            _log.info('Successfully decoded data from $key: $decodedData');
            return decodedData;
          } catch (e) {
            _log.severe('Error decoding data from key $key: $e');
            _log.severe('Raw data: $data');
          }
        } else {
          _log.info('No data found in key: $key');
        }
      }
    }
    
    _log.warning('No valid profile data found in SharedPreferences');
    return {};
  } catch (e, stackTrace) {
    _log.severe('Error loading profile data', e, stackTrace);
    return {};
  }
});

class SellerProfileScreen extends ConsumerStatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  ConsumerState<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends ConsumerState<SellerProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _phoneNumbers = ['+1 234 567 8900'];
  final TextEditingController _phoneController = TextEditingController();
  
  // This will be populated from the API
  List<CarPost> _sellerCars = [];
  
  @override
  void initState() {
    super.initState();
    // Trigger the API call when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sellerCarsProvider.future);
    });
  }

  void _addPhoneNumber() {
    final BuildContext context = _scaffoldKey.currentContext!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Add Phone Number'),
        content: TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Enter phone number',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_phoneController.text.isNotEmpty) {
                setState(() {
                  _phoneNumbers.add(_phoneController.text);
                  _phoneController.clear();
                });
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editCar(CarPost car) {
    CarFormSheet.show(
      context,
      car: car,
      onSuccess: () {
        if (!mounted) return;
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car updated successfully!')),
        );
        
        // Refresh the car list
        if (mounted) {
          setState(() {
            // Refresh the car list here if needed
          });
        }
      },
      onError: (error) {
        if (!mounted) return;
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update car: $error')),
        );
      },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
  
  void _addNewCar() {
    CarFormSheet.show(
      context,
      onSuccess: () {
        if (!mounted) return;
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car added successfully!')),
        );
        
        // Refresh the car list
        if (mounted) {
          setState(() {
            // Refresh the car list here if needed
          });
        }
      },
      onError: (error) {
        if (!mounted) return;
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add car: $error')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final carsAsync = ref.watch(sellerCarsProvider);
    final profileAsync = ref.watch(sellerProfileProvider);
    final theme = Theme.of(context);
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: TowTruckNavBar(
        scaffoldKey: _scaffoldKey,
        title: 'iCar',
      ),
      endDrawer: TowTruckNavBar.buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seller Info Section with Styled Text
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ref.watch(sellerProfileProvider).when(
                    data: (data) => Text(
                      data['fullName'] ?? '',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                    loading: () => const SizedBox(
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (error, stack) => Text(
                      profileAsync.when(
                        data: (data) => data['name']?.toString() ?? 'Seller',
                        loading: () => 'Loading...',
                        error: (error, stack) => 'Error',
                      ),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        profileAsync.when(
                          data: (data) => data['city']?.toString() ?? 'Unknown location',
                          loading: () => 'Loading...',
                          error: (error, stack) => 'Error',
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip('${_sellerCars.length} Cars', Icons.directions_car, size: 14),
                      const SizedBox(width: 12),
                     
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Number',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          ..._phoneNumbers.map((phone) => Text(
                            phone,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          )).toList(),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                        onPressed: _addPhoneNumber,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),
            
            // Listed Cars Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  const SizedBox(height: 16),
                 
                  const SizedBox(height: 12),
                  carsAsync.when(
                    data: (cars) {
                      if (cars.isEmpty) {
                        return Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.directions_car_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No cars listed yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _addNewCar,
                                child: const Text('Add Your First Car'),
                              ),
                            ],
                          ),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Fixed 2 cards per row
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: cars.length,
                        itemBuilder: (context, index) => _buildCarCard(cars[index]),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load cars',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () => ref.refresh(sellerCarsProvider.future),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, {double size = 16}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: size, color: Colors.blue[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: size - 2,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCarCard(CarPost car) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _editCar(car),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Car Image Container with fixed aspect ratio
            Container(
              height: 120, // Fixed height for all images
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: car.images.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: Image.network(
                        car.images.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.error_outline, color: Colors.red, size: 32),
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    ),
            ),
            // Car Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${car.brand} ${car.model}'.trim(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${car.year}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        car.price.toStringAsFixed(0),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 14,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
