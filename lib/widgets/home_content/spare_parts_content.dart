import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';
import 'package:icar_instagram_ui/screens/subcategory_screen.dart';
import 'package:icar_instagram_ui/widgets/category_card.dart';
import 'base_content_widget.dart';


class SparePartsContent extends BaseContentWidget {
  const SparePartsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: FilterConstants.sparePartsCategories.length,
      itemBuilder: (context, index) {
        final category = FilterConstants.sparePartsCategories[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: CategoryCard(
            name: category['name']!,
            imagePath: category['image']!,
            onTap: () {
              // Navigate to subcategory screen
              final subcategories = FilterConstants.getSubcategories(category['id']!);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubcategoryScreen(
                    categoryId: category['id']!,
                    categoryName: category['name']!,
                    subcategories: subcategories,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
