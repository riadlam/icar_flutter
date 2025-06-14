import 'package:intl/intl.dart';

class FilterConstants {
  // Price range
  static const double minPrice = 0.0;
  static const double maxPrice = 100000.0;
  
  // Year range from 1960 to 2025
  static List<String> get years {
    return List.generate(66, (index) => (2025 - index).toString())
        .where((year) => int.parse(year) >= 1960)
        .toList();
  }
  
  // Mileage ranges
  static const List<String> mileageRanges = [
    '0-10,000 km',
    '10,001-30,000 km',
    '30,001-50,000 km',
    '50,001-80,000 km',
    '80,001-120,000 km',
    '120,000+ km',
  ];
  
static const List<String> garageCities = [
  'Adrar',
  'Chlef',
  'Laghouat',
  'Oum El Bouaghi',
  'Batna',
  'Béjaïa',
  'Biskra',
  'Béchar',
  'Blida',
  'Bouira',
  'Tamanrasset',
  'Tébessa',
  'Tlemcen',
  'Tiaret',
  'Tizi Ouzou',
  'Algiers',
  'Djelfa',
  'Jijel',
  'Sétif',
  'Saïda',
  'Skikda',
  'Sidi Bel Abbès',
  'Annaba',
  'Guelma',
  'Constantine',
  'Médéa',
  'Mostaganem',
  'M’Sila',
  'Mascara',
  'Ouargla',
  'Oran',
  'El Bayadh',
  'Illizi',
  'Bordj Bou Arréridj',
  'Boumerdès',
  'El Tarf',
  'Tindouf',
  'Tissemsilt',
  'El Oued',
  'Khenchela',
  'Souk Ahras',
  'Tipaza',
  'Mila',
  'Aïn Defla',
  'Naâma',
  'Aïn Témouchent',
  'Ghardaïa',
  'Relizane',
  'Timimoun',
  'Bordj Badji Mokhtar',
  'Ouled Djellal',
  'Béni Abbès',
  'In Salah',
  'In Guezzam',
  'Touggourt',
  'Djanet',
  'El Mghair',
  'El Meniaa',
];


  // Available services for garage filtering
  static const List<String> garageServices = [
    'Body Repair Technician',
    'Automotive Diagnostic',
    'Mechanic',
    'Tire Technician',
  ];

  // Price ranges in Algerian Dinar (DZD)
  static const List<String> priceRangesDZD = [
    '100,000 DZD',
    '200,000 DZD',
    '300,000 DZD',
    '400,000 DZD',
    '500,000 DZD',
    '600,000 DZD',
    '700,000 DZD',
    '800,000 DZD',
    '900,000 DZD',
    '1,000,000 DZD',
    '1,500,000 DZD',
    '2,000,000 DZD',
    '2,500,000 DZD',
    '3,000,000 DZD',
    '3,500,000 DZD',
    '4,000,000 DZD',
    '4,500,000 DZD',
    '5,000,000 DZD',
    '6,000,000 DZD',
    '7,000,000 DZD',
    '8,000,000 DZD',
    '9,000,000 DZD',
    '10,000,000 DZD',
    '10,000,000+ DZD'
  ];

  // Helper methods to convert between display and numeric values
  static int priceStringToInt(String priceStr) {
    final cleanStr = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanStr) ?? 0;
  }

  static String intToPriceString(int value) {
    if (value >= 10000000) return '10,000,000+ DZD';
    final formatter = NumberFormat('#,###');
    return '${formatter.format(value)} DZD';
  }
  


  // Get list of brands
  static List<String> get brands => brandModels.keys.toList();
  
  // Get models for a specific brand
  static List<String> getModelsForBrand(String brand) {
    return brandModels[brand] ?? [];
  }
  
  // Purchase types
  static const List<String> purchaseTypes = [
    'Buy',
    'Rent',
    'Lease',
  ];
  
  // Transmission types
  static const List<String> transmissions = [
    'Automatic',
    'Manual',
    'Semi-Automatic',
    'CVT',
    'Dual-Clutch',
  ];
  
  // Fuel types
  static const List<String> fuelTypes = [
    'Gasoline',
    'Diesel',
    'Electric',
    'Hybrid',
    'Plug-in Hybrid',
    'LPG',
    'CNG',
    'Hydrogen',
  ];
  
  // Car body types
  static const List<String> bodyTypes = [
    'Sedan',
    'SUV',
    'Truck',
    'Van',
    'Wagon',
    'Convertible',
    'Coupe',
    'Sports Car',
    'Hatchback',
    'Minivan',
    'Pickup',
    'Crossover',
    'Luxury',
    'Electric Vehicle',
  ];
  
  // Colors
  static const List<String> colors = [
    'White',
    'Black',
    'Silver',
    'Gray',
    'Red',
    'Blue',
    'Brown',
    'Green',
    'Beige',
    'Orange',
    'Gold',
    'Yellow',
    'Purple',
  ];
  
  // Number of doors
  static const List<String> doorCounts = [
    '2',
    '3',
    '4',
    '5+',
  ];
  
  // Number of seats
  static const List<String> seatCounts = [
    '2',
    '4',
    '5',
    '6',
    '7',
    '8+',
  ];
  
  // Drive types
  static const List<String> driveTypes = [
    'Front-Wheel Drive (FWD)',
    'Rear-Wheel Drive (RWD)',
    'All-Wheel Drive (AWD)',
    'Four-Wheel Drive (4WD)',
  ];
  
  // Engine sizes (in liters)
  static const List<String> engineSizes = [
    '1.0L',
    '1.2L',
    '1.4L',
    '1.6L',
    '1.8L',
    '2.0L',
    '2.2L',
    '2.4L',
    '2.5L',
    '3.0L',
    '3.5L',
    '4.0L',
    '5.0L',
    '5.7L',
    '6.0L+',
  ];
  
  // Features
  static const List<String> features = [
    'Air Conditioning',
    'Navigation System',
    'Bluetooth',
    'Backup Camera',
    'Leather Seats',
    'Sunroof/Moonroof',
    'Heated Seats',
    'Third Row Seating',
    'Alloy Wheels',
    'Keyless Entry',
    'Push Button Start',
    'Blind Spot Monitoring',
    'Lane Keeping Assist',
    'Adaptive Cruise Control',
    'Apple CarPlay',
    'Android Auto',
    'Premium Sound System',
    'Dual Zone A/C',
    'Panoramic Roof',
    'Towing Package',
  ];
}


