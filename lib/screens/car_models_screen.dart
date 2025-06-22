import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';
import 'package:icar_instagram_ui/outils/appbar_custom.dart';

class CarModelsScreen extends StatelessWidget {
  final String brand;
  final String category;
  final String subcategory;

  const CarModelsScreen({
    Key? key,
    required this.brand,
    this.category = '',
    this.subcategory = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final models = brandModels[brand] ?? [];
    
    return Scaffold(
      appBar:AnimatedSearchAppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: models.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                models[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                // Navigate to results screen with search parameters
                context.push(
                  '/spare-parts-list',
                  extra: {
                    'brand': brand,
                    'model': models[index],
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
