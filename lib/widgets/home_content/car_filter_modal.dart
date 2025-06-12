import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';

class CarFilterModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;
  final Map<String, dynamic>? initialFilters;
  
  const CarFilterModal({
    Key? key, 
    required this.onApplyFilters,
    this.initialFilters,
  }) : super(key: key);

  @override
  _CarFilterModalState createState() => _CarFilterModalState();
}

class _CarFilterModalState extends State<CarFilterModal> {
  // Filter states
  late String? _selectedYear;
  late String? _selectedMinPrice;
  late String? _selectedMaxPrice;
  late String? _selectedMileage;
  late String? _selectedBrand;
  late String? _selectedModel;
  late String? _purchaseType;
  late String? _transmission;
  late String? _fuelType;
  
  // Available models based on selected brand
  late List<String> _availableModels = [];
  
  // Constants
  final List<String> _years = FilterConstants.years;
  final List<String> _brands = FilterConstants.brands;
  final List<String> _purchaseTypes = FilterConstants.purchaseTypes;
  final List<String> _transmissions = FilterConstants.transmissions;
  final List<String> _fuelTypes = FilterConstants.fuelTypes;
  final List<String> _priceRanges = FilterConstants.priceRangesDZD;
  
  // Current theme
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colorScheme = _theme.colorScheme;

  @override
  void initState() {
    super.initState();
    // Initialize with default values or from initialFilters
    _selectedYear = widget.initialFilters?['year']?.toString();
    
    // Initialize price filters
    _selectedMinPrice = widget.initialFilters?['minPrice'] != null
        ? FilterConstants.intToPriceString(widget.initialFilters!['minPrice'] as int)
        : null;
    _selectedMaxPrice = widget.initialFilters?['maxPrice'] != null
        ? FilterConstants.intToPriceString(widget.initialFilters!['maxPrice'] as int)
        : null;
        
    _selectedMileage = widget.initialFilters?['mileage']?.toString();
    _selectedBrand = widget.initialFilters?['brand'] as String?;
    _selectedModel = widget.initialFilters?['model'] as String?;
    _purchaseType = widget.initialFilters?['purchaseType'] as String?;
    _transmission = widget.initialFilters?['transmission'] as String?;
    _fuelType = widget.initialFilters?['fuelType'] as String?;
    
    // Initialize available models if brand is already selected
    if (_selectedBrand != null) {
      _availableModels = FilterConstants.getModelsForBrand(_selectedBrand!);
    }
  }
 
  // Update available models when brand changes
  void _onBrandChanged(String? brand) {
    setState(() {
      _selectedBrand = brand;
      _selectedModel = null; // Reset model when brand changes
      _availableModels = brand != null ? FilterConstants.getModelsForBrand(brand) : [];
    });
  }

  void _applyFilters() {
    print('🔄 Applying filters...');
    final minPrice = _selectedMinPrice != null
        ? FilterConstants.priceStringToInt(_selectedMinPrice!)
        : null;
    final maxPrice = _selectedMaxPrice != null
        ? FilterConstants.priceStringToInt(_selectedMaxPrice!)
        : null;

    final filters = <String, dynamic>{};
    
    // Add filters with debug logging
    if (_selectedBrand != null) {
      filters['brand'] = _selectedBrand;
      print('✅ Added brand to filters: ${_selectedBrand}');
    }
    
    if (_selectedModel != null) {
      filters['model'] = _selectedModel;
      print('✅ Added model to filters: ${_selectedModel}');
    } else {
      print('ℹ️ No model selected');
    }
    
    if (_purchaseType != null) {
      filters['type'] = _purchaseType;
      print('✅ Added type to filters: $_purchaseType');
    }
    
    if (_selectedYear != null) {
      final year = int.tryParse(_selectedYear!);
      if (year != null) {
        filters['year'] = year;
        print('✅ Added year to filters: $year');
      }
    }
    
    if (_transmission != null) {
      filters['transmission'] = _transmission;
      print('✅ Added transmission to filters: $_transmission');
    }
    
    if (_fuelType != null) {
      filters['fuelType'] = _fuelType;
      print('✅ Added fuelType to filters: $_fuelType');
    }
    
    if (_selectedMileage != null) {
      filters['mileage'] = _selectedMileage;
      print('✅ Added mileage to filters: $_selectedMileage');
    }
    
    if (minPrice != null) {
      filters['minPrice'] = minPrice;
      print('✅ Added minPrice to filters: $minPrice');
    }
    
    if (maxPrice != null) {
      filters['maxPrice'] = maxPrice;
      print('✅ Added maxPrice to filters: $maxPrice');
    }
    
    print('📋 Filters to apply: $filters');
    
    print('Filters to apply: $filters');
    
    // Call the callback first
    widget.onApplyFilters(filters);
    
    // Then safely pop the modal if we're still mounted
    if (mounted && Navigator.canPop(context)) {
      print('Closing filter modal...');
      Navigator.of(context).pop(filters);
    } else if (mounted) {
      // If we can't pop, just close the modal without popping
      print('Cannot pop navigator, using maybePop instead...');
      Navigator.maybePop(context);
    }
  }

