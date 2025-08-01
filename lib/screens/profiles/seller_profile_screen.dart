import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/widgets/car/car_form_sheet.dart';

import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icar_instagram_ui/providers/seller_cars_provider.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';
import 'package:icar_instagram_ui/screens/profiles/phone_number_card.dart';

final _log = Logger('SellerProfileScreen');

final sellerProfileProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  try {
    _log.info('Fetching seller profile info from API...');
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No authentication token found');
    }
    final response = await http.get(
      Uri.parse('http://app.icaralgerie.com/api/profile/basic-info'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _log.info('Profile API response: $data');
      return {
        'full_name': data['name'] ?? '',
        'city': data['city'] ?? '',
        'mobile': data['phone'] ?? '',
        'data': {
          'full_name': data['name'] ?? '',
          'city': data['city'] ?? '',
          'mobile': data['phone'] ?? '',
        },
      };
    } else {
      _log.warning(
          'Profile API error: ${response.statusCode} ${response.body}');
      return {};
    }
  } catch (e, stackTrace) {
    _log.severe('Error fetching seller profile from API', e, stackTrace);
    return {};
  }
});

class SellerProfileScreen extends ConsumerStatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  ConsumerState<SellerProfileScreen> createState() =>
      _SellerProfileScreenState();
}

class _SellerProfileScreenState extends ConsumerState<SellerProfileScreen> {
  Future<void> _showEditProfileDialog(
      BuildContext context, Map<String, dynamic>? data) async {
    final nameController =
        TextEditingController(text: data?['data']?['full_name'] ?? '');
    final cityController =
        TextEditingController(text: data?['data']?['city'] ?? '');
    final mobileController =
        TextEditingController(text: data?['data']?['mobile'] ?? '');
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('edit_profile_info'.tr()),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'name'.tr()),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'enter_name'.tr() : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: cityController.text.isNotEmpty
                          ? cityController.text
                          : null,
                      items: FilterConstants.garageCities
                          .map((city) => DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              ))
                          .toList(),
                      onChanged: (value) {
                        cityController.text = value ?? '';
                      },
                      decoration: InputDecoration(labelText: 'city'.tr()),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'select_city'.tr() : null,
                    ),
                    TextFormField(
                      controller: mobileController,
                      decoration: const InputDecoration(labelText: 'Mobile'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter mobile' : null,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setState(() => isLoading = true);
                          final storage = const FlutterSecureStorage();
                          final token = await storage.read(key: 'auth_token');
                          if (token == null) return;
                          final response = await http.post(
                            Uri.parse(
                                'http://app.icaralgerie.com/api/profile/update-name'),
                            headers: {
                              'Authorization': 'Bearer $token',
                              'Content-Type': 'application/json',
                              'Accept': 'application/json',
                            },
                            body: jsonEncode({
                              'name': nameController.text.trim(),
                              'city': cityController.text.trim(),
                              'phone': mobileController.text.trim(),
                            }),
                          );
                          setState(() => isLoading = false);
                          if (response.statusCode == 200) {
                            if (context.mounted) Navigator.of(context).pop();
                            if (mounted) ref.invalidate(sellerProfileProvider);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Profile updated successfully')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Failed to update profile: ${response.body}')),
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  void _editCar(CarPost car) {
    CarFormSheet.show(
      context,
      car: car,
      onSuccess: () {
        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('car_updated_success'.tr())),
        );

        // Refresh the car list by invalidating the provider
        ref.invalidate(sellerCarsProvider);
      },
      onError: (error) {
        if (!mounted) return;

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('car_update_failed'.tr(args: [error.toString()]))),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addNewCar() {
    CarFormSheet.show(
      context,
      onSuccess: () {
        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('car_added_success'.tr())),
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
          SnackBar(
              content: Text('car_add_failed'.tr(args: [error.toString()]))),
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
        title: 'app_title'.tr(),
      ),
      endDrawer: TowTruckNavBar.buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seller Info Section with Styled Text
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ref.watch(sellerProfileProvider).when(
                        data: (data) => Text(
                          (data != null &&
                                  data['data']?['full_name']?.isNotEmpty ==
                                      true)
                              ? data['data']['full_name']
                              : (data?['full_name'] ?? ''),
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
                            data: (data) =>
                                data['name']?.toString() ?? 'seller'.tr(),
                            loading: () => 'loading'.tr(),
                            error: (error, stack) => 'error_occurred'.tr(),
                          ),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          Icons.location_on,
                          profileAsync.when(
                            data: (data) {
                              final city = data?['data']?['city']?.toString();
                              final fallback = data?['city']?.toString();
                              return (city?.isNotEmpty == true)
                                  ? city!
                                  : (fallback?.isNotEmpty == true
                                      ? fallback!
                                      : 'Unknown location');
                            },
                            loading: () => 'Loading...',
                            error: (error, stack) => 'Error',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _showEditProfileDialog(
                            context, profileAsync.asData?.value),
                        tooltip: 'Edit',
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          Icons.phone,
                          profileAsync.when(
                            data: (data) {
                              final mobile =
                                  data?['data']?['mobile']?.toString();
                              final fallback = data?['mobile']?.toString();
                              return (mobile?.isNotEmpty == true)
                                  ? mobile!
                                  : (fallback ?? 'No phone number');
                            },
                            loading: () => 'Loading...',
                            error: (error, stack) => 'Error loading phone',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _showEditProfileDialog(
                            context, profileAsync.asData?.value),
                        tooltip: 'Edit',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const PhoneNumberCard(),
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
                                'no_cars_listed'.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _addNewCar,
                                child: Text('add_first_car'.tr()),
                              ),
                            ],
                          ),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Fixed 2 cards per row
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: cars.length,
                        itemBuilder: (context, index) =>
                            _buildCarCard(cars[index]),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'failed_load_cars'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                ref.refresh(sellerCarsProvider.future),
                            child: Text('retry'.tr()),
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.0,
          ),
        ),
      ],
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
                            child: Icon(Icons.error_outline,
                                color: Colors.red, size: 32),
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
                      child: Icon(Icons.image_not_supported,
                          size: 40, color: Colors.grey),
                    ),
            ),
            // Car Details
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                          color: AppColors.loginbg,
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
