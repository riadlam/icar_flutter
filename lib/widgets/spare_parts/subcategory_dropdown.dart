import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';
import 'package:icar_instagram_ui/models/subcategory_model.dart';

class SubcategoryDropdownField extends StatelessWidget {
  final String? category;
  final String? value;
  final ValueChanged<String?> onChanged;

  const SubcategoryDropdownField({
    Key? key,
    required this.category,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Subcategory> subcategories = [];
    
    if (category != null) {
      // Find the category ID from the category name
      final categoryObj = FilterConstants.sparePartsCategories.firstWhere(
        (c) => c['name'] == category,
        orElse: () => <String, String>{},
      );
          
      if (categoryObj.isNotEmpty) {
        final categoryId = categoryObj['id']!;
        subcategories = FilterConstants.getSubcategories(categoryId);
      }
    }

    // Convert to a map to ensure unique values
    final uniqueSubcategories = <String, Subcategory>{};
    for (var sub in subcategories) {
      uniqueSubcategories[sub.name] = sub;
    }
    
    // If the current value is not in the list, set it to null
    final selectedValue = uniqueSubcategories.containsKey(value) ? value : null;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: category != null ? onChanged : null,
      decoration: InputDecoration(
        labelText: 'Subcategory',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: const Icon(Icons.subdirectory_arrow_right),
      ),
      items: uniqueSubcategories.values.map<DropdownMenuItem<String>>((subcategory) {
        return DropdownMenuItem<String>(
          value: subcategory.name,
          child: Text(subcategory.name),
        );
      }).toList(),
    );
  }
}
