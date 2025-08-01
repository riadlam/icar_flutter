import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart'
    as filter_constants;
import 'package:icar_instagram_ui/constants/brand_images.dart';

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
    // Get brands from filter_constants
    final List<String> brands = filter_constants.brandModels.keys.toList()
      ..sort();
    debugPrint('Building BrandDropdownField. Brands count: ${brands.length}');

    // Ensure the current value is in the list if it's not null
    if (value != null && !brands.contains(value)) {
      // If the current value isn't in the list, add it to avoid errors
      brands.add(value!);
    }

    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Brand',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        // Removed prefixIcon to avoid left icon on the brand row
      ),
      items: [
        // Add a null item as the first option
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Select a brand'),
        ),
        // Add all the brands
        ...brands.map<DropdownMenuItem<String>>((String brand) {
          final imagePath = BrandImages.getBrandImagePath(brand);
          debugPrint('Dropdown item: $brand | imagePath: $imagePath');
          return DropdownMenuItem<String>(
            value: brand,
            child: Row(
              children: [
                if (imagePath != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      imagePath,
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(width: 28, height: 28),
                    ),
                  ),
                Text(brand),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
