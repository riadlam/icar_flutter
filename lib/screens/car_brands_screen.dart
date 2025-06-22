import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';
import 'package:icar_instagram_ui/outils/appbar_custom.dart';
import 'package:icar_instagram_ui/widgets/category_card.dart';

class CarBrandsScreen extends StatelessWidget {
  final String category;
  final String subcategory;

  const CarBrandsScreen({
    Key? key,
    this.category = '',
    this.subcategory = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brands = brandModels.keys.toList()..sort();
    
    return Scaffold(
      appBar:AnimatedSearchAppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          final imagePath = 'assets/images/brandimages/$brand.PNG';
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: CategoryCard(
              name: brand,
              imagePath: imagePath,
              onTap: () {
                // Navigate to car models with brand, category, and subcategory
                context.push(
                  '/car-models',
                  extra: {
                    'brand': brand,
                    'category': category,
                    'subcategory': subcategory,
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
