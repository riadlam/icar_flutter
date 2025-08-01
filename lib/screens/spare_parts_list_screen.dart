import 'dart:async'; // For TimeoutException

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart'
    as filter_constants;
import 'package:icar_instagram_ui/models/subcategory_model.dart';
import 'package:icar_instagram_ui/outils/appbar_custom.dart';
import 'package:icar_instagram_ui/providers/spare_parts_search_provider.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/widgets/cards/spare_parts_card.dart';

class SparePartsListScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> args;

  const SparePartsListScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  ConsumerState<SparePartsListScreen> createState() =>
      _SparePartsListScreenState();
}

class _SparePartsListScreenState extends ConsumerState<SparePartsListScreen> {
  late String brand;
  late String model;
  late String category;
  late String subcategory;
  late String city;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize values from args but don't make API calls here
    brand = widget.args['brand'] as String;
    model = widget.args['model'] as String;
    category = widget.args['category'] as String;
    subcategory = widget.args['subcategory'] as String;
    city = widget.args['city'] as String? ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      // Make the API call after the widget is fully initialized
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchSpareParts();
      });
    }
  }

  Future<void> _searchSpareParts() async {
    try {
      print('Starting spare parts search with params:');
      print('Brand: $brand');
      print('Model: $model');
      print('Category: $category');
      print('Subcategory: $subcategory');
      print('City: $city');

      ref
          .read(sparePartsSearchProvider.notifier)
          .update((state) => const AsyncValue.loading());

      final response =
          await serviceLocator.sparePartsService.searchSparePartsProfiles(
        brand: brand,
        model: model,
        category: category,
        subcategory: subcategory,
        city: city,
      ).timeout(const Duration(seconds: 30));

      print('Search successful, received response: $response');

      if (mounted) {
        ref
            .read(sparePartsSearchProvider.notifier)
            .update((state) => AsyncValue.data(response));
      }
    } on TimeoutException {
      final error = 'Request timed out. Please check your internet connection and try again.';
      print('Search timeout: $error');
      if (mounted) {
        ref
            .read(sparePartsSearchProvider.notifier)
            .update((state) => AsyncValue.error(error, StackTrace.current));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('Error in _searchSpareParts:');
      print('Type: ${e.runtimeType}');
      print('Error: $e');
      print('Stack trace: $stackTrace');

      String errorMessage = 'Failed to load spare parts. Please try again.';
      
      // Handle specific error types
      final errorString = e.toString();
      
      if (errorString.contains('SocketException') || 
          errorString.contains('Connection closed before full header was received') ||
          errorString.contains('Network is unreachable')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (errorString.contains('404')) {
        errorMessage = 'No spare parts found matching your criteria.';
      } else if (errorString.contains('401') || errorString.contains('403')) {
        errorMessage = 'Authentication error. Please log in again.';
      } else if (errorString.contains('500') || errorString.contains('Server error')) {
        errorMessage = 'Server error. Please try again later.';
      } else if (errorString.contains('FormatException')) {
        errorMessage = 'Error parsing server response. Please try again.';
      }

      if (mounted) {
        ref
            .read(sparePartsSearchProvider.notifier)
            .update((state) => AsyncValue.error(errorMessage, stackTrace));
            
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  _searchSpareParts();
                },
              ),
            ),
          );
        }
      }
    }
  }

  Widget _buildFilterDropdown<T>({
    required String title,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: (T? newValue) {
                if (onChanged != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Show filter bottom sheet
  void _showFilterBottomSheet() {
    // Initialize with current values or first available option
    String selectedBrand =
        brand.isNotEmpty && filter_constants.brandModels.containsKey(brand)
            ? brand
            : (filter_constants.brandModels.isNotEmpty
                ? filter_constants.brandModels.keys.first
                : '');

    // Get available models for the selected brand
    List<String> models = [];
    if (selectedBrand.isNotEmpty &&
        filter_constants.brandModels.containsKey(selectedBrand)) {
      models = filter_constants.brandModels[selectedBrand]!.toSet().toList();
    }

    String selectedModel = models.contains(model)
        ? model
        : (models.isNotEmpty ? models.first : '');

    // Initialize city with current value or empty
    String selectedCity = city;

    // Handle category
    String selectedCategory = category.isNotEmpty ? category : '';
    if (selectedCategory.isEmpty &&
        filter_constants.FilterConstants.sparePartsCategories.isNotEmpty) {
      selectedCategory = filter_constants
              .FilterConstants.sparePartsCategories.first['name']
              ?.toString() ??
          '';
    }

    // Handle subcategory
    String selectedSubcategory = subcategory;
    String? categoryId;

    // Get subcategories for the selected category
    List<Subcategory> subcategories = [];
    if (selectedCategory.isNotEmpty) {
      try {
        final categoryObj = filter_constants
            .FilterConstants.sparePartsCategories
            .firstWhere((cat) => cat['name'] == selectedCategory);
        categoryId = categoryObj['id'] as String?;
        if (categoryId != null) {
          subcategories =
              filter_constants.FilterConstants.getSubcategories(categoryId);
        }
      } catch (e) {
        categoryId = null;
      }
    }

    // Ensure selected subcategory is valid
    if (selectedSubcategory.isNotEmpty) {
      final subcategoryNames = subcategories.map((s) => s.name).toList();
      if (!subcategoryNames.contains(selectedSubcategory) ||
          subcategories.isEmpty) {
        selectedSubcategory =
            subcategories.isNotEmpty ? subcategories.first.name : '';
      }
    } else if (subcategories.isNotEmpty) {
      selectedSubcategory = subcategories.first.name;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Filter Results',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildFilterDropdown<String>(
                  title: 'Brand',
                  value: selectedBrand.isNotEmpty ? selectedBrand : null,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Select a brand'),
                    ),
                    ...filter_constants.brandModels.keys
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedBrand = newValue;
                        // Reset dependent fields
                        selectedModel = '';
                        selectedCategory = '';
                        selectedSubcategory = '';

                        // Update models for the selected brand
                        models = filter_constants.brandModels[newValue]
                                ?.toSet()
                                .toList() ??
                            [];
                        if (models.isNotEmpty) {
                          selectedModel = models.first;
                        }
                      });
                    }
                  },
                ),
                _buildFilterDropdown<String>(
                  title: 'Model',
                  value: selectedModel.isNotEmpty ? selectedModel : null,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Select a model'),
                    ),
                    ...models.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ],
                  onChanged: models.isEmpty
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              selectedModel = value;
                            });
                          }
                        },
                ),
                _buildFilterDropdown<String>(
                  title: 'Category',
                  value: selectedCategory.isNotEmpty ? selectedCategory : null,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Select a category'),
                    ),
                    ...filter_constants.FilterConstants.sparePartsCategories
                        .map<DropdownMenuItem<String>>((cat) {
                      final name = cat['name'] as String? ?? '';
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCategory = newValue;
                        selectedSubcategory = '';

                        // Update subcategories for the selected category
                        try {
                          final categoryObj = filter_constants
                              .FilterConstants.sparePartsCategories
                              .firstWhere((cat) => cat['name'] == newValue);
                          final catId = categoryObj['id'] as String?;
                          if (catId != null) {
                            subcategories = filter_constants.FilterConstants
                                .getSubcategories(catId);
                            if (subcategories.isNotEmpty) {
                              selectedSubcategory = subcategories.first.name;
                            }
                          }
                        } catch (e) {
                          subcategories = [];
                        }
                      });
                    }
                  },
                ),
                _buildFilterDropdown<String>(
                  title: 'Subcategory',
                  value: selectedSubcategory.isNotEmpty
                      ? selectedSubcategory
                      : null,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Select a subcategory'),
                    ),
                    ...subcategories.map<DropdownMenuItem<String>>((subcat) {
                      return DropdownMenuItem<String>(
                        value: subcat.name,
                        child: Text(subcat.name),
                      );
                    }).toList(),
                  ],
                  onChanged: subcategories.isEmpty
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              selectedSubcategory = value;
                            });
                          }
                        },
                ),
                const SizedBox(height: 12),
                _buildFilterDropdown<String>(
                  title: 'City',
                  value: selectedCity.isNotEmpty ? selectedCity : null,
                  items: [
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('All Cities'),
                    ),
                    ...filter_constants.FilterConstants.garageCities
                        .map<DropdownMenuItem<String>>((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCity = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            brand = selectedBrand;
                            model = selectedModel;
                            category = selectedCategory;
                            subcategory = selectedSubcategory;
                            city = selectedCity;
                          });
                          _searchSpareParts();
                          Navigator.pop(context);
                        },
                        child: Text('apply_filters'.tr()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(sparePartsSearchProvider);

    // Show loading indicator if this is the first build
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Ensure we have valid filter values
    if (brand.isEmpty && filter_constants.brandModels.isNotEmpty) {
      brand = filter_constants.brandModels.keys.first;
    }

    // Get available models for the selected brand with null safety
    final models =
        brand.isNotEmpty && filter_constants.brandModels.containsKey(brand)
            ? filter_constants.brandModels[brand]!.toSet().toList()
            : <String>[];

    // Ensure model is valid
    if (model.isNotEmpty && !models.contains(model)) {
      model = models.isNotEmpty ? models.first : '';
    }

    // Get available subcategories for the selected category with null safety
    String? categoryId;
    try {
      final categoryObj = filter_constants.FilterConstants.sparePartsCategories
          .firstWhere((cat) => cat['name'] == category);
      categoryId = categoryObj['id'] as String?;
    } catch (e) {
      // If category is not found, try to set a default one
      if (filter_constants.FilterConstants.sparePartsCategories.isNotEmpty) {
        final defaultCategory =
            filter_constants.FilterConstants.sparePartsCategories.first;
        category = defaultCategory['name'] ?? '';
        categoryId = defaultCategory['id'] as String?;
      } else {
        categoryId = null;
      }
    }

    final subcategories = categoryId != null
        ? filter_constants.FilterConstants.getSubcategories(categoryId)
        : <Subcategory>[];

    // Ensure subcategory is valid
    if (subcategory.isNotEmpty) {
      final subcategoryNames = subcategories.map((s) => s.name).toList();
      if (!subcategoryNames.contains(subcategory)) {
        subcategory = subcategories.isNotEmpty ? subcategories.first.name : '';
      }
    }

    return Scaffold(
      appBar: AnimatedSearchAppBar(),
      body: Column(
        children: [
          // Filter Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showFilterBottomSheet,
                    icon: const Icon(Icons.filter_list, size: 20),
                    label: const Text('Filter'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search results
          Expanded(
            child: searchState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load spare parts'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _searchSpareParts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (response) {
                if (response.profiles.isEmpty) {
                  return const Center(
                    child:
                        Text('No spare parts found for the selected criteria'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  itemCount: response.profiles.length,
                  itemBuilder: (context, index) {
                    final profile = response.profiles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: SparePartsCard(
                        partName: profile.storeName,
                        location: profile.city,
                        mobileNumber: profile.mobile,
                        partId:
                            '${profile.storeName}_${profile.mobile}', // Create a unique ID for wishlist
                        profile: profile,
                        imageUrl: 'https://via.placeholder.com/150',
                        onTap: () {
                          // Handle tap on spare part profile
                          // You can navigate to a detail screen or show contact info
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Contact Information',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  Text('Store: ${profile.storeName}'),
                                  const SizedBox(height: 8),
                                  Text('City: ${profile.city}'),
                                  const SizedBox(height: 8),
                                  Text('Phone: ${profile.mobile}'),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Implement call functionality
                                        // You can use url_launcher for this
                                      },
                                      icon: const Icon(Icons.phone),
                                      label: const Text('Call Now'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
