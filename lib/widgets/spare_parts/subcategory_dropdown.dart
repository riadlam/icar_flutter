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

    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: category != null ? onChanged : null,
          isExpanded: true, // Make the dropdown take full width
          decoration: InputDecoration(
            labelText: 'Subcategory',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            // Removed prefixIcon to avoid left icon on the subcategory row
          ),
          selectedItemBuilder: (BuildContext context) {
            return uniqueSubcategories.values.map<Widget>((subcategory) {
              debugPrint(
                  'Selected subcategory: ${subcategory.name} | imagePath: ${subcategory.imagePath}');
              return SizedBox(
                width:
                    constraints.maxWidth - 100, // Account for padding and icon
                child: Row(
                  children: [
                    if (subcategory.imagePath != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          subcategory.imagePath!,
                          width: 28,
                          height: 28,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(width: 28, height: 28),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        subcategory.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          items: uniqueSubcategories.values
              .map<DropdownMenuItem<String>>((subcategory) {
            debugPrint(
                'Dropdown subcategory item: ${subcategory.name} | imagePath: ${subcategory.imagePath}');
            return DropdownMenuItem<String>(
              value: subcategory.name,
              child: Row(
                children: [
                  if (subcategory.imagePath != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        subcategory.imagePath!,
                        width: 28,
                        height: 28,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(width: 28, height: 28),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      subcategory.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
