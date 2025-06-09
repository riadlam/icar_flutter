class TowTruckService {
  final String id;
  final String businessName;
  final String driverName;
  final String phoneNumber;
  final String location;
  final String imageUrl;
  final bool isFavorite;

  TowTruckService({
    required this.id,
    required this.businessName,
    required this.driverName,
    required this.phoneNumber,
    required this.location,
    required this.imageUrl,
    this.isFavorite = false,
  });

  TowTruckService copyWith({
    String? id,
    String? businessName,
    String? driverName,
    String? phoneNumber,
    String? location,
    String? email,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return TowTruckService(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      driverName: driverName ?? this.driverName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Sample data
  static List<TowTruckService> sampleServices = [
    TowTruckService(
      id: '1',
      businessName: 'Speedy Towing',
      driverName: 'Khalid Ahmed',
      phoneNumber: '(555) 123-7890',
      location: '123 Main St, Downtown',
      imageUrl: 'https://example.com/tow1.jpg',
      isFavorite: true,
    ),
    TowTruckService(
      id: '2',
      businessName: 'City Tow Service',
      driverName: 'Omar Mahmoud',
      phoneNumber: '(555) 987-6543',
      location: '456 Park Ave, Uptown',
      imageUrl: 'https://example.com/tow2.jpg',
      isFavorite: false,
    ),
    TowTruckService(
      id: '3',
      businessName: 'Express Recovery',
      driverName: 'Ahmed Samir',
      phoneNumber: '(555) 456-1234',
      location: '789 Oak St, Midtown',
      imageUrl: 'https://example.com/tow3.jpg',
      isFavorite: false,
    ),
  ];
}
