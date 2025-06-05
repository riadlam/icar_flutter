import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';

class GarageFiltersSheet extends StatefulWidget {
  final String? initialCity;
  final String? initialService;
  final ValueChanged<Map<String, String?>> onApplyFilters;

  const GarageFiltersSheet({
    Key? key,
    this.initialCity,
    this.initialService,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _GarageFiltersSheetState createState() => _GarageFiltersSheetState();
}

class _GarageFiltersSheetState extends State<GarageFiltersSheet> {
  late String? _selectedCity;
  late String? _selectedService;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialCity;
    _selectedService = widget.initialService;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Filter Garages',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedCity,
            decoration: const InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('All Cities'),
              ),
              ...FilterConstants.garageCities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCity = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedService,
            decoration: const InputDecoration(
              labelText: 'Service',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('All Services'),
              ),
              ...FilterConstants.garageServices.map((service) {
                return DropdownMenuItem(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
            ],
            onChanged: (value) {
              setState(() {
                _selectedService = value;
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final filters = {
                'city': _selectedCity,
                'services': _selectedService,
              };
              
              // Log the request body
              debugPrint('🎯 Applying filters:');
              debugPrint('   - City: ${_selectedCity ?? 'All'}');
              debugPrint('   - Service: ${_selectedService ?? 'All'}');
              debugPrint('Full filters object: $filters');
              
              widget.onApplyFilters(filters);
              Navigator.of(context).pop();
            },
            child: const Text('Apply Filters'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCity = null;
                _selectedService = null;
              });
            },
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }
}
