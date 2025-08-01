import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';

class TowTruckFiltersSheet extends StatefulWidget {
  final String? initialCity;
  final ValueChanged<Map<String, String?>> onApplyFilters;

  const TowTruckFiltersSheet({
    Key? key,
    this.initialCity,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _TowTruckFiltersSheetState createState() => _TowTruckFiltersSheetState();
}

class _TowTruckFiltersSheetState extends State<TowTruckFiltersSheet> {
  late String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialCity;
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
            'Filter Tow Trucks',
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters({
                      'city': _selectedCity,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'apply_filters'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