// Car brands with their models
 const Map<String, List<String>> brandModels  = {
  'Abarth': [
    '1000 TC',
    '1000 TCR',
    '124 Spider',
    '131 Rally',
    '2000 Sport',
    '204 A',
    '205 Vignale Berlinetta',
    '2200 Coupe',
    '3000 Sport Prototipo',
    '500',
    '595',
    '695',
    '750',
    '750 Record Monza',
    '750 Zagato',
    'Grande Punto',
    'OT 1300',
    'OT 1600',
    'Punto Evo',
    'Ritmo 130 TC',
    'Simca 1300 GT',
    'Stilo',
    'Other',
  ],
  'Acura': [
    'ILX',
    'MDX',
    'NSX',
    'RDX',
    'RLX',
    'TLX',
    'TSX',
    'ZDX',
    'CL',
    'CSX (Canada only)',
    'EL (Canada only)',
    'Integra',
    'Legend',
    'RL',
    'RSX',
    'SLX',
    'TL',
    'Vigor',
    'Other',
  ],
  'Alfa Romeo': [
    '145',
    '146',
    '147',
    '155',
    '156',
    '159',
    '164',
    '166',
    '1750 Berlina',
    '1900',
    '2600',
    '33',
    '4C',
    '75',
    '8C Competizione',
    '90',
    'Alfasud',
    'Alfetta',
    'Brera',
    'Giulia',
    'Giulietta',
    'GT',
    'GTV',
    'GTV6',
    'MiTo',
    'Montreal',
    'RZ (Roadster Zagato)',
    'Spider',
    'Stelvio',
    'SZ (Sprint Zagato)',
    'Tonale',
    'Other',
  ],
  'Aston Martin': [
    'AMR21 (Formula One car)',
    'Bulldog',
    'Cygnet',
    'DB11',
    'DB2',
    'DB2/4',
    'DB3',
    'DB4',
    'DB5',
    'DB6',
    'DB7',
    'DB9',
    'DBX (SUV)',
    'DBS',
    'Lagonda',
    'Lagonda Taraf',
    'One-77',
    'Rapide',
    'Valhalla',
    'Valkyrie',
    'Vanquish',
    'Vantage',
    'V12 Speedster',
    'Virage',
    'Vulcan',
    'Other',
  ],
  'Audi': [
    'A1',
    'A1 Sportback',
    'A2',
    'A3',
    'A3 Allstreet',
    'A3 Berline',
    'A3 Cabriolet',
    'A3 Limousine',
    'A3 Sportback',
    'A3 TDI',
    'A4',
    'A4 Allroad',
    'A4 Avant',
    'A4 Cabriolet',
    'A4 Hybrid',
    'A5',
    'A5 Cabriolet',
    'A5 Sportback',
    'A6',
    'A6 Allroad',
    'A6 Avant',
    'A6 Plug-in Hybrid',
    'A6 Sedan',
    'A6 TDI',
    'A6 40 TDI',
    'A7',
    'A7 Allroad',
    'A7 Hybrid',
    'A7 Sportback',
    'A8',
    'A8 Hybrid',
    'A8 L',
    'A8 L W12',
    'A8 Sedan',
    'A8 TDI',
    'Q2',
    'Q3',
    'Q3 Sportback',
    'Q3 e-tron',
    'Q4',
    'Q4 e-tron',
    'Q5',
    'Q5 40 TFSI',
    'Q5 55 TFSI e',
    'Q5 Plug-in Hybrid',
    'Q5 Sportback',
    'Q5 TDI',
    'Q7',
    'Q7 60 TFSI e',
    'Q7 Plug-in Hybrid',
    'Q7 TDI',
    'Q7 e-tron',
    'Q8',
    'Q8 Plug-in Hybrid',
    'Q8 TDI',
    'Q8 e-tron',
    'R8',
    'R8 Spyder',
    'R8 V10',
    'R8 V10 Spyder',
    'RS Q3',
    'RS Q5',
    'RS Q7',
    'RS Q8',
    'RS3',
    'RS3 Sportback',
    'RS4',
    'RS4 Avant',
    'RS5',
    'RS5 Cabriolet',
    'RS5 Coupe',
    'RS5 Sportback',
    'RS6',
    'RS6 Avant',
    'RS6 Avant Plus',
    'RS7',
    'RS7 Sportback',
    'S1',
    'S3',
    'S3 Sportback',
    'S4',
    'S4 Avant',
    'S4 Sedan',
    'S5',
    'S5 Cabriolet',
    'S5 Sportback',
    'S6',
    'S6 Avant',
    'S6 Sedan',
    'S7',
    'S7 Sportback',
    'S8',
    'S8 Plus',
    'S8 Sedan',
    'SQ2',
    'SQ3',
    'SQ5',
    'SQ7',
    'SQ8',
    'TT',
    'TTS',
    'V8',
    'e-tron',
    'e-tron GT',
    '100',
    '200',
    '80',
    '90',
    'other',
  ],
  'Bentley': [
    'Azure',
    'Bentayga',
    'Brooklands',
    'Continental GT',
    'Flying Spur',
    'Mulsanne',
    'Other',
  ],
  'BMW': [
    '1 Series',
    '1 Series M',
    '2 Series',
    '2 Series M',
    '3 Series',
    '3 Series GT',
    '3 Series M',
    '4 Series',
    '4 Series Gran Coupe',
    '5 Series',
    '5 Series GT',
    '530d',
    '530e',
    '530i',
    '6 Series',
    '6 Series Gran Turismo',
    '7 Series',
    '7 Series LWB',
    '740Li',
    '740d',
    '740i',
    '745e',
    '8 Series',
    '8 Series Gran Coupe',
    'M1',
    'M2',
    'M240i',
    'M3',
    'M340i',
    'M4',
    'M440i',
    'M5',
    'M6',
    'M7',
    'M8',
    'X1',
    'X2',
    'X3',
    'X3 M',
    'X3 M40i',
    'X4',
    'X4 M',
    'X4 M40i',
    'X5',
    'X5 M',
    'X5 xDrive45e',
    'X6',
    'X6 M',
    'X7',
    'Z4',
    'Z8',
    'i3',
    'i4',
    'i4 M50',
    'i8',
    'iX',
    'iX3',
    'other',
  ],
  'Bugatti': [
    'Bolide',
    'Centodieci',
    'Chiron',
    'Divo',
    'Veyron',
    'Other',
  ],
  'Buick': [
    'Cascada',
    'Enclave',
    'Encore',
    'Encore GX',
    'Envision',
    'LaCrosse',
    'Regal',
    'Other',
  ],
  'BYD': [
    'Atto 3',
    'Dolphin',
    'E1',
    'E2',
    'E3',
    'E5',
    'E6',
    'e6',
    'F0',
    'F3',
    'F3 DM',
    'F3R',
    'F5',
    'F6',
    'F7',
    'G3',
    'G5',
    'G6',
    'Han',
    'L3',
    'M6',
    'Qin',
    'Qin Pro',
    'S6',
    'S7',
    'Song',
    'Song Max',
    'Song Pro',
    'Tang',
    'Yuan',
    'Yuan Pro',
    'other',
  ],
  'Cadillac': [
    'ATS',
    'CT4',
    'CT5',
    'CT6',
    'CTS',
    'ELR',
    'Escalade',
    'SRX',
    'XT4',
    'XT5',
    'XT6',
    'Other',
  ],
  'Chevrolet': [
    'Avalanche',
    'Aveo 4 doors',
    'Aveo 5 doors',
    'Blazer',
    'Blazer RS',
    'Bolt EV',
    'Bolt EUV',
    'Camaro',
    'Camaro LT',
    'Camaro SS',
    'Camaro ZL1',
    'Captiva',
    'Cobalt',
    'Colorado',
    'Colorado ZR2',
    'Corvette c1',
    'Corvette c2',
    'Corvette c3',
    'Corvette c4',
    'Corvette c5',
    'Corvette Stingray',
    'CMP',
    'Cruze',
    'Equinox',
    'Express',
    'Express 3500',
    'HHR',
    'Impala',
    'Impala LTZ',
    'Impala Premier',
    'Malibu',
    'Malibu Hybrid',
    'Malibu Premier',
    'Monte Carlo',
    'Optra',
    'Orlando',
    'Rezzo',
    'Sail 5 doors',
    'Silverado 1500',
    'Silverado 2500HD',
    'Silverado 3500HD',
    'Silverado 4500HD',
    'Silverado High Country',
    'Silverado Trail Boss',
    'Silverado Z71',
    'Sonic',
    'Sonic LTZ',
    'Sonic RS',
    'Spark',
    'Spark EV',
    'Suburban',
    'Suburban LTZ',
    'Suburban RST',
    'Tahoe',
    'Tahoe RST',
    'Traverse',
    'Traverse High Country',
    'Traverse RS',
    'Trax',
    'Volt',
    'Other',
  ],
  'Chrysler': [
    '200',
    '300',
    'Pacifica',
    'PT Cruiser',
    'Sebring',
    'Voyager',
    'Other',
  ],
  'Citroën': [
    '2CV',
    '3CV',
    'Aircross Concept',
    'Ami',
    'AX',
    'Berlingo',
    'Berlingo Multispace',
    'Berlingo XL',
    'BX',
    'C1',
    'C1 Airscape',
    'C2',
    'C3',
    'C3 Aircross',
    'C3 Cabrio',
    'C3 Comfort',
    'C3 Electric',
    'C3 Flair',
    'C3 GT Line',
    'C3 Picasso',
    'C3 Pluriel',
    'C3 PureTech',
    'C3 Red Edition',
    'C3 Shine',
    'C3 Supermini',
    'C3 Turbo',
    'C3 Urban Ride',
    'C3 WRC',
    'C4',
    'C4 Aircross',
    'C4 Aircross EV',
    'C4 BlueHDI',
    'C4 Cactus',
    'C4 Cactus 4x4',
    'C4 Cactus BlueHDi',
    'C4 Cactus Feel',
    'C4 Cactus Rip Curl',
    'C4 Cactus Shine',
    'C4 Cactus WRC',
    'C4 Cross',
    'C4 DS',
    'C4 E-HDi',
    'C4 Electric',
    'C4 Grand',
    'C4 Grand Picasso',
    'C4 Grand Picasso Flair',
    'C4 Grand Xperience',
    'C4 Piccadilly',
    'C4 Sedan',
    'C4 Spacetourer',
    'C4 WRC',
    'C5',
    'C5 Aircross',
    'C5 Aircross Hybrid',
    'C5 Break',
    'C5 CrossTourer',
    'C5 HDi',
    'C5 Hybrid',
    'C5 Hybrid4',
    'C5 Premium',
    'C5 Tourer',
    'C5 Tourer HDi',
    'C5 X',
    'C6',
    'C6 Hybrid',
    'C8',
    'C-Zero',
    'CX',
    'DS3',
    'DS3 Cabrio',
    'DS3 Cabrio Racing',
    'DS3 Racing',
    'DS3 WRC',
    'DS4',
    'DS4 Crossback',
    'DS5',
    'DS7 Crossback',
    'DS9',
    'Grand C4 Picasso',
    'Grand C4 Picasso 7-seat',
    'Jumper',
    'Jumper Van',
    'LNA',
    'Nemo',
    'Picasso',
    'Saxo',
    'Spacetourer',
    'Traction Avant',
    'Xantia',
    'Xsara',
    'Xsara Picasso',
    'Xsara VTS',
    'Other',
  ],
  'Cupra': [
    'Ateca',
    'Ateca Cupra',
    'Born',
    'Born e-Boost',
    'Cupra Ateca FR',
    'Cupra Ateca VZ',
    'Cupra Ateca VZ Edition',
    'Cupra Formentor VZ',
    'Cupra Formentor VZ Edition',
    'Cupra Formentor VZ Performance',
    'Cupra Formentor VZ4',
    'Cupra Formentor VZ5',
    'Cupra Formentor VZ5 Edition',
    'Cupra Formentor e-Hybrid',
    'Cupra Formentor TDI',
    'Cupra Formentor Concept',
    'Cupra Leon',
    'Cupra Leon 290',
    'Cupra Leon 300',
    'Cupra Leon Competición',
    'Cupra Leon Cupra',
    'Cupra Leon Estate',
    'Cupra Leon Sportstourer',
    'Cupra Leon TCR',
    'Cupra Leon VZ',
    'Cupra Leon VZ Edition',
    'Cupra R',
    'Cupra R ST',
    'Cupra R Variant',
    'Cupra Tavascan Concept',
    'Cupra UrbanRebel',
    'Formentor',
    'Formentor e-Hybrid',
    'Formentor TDI',
    'Formentor VZ',
    'Formentor VZ5',
    'Ibiza',
    'Ibiza Cupra',
    'Ibiza TDI',
    'Leon',
    'Leon Cupra',
    'Leon e-Hybrid',
    'Leon ST',
    'Leon TDI',
    'Leon VZ',
    'Leon X-Perience',
    'Tavascan',
    'Other',
  ],
  'Dacia': [
    'Duster',
    'Duster 4x4',
    'Duster Adventure',
    'Duster Black Edition',
    'Duster Classic',
    'Duster Hybrid',
    'Duster Outdoor',
    'Duster Prestige',
    'Duster Stepway',
    'Dokker',
    'Dokker Stepway',
    'Dokker Van',
    'Logan',
    'Logan Coupe',
    'Logan Estate',
    'Logan Facelift',
    'Logan MCV',
    'Logan Pickup',
    'Logan Van',
    'Lodgy',
    'Lodgy Stepway',
    'Lodgy Stepway 4x4',
    'Sandero',
    'Sandero 4x4',
    'Sandero Ambiance',
    'Sandero Comfort',
    'Sandero Extreme',
    'Sandero Expression',
    'Sandero RS',
    'Sandero Stepway',
    'Sandero Techroad',
    'Spring',
    'Spring Electric',
    'Spring SUV',
    'Solenza',
    'Other',
  ],
  'Daewoo': [
    'Kalos',
    'Lacetti',
    'Magnus',
    'Matiz',
    'Tosca',
    'Other',
  ],
  'Daihatsu': [
    'Copen',
    'Materia',
    'Mira',
    'Move',
    'Sirion',
    'Terios',
    'Other',
  ],
  'Datsun': [
    'GO',
    'GO+',
    'mi-Do',
    'on-Do',
    'Other',
  ],
  'Dodge': [
    'Avenger',
    'Caliber',
    'Caravan',
    'Challenger',
    'Challenger SRT',
    'Charger',
    'Charger SRT',
    'Dakota',
    'Dakota Sport',
    'Dart',
    'Dodge Demon',
    'Dodge Hornet',
    'Dodge Hornet EV',
    'Dodge Intrepid',
    'Dodge Ram Van',
    'Dodge Stealth',
    'Dodge Stratus',
    'Durango',
    'Durango SRT',
    'Grand Caravan',
    'Journey',
    'Magnum',
    'Neon',
    'Nitro',
    'Ram 1500',
    'Ram 2500',
    'Ram 3500',
    'Ram ProMaster',
    'Ram ProMaster City',
    'Ram Rebel',
    'Ram TRX',
    'SRT4',
    'SRT8',
    'Viper',
    'Other',
  ],
  'DS Automobiles': [
    'DS',
    'DS 3',
    'DS 3 Cabrio',
    'DS 3 Crossback',
    'DS 3 Dark Chrome',
    'DS 3 Dark Side',
    'DS 3 Performance',
    'DS 3 Performance Line',
    'DS 4',
    'DS 4 Crossback',
    'DS 4 Performance Line',
    'DS 4 Plug-in Hybrid',
    'DS 5',
    'DS 5 Hybrid4',
    'DS 5 Performance Line',
    'DS 7 Crossback',
    'DS 7 Crossback Bastille',
    'DS 7 Crossback Connected Chic',
    'DS 7 Crossback E-Tense',
    'DS 7 Crossback Performance Line',
    'DS 7 Crossback PureTech',
    'DS 7 Crossback Rivoli',
    'DS 7 Crossback Ultra Prestige',
    'DS 9',
    'DS 9 BlueHDI',
    'DS 9 Crossback',
    'DS 9 Executive Edition',
    'DS 9 Performance Line',
    'DS 9 Performance Line+',
    'DS Automobiles 7 Crossback',
    'DS E-Tense',
    'DS E-Tense 19',
    'DS E-Tense Performance Line',
    'DS Wild Rubis',
    'DS X E-Tense',
    'Other',
  ],
  'DFM': [
    'A9',
    'AX7',
    'C32',
    'CM7',
    'D01',
    'D02',
    'E11K',
    'E30',
    'E70',
    'F22',
    'F30',
    'Fengon 500',
    'Fengon 500',
    'Fengon 580',
    'Fengon iX5',
    'Fengon iX7',
    'Fengon Mini',
    'Fengon S560',
    'H30 Cross',
    'Jingyi S50',
    'L60',
    'M5',
    'NX',
    'Rich 6',
    'S30',
    'S50',
    'SX6',
    'T5',
    'T7',
    'Yixuan',
    'Other',
  ],
  'Ferrari': [
    '458 Italia',
    '488 GTB',
    '812 Superfast',
    'California',
    'F8 Tributo',
    'GTC4Lusso',
    'LaFerrari',
    'Portofino',
    'Roma',
    'SF90 Stradale',
    'Other',
  ],
  'Fiat': [
    '124 Spider',
    '125',
    '126',
    '127',
    '131',
    '500',
    '500C',
    '500E',
    '500L',
    '500L Lounge',
    '500L Trekking',
    '500X',
    '500X Cross',
    '500X Sport',
    '500X Urban',
    '600',
    'Barchetta',
    'Brava',
    'Bravo',
    'Cinquecento',
    'Coupe',
    'Croma',
    'Dino',
    'Doblo',
    'Doblo Cargo',
    'Doblo Trekking',
    'Ducato',
    'Fiorino',
    'Fiorino Combi',
    'Freemont',
    'Grande Punto',
    'Idea',
    'Linea',
    'Marea',
    'Multipla',
    'Panda',
    'Panda 4x4',
    'Panda Cross',
    'Panda Electric',
    'Panda TwinAir',
    'Punto',
    'Punto Abarth',
    'Punto Evo',
    'Qubo',
    'Tipo',
    'Tipo 5 Door',
    'Tipo Station Wagon',
    'Other',
  ],
  'Ford': [
    'Bronco',
    'EcoSport',
    'Escape',
    'Explorer',
    'F-150',
    'Fiesta',
    'Focus',
    'Fusion',
    'Mustang',
    'Ranger',
    'Taurus',
    'Transit',
    'Other',
  ],
  'Genesis': [
    'G70',
    'G80',
    'G90',
    'GV70',
    'GV80',
    'Other',
  ],
  'GMC': [
    'Acadia',
    'Canyon',
    'Hummer EV',
    'Sierra',
    'Terrain',
    'Yukon',
    'Other',
  ],
  'Honda': [
    'Accord',
    'Clarity',
    'Civic',
    'CR-V',
    'Fit',
    'HR-V',
    'Insight',
    'Odyssey',
    'Passport',
    'Pilot',
    'Other',
  ],
  'Hyundai': [
    'Accent',
    'Atos',
    'Azera',
    'Bayon',
    'Canyon',
    'Coupe',
    'Creta',
    'Elantra',
    'Elantra GT',
    'Elantra N',
    'Elantra Plug-in Hybrid',
    'Elantra Sedan',
    'Elantra Touring',
    'EON',
    'Equus',
    'Genesis',
    'Getz',
    'Ioniq',
    'i10',
    'i10 Plus',
    'i20',
    'i30',
    'i30CW',
    'i40',
    'i40SW',
    'i45',
    'i50',
    'i55',
    'Kona',
    'Kona Electric',
    'Kona Electric Ultimate',
    'Kona N',
    'KONA N Line',
    'Matrix',
    'New i20',
    'New i30',
    'New Sonata',
    'New Tucson',
    'Nexo',
    'Palisade',
    'Pony',
    'Santa Fe',
    'Santa Fe Hybrid',
    'Santa Fe Sport',
    'Santa Fe XL',
    'Sonata',
    'Sonata Hybrid',
    'Sonata N Line',
    'Sonata Plug-in Hybrid',
    'Sonata Sport',
    'Tiburon',
    'Tucson',
    'Tucson Hybrid',
    'Tucson N Line',
    'Tucson Plug-in Hybrid',
    'Tucson XRT',
    'Veloster',
    'Veloster N',
    'Other',
  ],
  'Infiniti': [
    'EX',
    'FX35',
    'FX37',
    'FX50',
    'G20',
    'G25',
    'G35',
    'G37',
    'I30',
    'I35',
    'J30',
    'JX35',
    'JX60',
    'M',
    'M35',
    'M37',
    'M45',
    'M56',
    'MM35h',
    'Q30',
    'Q50',
    'Q50 Red Sport 400',
    'Q60',
    'Q60 Red Sport 400',
    'Q70',
    'Q70L',
    'QX30',
    'QX50',
    'QX55',
    'QX56',
    'QX56 Limited',
    'QX60',
    'QX60 Hybrid',
    'QX60 Luxe',
    'QX70',
    'QX80',
    'QX80 Signature Edition',
    'Other',
  ],
  'Isuzu': [
    'Ascender',
    'D-Max',
    'MU-X',
    'Trooper',
    'Other',
  ],
  'Jaguar': [
    'E-Pace',
    'E-Type',
    'F-Pace',
    'F-Pace SVR',
    'F-Type',
    'F-Type 400 Sport',
    'F-Type Convertible',
    'F-Type Coupe',
    'F-Type R',
    'F-Type R-Dynamic',
    'F-Type SVR',
    'I-Pace',
    'I-Pace EV400',
    'XE',
    'XE R-Dynamic',
    'XF',
    'XF R-Dynamic',
    'XF Sportbrake',
    'XJ',
    'XJ L',
    'XJ220',
    'XJL',
    'XJS',
    'XK',
    'XK8',
    'XKR',
    'XKR-R',
    'XKR-S',
    'XKR-S GT',
    'X-Type',
    'X-Type Estate',
    'Other',
  ],
  'Jeep': [
    'Avenger',
    'Cherokee',
    'Cherokee KL',
    'Commander',
    'Commander (2022)',
    'Commander XK',
    'Compass',
    'Compass MK',
    'Gladiator',
    'Gladiator JT',
    'Grand Cherokee',
    'Grand Cherokee WK',
    'Grand Cherokee WK2',
    'Grand Cherokee WL',
    'Grand Wagoneer',
    'Grand Wagoneer WS',
    'Liberty',
    'Liberty KJ',
    'Liberty KK',
    'Patriot',
    'Patriot MK',
    'Renegade',
    'Renegade BU',
    'Wagoneer',
    'Wagoneer WS',
    'Wrangler',
    'Wrangler JK',
    'Wrangler JL',
    'Wrangler Unlimited',
    'Other',
  ],
  'Kia': [
    'Carnival',
    'Ceed',
    'Ceed GT',
    'Cerato',
    'Cerato Koup',
    'Cutback',
    'Forte',
    'Forte GT',
    'Forte Sedan',
    'K5',
    'K2500',
    'K2700',
    'Magentis',
    'Mohave',
    'Niro',
    'Niro EV',
    'Niro Hybrid',
    'Opirus',
    'Optima',
    'Optima Hybrid',
    'Picanto',
    'Proceed',
    'Rio',
    'Rondo',
    'Sephia',
    'Shuma',
    'Seltos',
    'Sorento',
    'Sorento Hybrid',
    'Soul',
    'Soul EV',
    'Soul GT',
    'Sportage',
    'Sportage Hybrid',
    'Stinger',
    'Stinger GT',
    'Stinger GT2',
    'Stonic',
    'Stonic GT-Line',
    'Xceed',
    'Other',
  ],
  'Koenigsegg': [
    'Agera',
    'CCX',
    'Gemera',
    'Jesko',
    'Regera',
    'Other',
  ],
  'Lamborghini': [
    'Aventador',
    'Gallardo',
    'Huracán',
    'Murciélago',
    'Revuelto',
    'Sian',
    'Urus',
    'Other',
  ],
  'Lancia': [
    'Delta',
    'Thema',
    'Voyager',
    'Ypsilon',
    'Other',
  ],
  'Land Rover': [
    '109',
    '110',
    '90',
    'Defender',
    'Defender 110',
    'Defender 90',
    'Discovery',
    'Discovery 3',
    'Discovery 4',
    'Discovery 5',
    'Discovery Sport',
    'Freelander',
    'Freelander 2',
    'Freelander 2 Sport',
    'Land Rover',
    'Range Rover',
    'Range Rover Classic',
    'Range Rover Evoque',
    'Range Rover LWB',
    'Range Rover PHEV',
    'Range Rover Sport',
    'Range Rover SVAutobiography',
    'Range Rover Velar',
    'Velar',
    'Other',
  ],
  'Lexus': [
    'ES',
    'GS',
    'IS',
    'LC',
    'LX',
    'LS',
    'NX',
    'RC',
    'RX',
    'UX',
    'LFA',
    'Other',
  ],
  'Lincoln': [
    'Aviator',
    'Continental',
    'Corsair',
    'MKC',
    'MKT',
    'MKZ',
    'Navigator',
    'Nautilus',
    'Other',
  ],
  'Lotus': [
    'Elise',
    'Emira',
    'Evija',
    'Evora',
    'Exige',
    'Other',
  ],
  'Mahindra': [
    'Bolero',
    'Scorpio',
    'Thar',
    'XUV300',
    'XUV500',
    'Other',
  ],
  'Maserati': [
    'Ghibli',
    'GranTurismo',
    'Levante',
    'MC20',
    'Quattroporte',
    'Other',
  ],
  'Mazda': [
    'CX-3',
    'CX-5',
    'CX-9',
    'CX-30',
    'Mazda3',
    'Mazda6',
    'MX-5 Miata',
    'RX-8',
    'Other',
  ],
  'McLaren': [
    '570S',
    '650S',
    '720S',
    'Artura',
    'GT',
    'MP4-12C',
    'P1',
    'Senna',
    'Other',
  ],
  'Mercedes-Benz': [
    'A Class',
    'A 45 AMG',
    'AMG A 45',
    'AMG C 63',
    'AMG C 63 S',
    'AMG E 63 S',
    'AMG GT',
    'AMG GT 4 Door Coupe',
    'AMG GT 63',
    'AMG GT 63 S',
    'AMG GT Black Series',
    'B Class',
    'B 250e',
    'B Class Electric Drive',
    'B Class Sports Tourer',
    'C Class',
    'C Class Cabriolet',
    'C Class Coupe',
    'C Class Estate',
    'C Class Sedan',
    'C Class C 300',
    'CLA',
    'CLA Coupe',
    'CLA Shooting Brake',
    'CLC',
    'CLK',
    'CLS',
    'CLS Coupe',
    'CLS Shooting Brake',
    'E Class',
    'E Class Cabriolet',
    'E Class Coupe',
    'E Class Estate',
    'E Class Sedan',
    'E Class E 350',
    'EQB',
    'EQB 300',
    'EQC',
    'EQC 400',
    'EQE',
    'EQE 350',
    'EQS',
    'EQS 580',
    'EQS SUV',
    'G Class',
    'G Class AMG',
    'G Class Cabriolet',
    'G Class G Wagon',
    'GLA',
    'GLA 250',
    'GLA 45 AMG',
    'GLA Coupe',
    'GLB',
    'GLB Coupe',
    'GLC',
    'GLC 300',
    'GLC 350e',
    'GLC 63',
    'GLC 63 S',
    'GLC Coupe',
    'GLC F Cell',
    'GLE',
    'GLE 63',
    'GLE 63 S',
    'GLE Coupe',
    'GLE Sedan',
    'GLK',
    'GLS',
    'GLS Coupe',
    'GLS Maybach',
    'M Class',
    'M Class Coupe',
    'Maybach 57',
    'Maybach 62',
    'Maybach S Class',
    'Metris',
    'ML',
    'R Class',
    'S Class',
    'S Class Cabriolet',
    'S Class Coupe',
    'S Class Sedan',
    'S Class S 580',
    'S Class S 600',
    'S Class S 650',
    'SLC',
    'SLC Roadster',
    'SL Class',
    'SLK',
    'SL Roadster',
    'SLS AMG',
    'SLS AMG Roadster',
    'Smart EQ',
    'Smart ForFour',
    'Smart ForTwo',
    'Sprinter',
    'V Class',
    'V Class LWB',
    'V Class Marco Polo',
    'V Class RWD',
    'V Class Tourer',
    'Vito',
    'Vito Panel Van',
    'Vito Tourer',
    'Other',
  ],
  'MG (Morris Garages)': [
    'MG3',
    'MG5',
    'MG6',
    'MG HS',
    'MG Marvel R',
    'MG ZS',
    'Other',
  ],
  'Mini': [
    'Clubman',
    'Cooper',
    'Countryman',
    'Coupe',
    'Paceman',
    'Roadster',
    'Other',
  ],
  'Mitsubishi': [
    '3000GT',
    'ASX',
    'Colt',
    'Eclipse',
    'Eclipse Cross',
    'Galant',
    'Galant Fortis',
    'Grandis',
    'i-MiEV',
    'L200',
    'Lancer',
    'Lancer Evolution',
    'Lancer Evolution X',
    'Mirage',
    'Montero',
    'Montero Sport',
    'Outlander',
    'Outlander PHEV',
    'Outlander Sport',
    'Pajero',
    'Pajero Sport',
    'RVR',
    'Shogun',
    'Space Star',
    'Other',
  ],
  'Nissan': [
    '350Z',
    '370Z',
    '370Z Roadster',
    'Altima',
    'Altima Hybrid',
    'Almera',
    'Armada',
    'Bluebird',
    'Cabstar',
    'Cherry',
    'Civilian',
    'Cube',
    'Frontier',
    'Frontier Pro-4X',
    'GT-R',
    'GT-R Nismo',
    'Juke',
    'Juke Nismo',
    'Leaf',
    'Leaf Plus',
    'Maxima',
    'Micra',
    'Murano',
    'Murano Hybrid',
    'Navara',
    'NV1500',
    'NV200',
    'NV2500',
    'NV3500',
    'Pathfinder',
    'Pathfinder Hybrid',
    'Patrol',
    'Pickup',
    'Pixo',
    'Primera',
    'Qashqai',
    'Qashqai Nismo',
    'Quest',
    'Rogue',
    'Rogue Hybrid',
    'Rogue Sport',
    'Sentra',
    'Serena',
    'Skyline',
    'Sunny',
    'Terrano',
    'Titan',
    'Titan XD',
    'Versa',
    'Versa Note',
    'X-Trail',
    'Xterra',
    'Other',
  ],
  'Opel': [
    'Adam',
    'Agila',
    'Ampera',
    'Ampera-e',
    'Antara',
    'Astra',
    'Cascada',
    'Combo',
    'Corsa',
    'Crossland X',
    'Grandland X',
    'Insignia',
    'Karl',
    'Meriva',
    'Mokka',
    'Movano',
    'Signum',
    'Speedster',
    'Tigra',
    'Vectra',
    'Vivaro',
    'Zafira',
    'other',
  ],
  'Pagani': [
    'Huayra',
    'Utopia',
    'Zonda',
    'Other',
  ],
  'Peugeot': [
    '1007',
    '108',
    '2008',
    '2008 GT',
    '2008 GT Line',
    '206',
    '207',
    '208',
    '208 Allure',
    '208 CC',
    '208 Electric',
    '208 GT',
    '208 GT Line',
    '208 GTi',
    '301',
    '306',
    '307',
    '308',
    '308 CC',
    '309',
    '3008',
    '3008 Allure',
    '3008 Crossway',
    '3008 GT',
    '3008 GT Line',
    '3008 Hybrid',
    '3008 Hybrid4',
    '3008 PHEV',
    '3008 SW',
    '4007',
    '4008',
    '407',
    '407 SW',
    '408',
    '408 PHEV',
    '5008',
    '5008 GT',
    '5008 GT Line',
    '5008 Hybrid',
    '5008 Hybrid4',
    '5008 PHEV',
    '508',
    '508 GT',
    '508 GT Line',
    '508 Hybrid',
    '508 Hybrid4',
    '508 RXH',
    '508 SW',
    'Bipper',
    'Boxer',
    'Expert',
    'Expert Tepee',
    'Landtrek',
    'Partner',
    'Partner Tepee',
    'RCZ',
    'Rifter',
    'Traveller',
    'Other',
  ],
  'Polestar': [
    'Polestar 1',
    'Polestar 2',
    'Polestar 3',
    'Other',
  ],
  'Porsche': [
    '911',
    '911 Cabriolet',
    '911 Sport Classic',
    '918 Spyder',
    '944',
    '968',
    'Boxster',
    'Boxster Spyder',
    'Carrera GT',
    'Cayenne',
    'Cayman',
    'Macan',
    'Panamera',
    'Taycan',
    'Other',
  ],
  'Ram': [
    '1500',
    '2500',
    '3500',
    'ProMaster',
    'ProMaster City',
    'Other',
  ],
  'Renault': [
    'Alaskan',
    'Arkana',
    'Captur',
    'Clio 1',
    'Clio 2',
    'Clio 3',
    'Clio 4',
    'Clio 4 RS',
    'Clio 5',
    'Clio Campus',
    'Clio Classique',
    'Colorale',
    'Duster',
    'Espace',
    'Fluence',
    'Floride',
    'Grand Scénic',
    'Kadjar',
    'Kangoo',
    'Koleos',
    'Kwid',
    'Laguna',
    'Latitude',
    'Lodgy',
    'Logan',
    'Master',
    'Mégane',
    'Modus',
    'Safrane',
    'Sandero',
    'Scénic',
    'Symbol',
    'Talisman',
    'Trafic',
    'Triber',
    'Twingo',
    'Vel Satis',
    'Wind',
    'Zoe',
    'Other',
  ],
  'Rolls-Royce': [
    'Cullinan',
    'Dawn',
    'Ghost',
    'Phantom',
    'Spectre',
    'Wraith',
    'Other',
  ],
  'Saab': [
    '9-3',
    '9-4X',
    '9-5',
    '9-7X',
    'Other',
  ],
  'SEAT': [
    'Alhambra',
    'Altea',
    'Arona',
    'Arosa',
    'Ateca',
    'Born',
    'Córdoba',
    'Exeo',
    'Freetrack',
    'Ibiza',
    'Leon',
    'Malaga',
    'Marbella',
    'Mii',
    'Tarraco',
    'Toledo',
    'Other',
  ],
  'Skoda': [
    'Citigo',
    'Enyaq',
    'Fabia',
    'Favorite',
    'Felicia',
    'Kamiq',
    'Karoq',
    'Kodiaq',
    'Octavia',
    'Praktik',
    'Rapid',
    'Roomster',
    'Scala',
    'Superb',
    'Yeti',
    'Other',
  ],
  'Smart': [
    'Fortwo',
    'Forfour',
    'Roadster',
    'Other',
  ],
  'SsangYong': [
    'Korando',
    'Musso',
    'Rexton',
    'Rodius',
    'Tivoli',
    'XLV',
    'Other',
  ],
  'Subaru': [
    'Ascent',
    'BRZ',
    'Crosstrek',
    'Forester',
    'Impreza',
    'Legacy',
    'Outback',
    'WRX',
    'XV',
    'Other',
  ],
  'Suzuki': [
    'Across',
    'Alto',
    'Baleno',
    'Celerio',
    'Ciaz',
    'Ertiga',
    'Grand Vitara',
    'Ignis',
    'Jimny',
    'Kizashi',
    'Liana',
    'Maruti',
    'Samurai',
    'Splash',
    'SX4',
    'Swift',
    'Vitara',
    'Wagon R',
    'X90',
    'Other',
  ],
  'Tata Motors': [
    'Altroz',
    'Aria',
    'Harrier',
    'Hexa',
    'Nexon',
    'Punch',
    'Safari',
    'Tiago',
    'Tigor',
    'Other',
  ],
  'Tesla': [
    'Cybertruck',
    'Model 3',
    'Model S',
    'Model X',
    'Model Y',
    'Roadster',
    'Semi',
    'other',
  ],
  'Toyota': [
    '4Runner',
    '86',
    'Agya',
    'Alphard',
    'Auris',
    'Avalon',
    'Avenza',
    'Avensis',
    'Aygo',
    'bZ4X',
    'C-HR',
    'Camry',
    'Carina',
    'Celia',
    'Corolla',
    'Corolla GT',
    'Corolla Verso',
    'Crown',
    'Echo',
    'Etios',
    'FJ Cruiser',
    'Fortuner',
    'Fortune',
    'GR Supra',
    'GR Yaris',
    'GR86',
    'GT 86',
    'Highlander',
    'Hilux',
    'Innova',
    'Ist',
    'iQ',
    'Land Cruiser',
    'MR',
    'Mark X',
    'Matrix',
    'Mirai',
    'New Corolla',
    'Passo',
    'Previa',
    'Prius',
    'Prius',
    'Prado',
    'Proace',
    'Proace City',
    'RAV4',
    'Rush',
    'Runner',
    'Scion FR-S (as Toyota)',
    'Scion iA (as Toyota)',
    'Scion iM (as Toyota)',
    'Scion tC (as Toyota)',
    'Scion xB (as Toyota)',
    'Sequoia',
    'Sienna',
    'Sienta',
    'Starlet',
    'Supra',
    'Supra',
    'Tacoma',
    'Tundra',
    'Urban Cruiser',
    'Urban Cruiser',
    'Vellfire',
    'Venza',
    'Vios',
    'Yaris',
    'other',
  ],
  'Vauxhall': [
    'Adam',
    'Astra',
    'Corsa',
    'Crossland',
    'Grandland',
    'Insignia',
    'Mokka',
    'Viva',
    'Zafira',
    'other',
  ],
  'Volvo': [
    'C30',
    'C40',
    'S60',
    'S90',
    'V40',
    'V60',
    'V70',
    'V90',
    'XC40',
    'XC60',
    'XC90',
    'other',
  ],
  'Wiesmann': [
    'GT MF5',
    'Roadster MF4',
    'other',
  ],
  'Chery': [
    'A1',
    'A3',
    'A5',
    'Arrizo',
    'Bonus',
    'Cowin',
    'E5',
    'Fora',
    'Fulwin',
    'Karry',
    'QQ',
    'Rely',
    'Riich',
    'Tiggo',
    'X1',
    'X5',
    'Other',
  ],
  'Geely': [
    'Atlas',
    'Azkarra',
    'Binrui',
    'Binyue',
    'Borui',
    'Boyue',
    'CK',
    'Coolray',
    'Emgrand',
    'FY11',
    'GC9',
    'Geometry A',
    'Geometry C',
    'GS',
    'GX3 Pro',
    'GX7',
    'Haoyue',
    'Haoqing',
    'Icon',
    'Jiaji',
    'MK',
    'Monjaro',
    'Okavango',
    'Panda',
    'Preface',
    'Ray',
    'S5',
    'Starray',
    'SX11',
    'Tugella',
    'Vision',
    'Xingyue',
    'Yuanjing',
    'Other',
  ],
  'Great Wall Motors (GWM)': [
    'C30',
    'Florid',
    'H2',
    'H3',
    'H5',
    'H6',
    'H6 Coupe',
    'H9',
    'Hover',
    'M4',
    'M6',
    'New Florid',
    'ORA Black Cat',
    'ORA Funky Cat',
    'ORA Good Cat',
    'Pao',
    'Peri',
    'Poer',
    'P-Series',
    'Steed',
    'voleex c30',
    'Wingle',
    'Wingle 5',
    'Wingle 6',
    'Wingle 7',
    'X240',
    'other',
  ],
  'Haval': [
    'H6',
    'H9',
    'Jolion',
    'Big Dog',
    'M6',
    'Other',
  ],
  'JAC Motors': [
    'iEV7S',
    'iEV6E',
    'T8',
    'S4',
    'Other',
  ],
  'MG Motor': [
    'MG3',
    'MG5',
    'MG6',
    'MG ZS',
    'MG HS',
    'MG Marvel R',
    'Other',
  ],
  'NIO': [
    'ES6',
    'ES8',
    'EC6',
    'ET7',
    'ET5',
    'Other',
  ],
  'Volkswagen': [
    'Amarok',
    'Arteon',
    'Atlas',
    'Atlas Cross Sport',
    'Beetle',
    'Beetle Cabriolet',
    'Beetle Convertible',
    'Bora',
    'Caddy',
    'Caddy Life',
    'Caddy Maxi',
    'California',
    'Caravelle',
    'CC',
    'Coccinelle',
    'Crafter',
    'Crrado',
    'CrossFox',
    'CrossGolf',
    'CrossPolo',
    'CrossTouran',
    'Derby',
    'Eos',
    'Fox',
    'Golf 1',
    'Golf 2',
    'Golf 3',
    'Golf 4',
    'Golf 5',
    'Golf 6',
    'Golf 7',
    'Golf 8',
    'Golf Alltrack',
    'Golf Cabriolet',
    'Golf GTI',
    'Golf Plus',
    'Golf R',
    'Golf Sportsvan',
    'Golf SV',
    'Golf Variant',
    'ID.3',
    'ID.4',
    'ID.5',
    'Jetta',
    'Jetta Hybrid',
    'K70',
    'Karmann',
    'Lavida',
    'Lupo',
    'Multivan',
    'New Beetle',
    'Passat',
    'Passat Alltrack',
    'Passat CC',
    'Passat Variant',
    'Phideon',
    'Polo',
    'Polo 3',
    'Polo GTI',
    'Polo Sedan',
    'Polo Vivo',
    'Scirocco',
    'Sharan',
    'T-Cross',
    'T-Roc',
    'Tayron',
    'Tiguan',
    'Touran',
    'Transporter',
    'Up',
    'Vento',
    'other',
  ],
  'Wuling': [
    'Hongguang Mini EV',
    'Almaz',
    'Confero',
    'Cortez',
  ],
  'Zotye': [
    '2008',
    '3008',
    'Cargo',
    'Cloud 100',
    'Cloud 200',
    'Cloud 300',
    'E200',
    'E300',
    'Hunter',
    'M 300',
    'Nomad',
    'T300',
    'T500',
    'Z100',
    'Z200',
    'Z300',
    'Other',
  ],
  'Baojun': [
    '310',
    '510',
    '530',
    'E100',
    'E200',
    'Other',
  ],
  'Brilliance': [
    'H530',
    'V5',
    'V7',
    'Other',
  ],
  'Changan': [
    'CS75',
    'CS55',
    'Eado',
    'UNI-K',
    'UNI-T',
    'Other',
  ],
  'Dongfeng': [
    'AX7',
    'S30',
    'H30',
    'A9',
    'Other',
  ],
  'FAW': [
    'Besturn B50',
    'Besturn X80',
    'Hongqi H5',
    'Hongqi H7',
    'Other',
  ]
};