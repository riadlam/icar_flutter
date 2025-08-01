import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart'
    as filter_constants;

class ModelDropdownField extends StatelessWidget {
  final String? brand;
  final String? value;
  final ValueChanged<String?> onChanged;

  const ModelDropdownField({
    Key? key,
    required this.brand,
    required this.value,
    required this.onChanged,
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
        labelText: 'Model',
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
