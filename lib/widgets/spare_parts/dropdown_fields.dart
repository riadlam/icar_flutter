import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart' as filter_constants;

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
    return _buildDropdownField(
      context: context,
      value: value,
      onChanged: onChanged,
      items: filter_constants.brandModels.keys.toList(),
      label: label!,
      icon: icon!,
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
    final models = brand != null && filter_constants.brandModels.containsKey(brand)
        ? filter_constants.brandModels[brand]!
        : <String>[];

    return _buildDropdownField(
      context: context,
      value: value,
      onChanged: onChanged,
      items: models,
      label: label!,
      icon: icon!,
      enabled: brand != null,
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
    return _buildDropdownField(
      context: context,
      value: value,
      onChanged: onChanged,
      items: filter_constants.FilterConstants.sparePartsCategories
          .map((e) => e['name'] as String)
          .toList(),
      label: label!,
      icon: icon!,
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
  @override
  Widget build(BuildContext context) {
    List<String> subcategories = [];
    
    if (category != null) {
      // Find the category ID from the category name
      final categoryObj = filter_constants.FilterConstants.sparePartsCategories
          .firstWhere(
            (c) => c['name'] == category,
            orElse: () => <String, String>{},
          );
          
      if (categoryObj.isNotEmpty) {
        final categoryId = categoryObj['id']!;
        subcategories = filter_constants.FilterConstants
            .getSubcategories(categoryId)
            .map((e) => e.name)
            .toList();
      }
    }

    return _buildDropdownField(
      context: context,
      value: value,
      onChanged: onChanged,
      items: subcategories,
      label: label!,
      icon: icon!,
      enabled: category != null,
    );
  }
}

Widget _buildDropdownField({
  required BuildContext context,
  required String? value,
  required ValueChanged<String?> onChanged,
  required List<String> items,
  required String label,
  required IconData icon,
  bool enabled = true,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    onChanged: enabled ? onChanged : null,
    items: items.map((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            color: enabled
                ? Theme.of(context).textTheme.bodyLarge?.color
                : Theme.of(context).hintColor,
            fontSize: 16,
          ),
        ),
      );
    }).toList(),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Theme.of(context).hintColor,
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: Theme.of(context).hintColor),
      filled: true,
      fillColor: Theme.of(context).cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    ),
    icon: Icon(
      Icons.arrow_drop_down,
      color: Theme.of(context).hintColor,
    ),
    dropdownColor: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(8),
    isExpanded: true,
    menuMaxHeight: 300,
    disabledHint: Text(
      'Select ${label.toLowerCase()} first',
      style: TextStyle(
        color: Theme.of(context).hintColor,
        fontSize: 16,
      ),
    ),
  );
}
