class TowTruckService {
  final String id;
  final String businessName;
  final String phoneNumber;
  final String location;
  final String email;
  final String imageUrl;
  final bool isFavorite;

  TowTruckService({
    required this.id,
    required this.businessName,
    required this.phoneNumber,
    required this.location,
    required this.email,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // Sample data
  static List<TowTruckService> sampleServices = [
    TowTruckService(
      id: '1',
      businessName: 'Speedy Towing',
      phoneNumber: '(555) 123-7890',
      location: '123 Main St, Downtown',
      email: 'khalid@speedytowing.com',
      imageUrl: 'https://example.com/tow1.jpg',
      isFavorite: true,
    ),
    TowTruckService(
      id: '2',
      businessName: 'City Tow Service',
      phoneNumber: '(555) 987-6543',
      location: '456 Park Ave, Uptown',
      email: 'omar@citytow.com',
      imageUrl: 'https://example.com/tow2.jpg',
      isFavorite: false,
    ),
    TowTruckService(
      id: '3',
      businessName: 'Express Recovery',
      phoneNumber: '(555) 456-1234',
      location: '789 Oak St, Midtown',
      email: 'ahmed@expressrecovery.com',
      imageUrl: 'https://example.com/tow3.jpg',
      isFavorite: false,
    ),
  ];
}
