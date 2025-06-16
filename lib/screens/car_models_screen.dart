import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';

class CarModelsScreen extends StatelessWidget {
  final String brand;

  const CarModelsScreen({
    Key? key,
    required this.brand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final models = brandModels[brand] ?? [];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('$brand Models'),
      ),
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
                // Handle model selection
                // You can navigate to another screen or return the selected model
                Navigator.pop(context, models[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
