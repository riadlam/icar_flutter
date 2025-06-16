import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/widgets/cards/spare_parts_card.dart';

class SparePartsListScreen extends StatelessWidget {
  final String brand;
  final String model;

  const SparePartsListScreen({
    Key? key,
    required this.brand,
    required this.model,
  }) : super(key: key);

  // Dummy data for spare parts
  final List<Map<String, dynamic>> _dummySpareParts = const [
    {
      'partName': 'Brake Pads',
      'price': '75.99',
      'condition': 'New',
      'location': 'Casablanca',
      'sellerName': 'AutoParts Pro',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'partName': 'Air Filter',
      'price': '29.99',
      'condition': 'New',
      'location': 'Rabat',
      'sellerName': 'Car Care Plus',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'partName': 'Oil Filter',
      'price': '15.99',
      'condition': 'New',
      'location': 'Marrakech',
      'sellerName': 'Quick Fix Auto',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'partName': 'Spark Plugs (Set of 4)',
      'price': '45.50',
      'condition': 'New',
      'location': 'Tangier',
      'sellerName': 'Auto Tech',
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$brand $model - Spare Parts'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        itemCount: _dummySpareParts.length,
        itemBuilder: (context, index) {
          final part = _dummySpareParts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: SparePartsCard(
              partName: part['partName'],
              price: '${part['price']} DH',
              condition: part['condition'],
              location: part['location'],
              sellerName: part['sellerName'],
              imageUrl: part['imageUrl'],
              onTap: () {
                // Handle tap on spare part
                // You can navigate to a detail screen here
              },
            ),
          );
        },
      ),
    );
  }
}
