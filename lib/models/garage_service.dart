class GarageService {
  final String id;
  final String businessName;
  final String ownerName;
  final String phoneNumber;
  final String location;
  final String imageUrl;
  final bool isFavorite;
  final List<String> services; // e.g., ["Towing", "Flat Tire", "Jump Start"]
  final double rating;
  final int reviews;

  GarageService({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.phoneNumber,
    required this.location,
    required this.imageUrl,
    this.isFavorite = false,
    required this.services,
    this.rating = 0.0,
    this.reviews = 0,
  });

  // Sample data
  static List<GarageService> sampleServices = [
    GarageService(
      id: '1',
      businessName: 'City Auto Care',
      ownerName: 'Ahmed Hassan',
      phoneNumber: '(555) 123-4567',
      location: '123 Main St, Downtown',
      imageUrl: 'https://example.com/garage1.jpg',
      isFavorite: true,
      services: ["24/7 Towing", "Flat Tire", "Jump Start", "Lockout"],
      rating: 4.8,
      reviews: 124,
    ),
    GarageService(
      id: '2',
      businessName: 'Express Towing',
      ownerName: 'Mohamed Ali',
      phoneNumber: '(555) 987-6543',
      location: '456 Park Ave, Uptown',
      imageUrl: 'https://example.com/garage2.jpg',
      isFavorite: false,
      services: ["Heavy Duty Towing", "Recovery", "Long Distance"],
      rating: 4.6,
      reviews: 89,
    ),
    GarageService(
      id: '3',
      businessName: 'Pro Auto Services',
      ownerName: 'Omar Khalid',
      phoneNumber: '(555) 456-7890',
      location: '789 Oak St, Midtown',
      imageUrl: 'https://example.com/garage3.jpg',
      isFavorite: false,
      services: ["Emergency Towing", "Battery Service", "Fuel Delivery"],
      rating: 4.9,
      reviews: 156,
    ),
  ];
}
