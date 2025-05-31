class FavoriteSeller {
  final int id;
  final int sellerId;
  final String fullName;
  final String createdAt;

  FavoriteSeller({
    required this.id,
    required this.sellerId,
    required this.fullName,
    required this.createdAt,
  });

  factory FavoriteSeller.fromJson(Map<String, dynamic> json) {
    return FavoriteSeller(
      id: json['id'] as int,
      sellerId: json['seller_id'] as int,
      fullName: json['full_name'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
