import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
  late double _selectedYear;
  late RangeValues _priceRange;
  late double _mileage;
  late String _selectedBrand;
  late String _purchaseType; // 'buy', 'rent', or 'all'
  late String _transmission; // 'automatic', 'manual', or 'all'
  late String _fuelType; // 'gasoline', 'diesel', 'electric', 'hybrid', 'plug_in_hybrid', or 'all'

  @override
  void initState() {
    super.initState();
    // Initialize with default values or from initialFilters
    _selectedYear = (widget.initialFilters?['year'] as num?)?.toDouble() ?? 2020.0;
    _priceRange = RangeValues(
      (widget.initialFilters?['minPrice'] as num?)?.toDouble() ?? 0.0,
      (widget.initialFilters?['maxPrice'] as num?)?.toDouble() ?? 100000.0,
    );
    _mileage = (widget.initialFilters?['mileage'] as num?)?.toDouble() ?? 50000.0;
    _selectedBrand = widget.initialFilters?['brand'] as String? ?? 'all';
    _purchaseType = widget.initialFilters?['purchaseType'] as String? ?? 'all';
    _transmission = widget.initialFilters?['transmission'] as String? ?? 'all';
    _fuelType = widget.initialFilters?['fuelType'] as String? ?? 'all';
  }
 
  void _applyFilters() {
    print('Applying filters...');
    final filters = <String, dynamic>{
      if (_selectedBrand != 'all' && _selectedBrand != 'all'.tr()) 'brand': _selectedBrand,
      if (_purchaseType != 'all' && _purchaseType != 'all'.tr()) 'type': _purchaseType,
      if (_selectedYear != 2020) 'year': _selectedYear.toInt(),
      if (_transmission != 'all' && _transmission != 'all'.tr()) 'transmission': _transmission,
      if (_fuelType != 'all' && _fuelType != 'all'.tr()) 'fuel_type': _fuelType,
      if (_mileage != 50000) 'mileage': _mileage.toInt(),
    };
    
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'filter_by'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),
          _buildSectionTitle('brand'.tr()),
          _buildChips(
            [
              'all'.tr(),
              'brand_toyota'.tr(),
              'brand_honda'.tr(),
              'brand_nissan'.tr(),
              'brand_bmw'.tr(),
              'brand_mercedes'.tr(),
            ],
            _selectedBrand,
            (value) => setState(() => _selectedBrand = value),
          ),
          
          
          
          _buildSectionTitle('purchase_type'.tr()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPurchaseTypeRadio('all', _purchaseType, (value) {
                    setState(() => _purchaseType = value!);
                  }),
                  _buildPurchaseTypeRadio('buy', _purchaseType, (value) {
                    setState(() => _purchaseType = value!);
                  }),
                  _buildPurchaseTypeRadio('rent', _purchaseType, (value) {
                    setState(() => _purchaseType = value!);
                  }),
                ],
              ),

          ),
          
          _buildSectionTitle('year'.tr()),
          _buildYearRangeSlider(),
          
          _buildSectionTitle('price_range'.tr()),
          _buildPriceRangeSlider(),
          
          _buildSectionTitle('mileage'.tr()),
          _buildMileageSlider(),
          
          _buildSectionTitle('transmission'.tr()),
          _buildChips(
            ['all'.tr(), 'automatic'.tr(), 'manual'.tr()],
            _transmission,
            (value) => setState(() => _transmission = value),
          ),
          
          _buildSectionTitle('fuel_type'.tr()),
          _buildChips(
            [
              'all'.tr(),
              'gasoline'.tr(),
              'diesel'.tr(),
              'electric'.tr(),
              'hybrid'.tr(),
              'plug_in_hybrid'.tr(),
            ],
            _fuelType,
            (value) => setState(() => _fuelType = value),
          ),
          
        
          
          const SizedBox(height: 20),
          _buildActionButtons(),
          const SizedBox(height: 20),
        ],
      ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildChips(List<String> options, String selected, Function(String) onSelected) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(_getTranslatedOption(option)),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
              backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  String _getTranslatedOption(String option) {
    switch (option) {
      case 'all':
        return 'all'.tr();
      case 'buy':
      case 'rent':
      case 'automatic':
      case 'manual':
      case 'gasoline':
      case 'diesel':
      case 'electric':
      case 'hybrid':
      case 'plug_in_hybrid':
      case 'sedan':
      case 'suv':
      case 'truck':
      case 'hatchback':
      case 'coupe':
      case 'convertible':
        return option.tr();
      default:
        return option;
    }
  }

  Widget _buildYearRangeSlider() {
    return Column(
      children: [
        Slider(
          value: _selectedYear,
          min: 2000,
          max: 2023,
          divisions: 23,
          label: _selectedYear.round().toString(),
          onChanged: (value) {
            setState(() {
              _selectedYear = value;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('year_min'.tr()),
              Text('year_max'.tr()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 200000,
          divisions: 20,
          labels: RangeLabels(
            formatPrice(_priceRange.start),
            formatPrice(_priceRange.end),
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('price_min'.tr()),
              Text('price_max'.tr()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseTypeRadio(String title, String groupValue, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: title,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: Colors.pinkAccent,
        ),
        Text(
          title == 'all' ? 'all'.tr() : title == 'buy' ? 'buy'.tr() : 'rent'.tr(),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildMileageSlider() {
    return Column(
      children: [
        Slider(
          value: _mileage,
          min: 0,
          max: 200000,
          divisions: 20,
          label: '${(_mileage / 1000).round()}K ${'unit_kilometers_abbr'.tr()}',
          onChanged: (value) {
            setState(() {
              _mileage = value;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 ${'unit_km'.tr()}'),
              Text('200 ${'unit_km'.tr()}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Reset button
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedBrand = 'all';
                  _purchaseType = 'all';
                  _selectedYear = 2020;
                  _priceRange = const RangeValues(0, 100000);
                  _mileage = 50000;
                  _transmission = 'all';
                  _fuelType = 'all';
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'reset'.tr(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Apply button
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'apply_filters'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
