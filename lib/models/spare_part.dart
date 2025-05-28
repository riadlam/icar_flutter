class SparePart {
  final String id;
  final String businessName;
  final String ownerName;
  final String phoneNumber;
  final String location;
  final String email;
  final String imageUrl;
  final bool isFavorite;

  SparePart({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.phoneNumber,
    required this.location,
    required this.email,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // Sample data
  static List<SparePart> sampleParts = [
    SparePart(
      id: '1',
      businessName: 'Auto Parts Emporium',
      ownerName: 'John Smith',
      phoneNumber: '(123) 456-7890',
      location: '123 Main St, New York, NY 10001',
      email: 'john.smith@autoparts.com',
      imageUrl: 'https://example.com/auto_parts.jpg',
      isFavorite: true,
    ),
    SparePart(
      id: '2',
      businessName: 'City Auto Supplies',
      ownerName: 'Sarah Johnson',
      phoneNumber: '(987) 654-3210',
      location: '456 Oak Ave, Los Angeles, CA 90001',
      email: 'sarah.j@cityauto.com',
      imageUrl: 'https://example.com/city_auto.jpg',
      isFavorite: false,
    ),
    SparePart(
      id: '3',
      businessName: 'Elite Car Parts',
      ownerName: 'Michael Brown',
      phoneNumber: '(555) 123-4567',
      location: '789 Pine St, Chicago, IL 60601',
      email: 'michael@eliteparts.com',
      imageUrl: 'https://example.com/elite_parts.jpg',
      isFavorite: false,
    ),
  ];
}
