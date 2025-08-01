import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart'
    as filter_constants;
import 'package:icar_instagram_ui/constants/brand_images.dart';

class BrandDropdownField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? label;
  final IconData? icon;

  const BrandDropdownField({
    Key? key,
    this.value,
    required this.onChanged,
    this.label = 'Brand',
    this.icon = Icons.branding_watermark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> brands = filter_constants.brandModels.keys.toList()
      ..sort();
    debugPrint('Building BrandDropdownField. Brands count: ${brands.length}');

    // Ensure the current value is in the list if it's not null
    if (value != null && !brands.contains(value)) {
      brands.add(value!);
    }

    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
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
              mainAxisSize: MainAxisSize.min,
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
                Flexible(
                  child: Text(
                    brand,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

class ModelDropdownField extends StatelessWidget {
  final String? brand;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? label;
  final IconData? icon;

  const ModelDropdownField({
    Key? key,
    required this.brand,
    this.value,
    required this.onChanged,
    this.label = 'Model',
    this.icon = Icons.directions_car,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final models =
        (brand != null && filter_constants.brandModels.containsKey(brand))
            ? filter_constants.brandModels[brand]!
                .toSet()
                .toList() // Ensure unique models
            : <String>[];

    return DropdownButtonFormField<String>(
      value: value,
      onChanged: brand != null ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        // Removed prefixIcon to avoid left icon on the model row
      ),
      items: models.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class CategoryDropdownField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? label;
  final IconData? icon;

  const CategoryDropdownField({
    Key? key,
    this.value,
    required this.onChanged,
    this.label = 'Category',
    this.icon = Icons.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = filter_constants.FilterConstants.sparePartsCategories;

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
            labelText: label,
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
                  mainAxisSize: MainAxisSize.min,
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
                    Flexible(
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
                mainAxisSize: MainAxisSize.min,
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
                  Flexible(
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

class SubcategoryDropdownField extends StatelessWidget {
  final String? category;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? label;
  final IconData? icon;

  const SubcategoryDropdownField({
    Key? key,
    required this.category,
    this.value,
    required this.onChanged,
    this.label = 'Subcategory',
    this.icon = Icons.subdirectory_arrow_right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> subcategories = [];

    if (category != null) {
      // Find the category ID from the category name
      final categoryObj =
          filter_constants.FilterConstants.sparePartsCategories.firstWhere(
        (c) => c['name'] == category,
        orElse: () => <String, String>{},
      );

      if (categoryObj.isNotEmpty) {
        final categoryId = categoryObj['id']!;
        subcategories =
            filter_constants.FilterConstants.getSubcategories(categoryId);
      }
    }

    // Convert to a map to ensure unique values
    final uniqueSubcategories = <String, dynamic>{};
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
            labelText: label,
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
                  mainAxisSize: MainAxisSize.min,
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
                    Flexible(
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
                mainAxisSize: MainAxisSize.min,
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
                  Flexible(
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
