import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icar_instagram_ui/models/subcategory_model.dart';
import 'package:icar_instagram_ui/outils/appbar_custom.dart';
import 'package:icar_instagram_ui/widgets/category_card.dart';

class SubcategoryScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final List<Subcategory> subcategories;

  const SubcategoryScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.subcategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:AnimatedSearchAppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: CategoryCard(
              name: subcategory.name,
              imagePath: subcategory.imagePath,
              onTap: () {
                // Navigate to car brands screen with category and subcategory information
                context.push(
                  '/car-brands',
                  extra: {
                    'categoryName': categoryName,
                    'subcategoryName': subcategory.name,
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
