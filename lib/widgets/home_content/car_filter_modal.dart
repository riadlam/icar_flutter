import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CarFilterModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;
  
  const CarFilterModal({Key? key, required this.onApplyFilters}) : super(key: key);

  @override
  _CarFilterModalState createState() => _CarFilterModalState();
}

class _CarFilterModalState extends State<CarFilterModal> {
  // Filter states
  RangeValues _yearRange = const RangeValues(2010, 2023);
  RangeValues _priceRange = const RangeValues(0, 100000);
  double _mileage = 50000;
  String _selectedBrand = 'all';
  String _selectedModel = 'all';
  String _purchaseType = 'all'; // 'buy', 'rent', or 'all'
  String _transmission = 'all'; // 'automatic', 'manual', or 'all'
  String _fuelType = 'all'; // 'gasoline', 'diesel', 'electric', 'hybrid', 'plug_in_hybrid', or 'all'
  String _vehicleType = 'all'; // 'sedan', 'suv', 'truck', 'hatchback', 'coupe', 'convertible', or 'all'

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
            ['all'.tr(), 'Toyota', 'Honda', 'Nissan', 'BMW', 'Mercedes'],
            _selectedBrand,
            (value) => setState(() => _selectedBrand = value),
          ),
          
          _buildSectionTitle('model'.tr()),
          _buildChips(
            ['all'.tr(), 'Camry', 'Corolla', 'Civic', 'Accord', 'Altima'],
            _selectedModel,
            (value) => setState(() => _selectedModel = value),
          ),
          
          _buildSectionTitle('purchase_type'.tr()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPurchaseTypeRadio('all'.tr(), _purchaseType, (value) {
                  setState(() => _purchaseType = value!);
                }),
                _buildPurchaseTypeRadio('buy'.tr(), _purchaseType, (value) {
                  setState(() => _purchaseType = value!);
                }),
                _buildPurchaseTypeRadio('rent'.tr(), _purchaseType, (value) {
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
          
          _buildSectionTitle('vehicle_type'.tr()),
          _buildChips(
            [
              'all'.tr(),
              'sedan'.tr(),
              'suv'.tr(),
              'truck'.tr(),
              'hatchback'.tr(),
              'coupe'.tr(),
              'convertible'.tr(),
            ],
            _vehicleType,
            (value) => setState(() => _vehicleType = value),
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
        RangeSlider(
          values: _yearRange,
          min: 2000,
          max: 2023,
          divisions: 23,
          labels: RangeLabels(
            _yearRange.start.round().toString(),
            _yearRange.end.round().toString(),
          ),
          onChanged: (values) {
            setState(() {
              _yearRange = values;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('2000'),
              Text('2023'),
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
              Text(r'$0'),
              Text(r'$200K'),
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
          label: '${(_mileage / 1000).round()}K Km',
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
              Text('0 km'),
              Text('200 km'),
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
                  _selectedModel = 'all';
                  _purchaseType = 'all';
                  _yearRange = const RangeValues(2010, 2023);
                  _priceRange = const RangeValues(0, 100000);
                  _mileage = 50000;
                  _transmission = 'all';
                  _fuelType = 'all';
                  _vehicleType = 'all';
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
              onPressed: () {
                final filters = {
                  'brand': _selectedBrand,
                  'model': _selectedModel,
                  'purchaseType': _purchaseType,
                  'minYear': _yearRange.start.round(),
                  'maxYear': _yearRange.end.round(),
                  'minPrice': _priceRange.start.round(),
                  'maxPrice': _priceRange.end.round(),
                  'mileage': _mileage.round(),
                  'transmission': _transmission,
                  'fuelType': _fuelType,
                  'vehicleType': _vehicleType,
                };
                widget.onApplyFilters(filters);
                Navigator.pop(context);
              },
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
