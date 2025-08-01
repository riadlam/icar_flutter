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

  // All brands with exact image paths matching the filenames in assets
  static const Map<String, String> testBrands = {
    'Abarth': 'assets/images/brandimages/abarth.png',
    'Acura': 'assets/images/brandimages/Accura.png',
    'Alfa Romeo': 'assets/images/brandimages/Alfa-Romeo.png',
    'Aston Martin': 'assets/images/brandimages/Aston-Martin.png',
    'Audi': 'assets/images/brandimages/audi.png',
    'Baojun': 'assets/images/brandimages/baojun.png',
    'Bentley': 'assets/images/brandimages/bentley.png',
    'BMW': 'assets/images/brandimages/BMW.png',
    'Brilliance': 'assets/images/brandimages/brilliance.png',
    'Bugatti': 'assets/images/brandimages/bugatti.png',
    'BYD': 'assets/images/brandimages/BYD.PNG',
    "BUICK": 'assets/images/brandimages/buick.png',
    'Cadillac': 'assets/images/brandimages/Cadillac.PNG',
    'Chevrolet': 'assets/images/brandimages/Chevrolet.PNG',
    'Chrysler': 'assets/images/brandimages/Chrysler.PNG',
    'Citroën': 'assets/images/brandimages/Citroën.PNG',
    'Cupra': 'assets/images/brandimages/Cupra.PNG',
    'DFM': 'assets/images/brandimages/DFM.PNG',
    'DS Automobiles': 'assets/images/brandimages/DS Automobiles.PNG',
    'Dacia': 'assets/images/brandimages/Dacia.PNG',
    'Daewoo': 'assets/images/brandimages/Daewoo.PNG',
    'Daihatsu': 'assets/images/brandimages/Daihatsu.PNG',
    'Datsun': 'assets/images/brandimages/Datsun.PNG',
    'Dodge': 'assets/images/brandimages/Dodge.PNG',
    'Ferrari': 'assets/images/brandimages/Ferrari.PNG',
    'Fiat': 'assets/images/brandimages/Fiat.PNG',
    'Ford': 'assets/images/brandimages/Ford.PNG',
    'GMC': 'assets/images/brandimages/GMC.PNG',
    'Genesis': 'assets/images/brandimages/Genesis.PNG',
    'Honda': 'assets/images/brandimages/Honda.PNG',
    'Hyundai': 'assets/images/brandimages/Hyundai.PNG',
    'Infiniti': 'assets/images/brandimages/Infiniti.PNG',
    'Isuzu': 'assets/images/brandimages/Isuzu.PNG',
    'Jaguar': 'assets/images/brandimages/Jaguar.PNG',
    'Jeep': 'assets/images/brandimages/Jeep.PNG',
    'Kia': 'assets/images/brandimages/KIA.PNG',
    'Koenigsegg': 'assets/images/brandimages/Koenigsegg.PNG',
    'Lamborghini': 'assets/images/brandimages/Lamborghini.PNG',
    'Lancia': 'assets/images/brandimages/Lancia.PNG',
    'Land Rover': 'assets/images/brandimages/Land Rover.PNG',
    'Lexus': 'assets/images/brandimages/Lexus.PNG',
    'Lincoln': 'assets/images/brandimages/Lincoln.PNG',
    'Lotus': 'assets/images/brandimages/Lotus.PNG',
    'Maserati': 'assets/images/brandimages/Maserati.PNG',
    'Mazda': 'assets/images/brandimages/Mazda.PNG',
    'McLaren': 'assets/images/brandimages/McLaren.PNG',
    'Mercedes-Benz': 'assets/images/brandimages/Mercedes-Benz.PNG',
    'Mini': 'assets/images/brandimages/Mini.PNG',
    'Mitsubishi': 'assets/images/brandimages/Mitsubishi.PNG',
    "Mahindra": 'assets/images/brandimages/Mahindra.PNG',
    'Nissan': 'assets/images/brandimages/nissan.png',
    'Opel': 'assets/images/brandimages/opel.png',
    'Peugeot': 'assets/images/brandimages/peugeot.png',
    "Pagani": 'assets/images/brandimages/pagani.png',
    'Porsche': 'assets/images/brandimages/porsche.png',
    'Polestar': 'assets/images/brandimages/Polester.png',
    "Ram": 'assets/images/brandimages/ram.png',
    'Renault': 'assets/images/brandimages/renault.png',
    'Rolls-Royce': 'assets/images/brandimages/rolls royce..png',
    'Saab': 'assets/images/brandimages/saab.png',
    'Seat': 'assets/images/brandimages/seat.png',
    'Skoda': 'assets/images/brandimages/skoda.png',
    'Smart': 'assets/images/brandimages/smart.png',
    'SsangYong': 'assets/images/brandimages/ssangyong.png',
    'Subaru': 'assets/images/brandimages/subaru.png',
    'Suzuki': 'assets/images/brandimages/suzuki.png',
    'Tesla': 'assets/images/brandimages/tesla.png',
    'Toyota': 'assets/images/brandimages/toyota.png',
    "Tata motors": 'assets/images/brandimages/tata motors.png',
    'Volkswagen': 'assets/images/brandimages/volkswagen.png',
    'Volvo': 'assets/images/brandimages/volvo.png',
    'Vauxhall': 'assets/images/brandimages/vauxhall.png',
    'Wiesmann': 'assets/images/brandimages/wiesmann.png',
    "Geely" : 'assets/images/brandimages/geely.png',
    "Greatwall" : 'assets/images/brandimages/great_wall_motors.png',
    "Haval" : 'assets/images/brandimages/haval.png',
    'GAC Motors' : 'assets/images/brandimages/gac_motors.png',
    "MG Motor" : 'assets/images/brandimages/mg.png',
    "Nio" : 'assets/images/brandimages/nio.png',
    "Wuling" : 'assets/images/brandimages/wuling.png',
    "Zotye" : 'assets/images/brandimages/zotye.png',
    "Changan" : 'assets/images/brandimages/changan.png',
    "Chery" : 'assets/images/brandimages/chery.png',
    "Dongfeng" : 'assets/images/brandimages/dongfeng.png',
    "Faw" : 'assets/images/brandimages/faw.png', 
  };

  String? _getBrandImagePath(String brand) {
    return testBrands[brand];
  }

  @override
  Widget build(BuildContext context) {
    // Use only the test brands for now
    final brands = testBrands.keys.toList()..sort();
    
    return Scaffold(
      appBar: AnimatedSearchAppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          final imagePath = testBrands[brand];  // Get path directly from testBrands
          
          // Skip if we don't have an image path (shouldn't happen with our test brands)
          if (imagePath == null) return const SizedBox.shrink();
          
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
