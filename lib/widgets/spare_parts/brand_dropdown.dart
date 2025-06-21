import 'package:flutter/material.dart';

class BrandDropdownField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const BrandDropdownField({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample brands - replace with your actual data
    final List<String> brands = [
      'Audi',
      'BMW',
      'Mercedes',
      'Volkswagen',
      'Renault',
      'Peugeot',
      'Citroen',
      'Toyota',
      'Ford',
      'Hyundai',
      'Kia',
      'Dacia',
      'Nissan',
      'Opel',
      'Skoda',
      'Seat',
      'Fiat',
    ];

    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Brand',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: const Icon(Icons.branding_watermark),
      ),
      items: brands.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
