import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';

class CategoryDropdownField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const CategoryDropdownField({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = FilterConstants.sparePartsCategories;
    
    // If there's a value but it's not in the current list, set it to null
    final selectedValue = categories.any((cat) => cat['name'] == value) ? value : null;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: const Icon(Icons.category),
      ),
      items: categories.map<DropdownMenuItem<String>>((category) {
        final name = category['name'] as String;
        return DropdownMenuItem<String>(
          value: name, // Using name as value
          child: Text(name),
        );
      }).toList()..sort((a, b) => (a.value ?? '').compareTo(b.value ?? '')),
    );
  }
}