  // Format price for display
  String formatPrice(double value) {
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }
  
  // Build section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _colorScheme.onSurface.withOpacity(0.9),
        ),
      ),
    );
  }

  // Helper method to build dropdown form field
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 0,
              fontWeight: FontWeight.w500,
              color: _colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _theme.dividerColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: _colorScheme.onSurface.withOpacity(0.6)),
              hint: Text('Select ${label.toLowerCase()}', style: TextStyle(color: _colorScheme.onSurface.withOpacity(0.5))),
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      color: _colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeDropdowns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('price_range'.tr()),
        Padding(
          padding: const EdgeInsets.symmetric( vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'min_price'.tr(),
                  value: _selectedMinPrice,
                  items: [
                    'Min Price',
                    ..._priceRanges
                  ],
                  onChanged: (value) {
                    if (value == 'Min Price') return;
                    setState(() {
                      _selectedMinPrice = value;
                      // Ensure min price doesn't exceed max price
                      if (_selectedMaxPrice != null && 
                          FilterConstants.priceStringToInt(value!) > 
                          FilterConstants.priceStringToInt(_selectedMaxPrice!)) {
                        _selectedMaxPrice = value;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: 'max_price'.tr(),
                  value: _selectedMaxPrice,
                  items: [
                    'Max Price',
                    ..._priceRanges.where((price) =>
                      _selectedMinPrice == null ||
                      FilterConstants.priceStringToInt(price) >= 
                      FilterConstants.priceStringToInt(_selectedMinPrice!)
                    ).toList()
                  ],
                  onChanged: (value) {
                    if (value == 'Max Price') return;
                    setState(() {
                      _selectedMaxPrice = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build year dropdown field instead of slider for better UX
  Widget _buildYearField() {
    return _buildDropdownField(
      label: 'select_year'.tr(),
      value: _selectedYear,
      items: _years,
      onChanged: (value) {
        setState(() {
          _selectedYear = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'filter_cars'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20,
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            
            // Filter options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Brand
                  _buildSectionHeader('brand'.tr()),
                  _buildDropdownField(
                    label: 'select_brand'.tr(),
                    value: _selectedBrand,
                    items: _brands,
                    onChanged: _onBrandChanged,
                  ),
                  
                  // Model (only shown when a brand is selected)
                  if (_selectedBrand != null && _availableModels.isNotEmpty) ...[
                    _buildSectionHeader('model'.tr()),
                    _buildDropdownField(
                      label: 'select_model'.tr(),
                      value: _selectedModel,
                      items: _availableModels,
                      onChanged: (value) {
                        setState(() {
                          _selectedModel = value;
                        });
                      },
                    ),
                  ],

                  // Year
                  _buildSectionHeader('year'.tr()),
                  _buildYearField(),

                  // Price Range
                  _buildPriceRangeDropdowns(),

                  // Transmission
                  _buildSectionHeader('transmission'.tr()),
                  _buildDropdownField(
                    label: 'select_transmission'.tr(),
                    value: _transmission,
                    items: _transmissions,
                    onChanged: (value) {
                      setState(() {
                        _transmission = value;
                      });
                    },
                  ),

                  // Fuel Type
                  _buildSectionHeader('fuel_type'.tr()),
                  _buildDropdownField(
                    label: 'select_fuel_type'.tr(),
                    value: _fuelType,
                    items: _fuelTypes,
                    onChanged: (value) {
                      setState(() {
                        _fuelType = value;
                      });
                    },
                  ),

                  // Purchase Type
                  _buildSectionHeader('purchase_type'.tr()),
                  _buildDropdownField(
                    label: 'select_purchase_type'.tr(),
                    value: _purchaseType,
                    items: _purchaseTypes,
                    onChanged: (value) {
                      setState(() {
                        _purchaseType = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.loginbg,
                  foregroundColor: _colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'apply_filters'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            // Add some bottom padding for better scrolling on smaller devices
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
          ],
        ),
      ),
    );
  }
}
