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
    final selectedValue =
        categories.any((cat) => cat['name'] == value) ? value : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          isExpanded: true, // Make the dropdown take full width
          decoration: InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            // Removed prefixIcon to avoid left icon on the category row
          ),
          selectedItemBuilder: (BuildContext context) {
            return categories.map<Widget>((category) {
              final name = category['name'] as String;
              final imagePath = category['image'] as String?;
              return SizedBox(
                width:
                    constraints.maxWidth - 100, // Account for padding and icon
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
                    Expanded(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          items: categories.map<DropdownMenuItem<String>>((category) {
            final name = category['name'] as String;
            final imagePath = category['image'] as String?;
            debugPrint('Dropdown category item: $name | imagePath: $imagePath');
            return DropdownMenuItem<String>(
              value: name,
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
                  Expanded(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            );
          }).toList()
            ..sort((a, b) => (a.value ?? '').compareTo(b.value ?? '')),
        );
      },
    );
  }
}
