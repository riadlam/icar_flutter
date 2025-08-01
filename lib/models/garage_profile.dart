import 'package:flutter/foundation.dart';

class GarageProfile {
  final int id;
  final int userId;
  final String businessName;
  final String mechanicName;
  final String mobile;
  final String city;
  final List<String>? services;
  final DateTime createdAt;
  final DateTime updatedAt;

  GarageProfile({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.mechanicName,
    required this.mobile,
    required this.city,
    this.services,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GarageProfile.fromJson(Map<String, dynamic> json) {
    try {
      // Handle both string and dynamic list types for services
      List<String>? parseServices(dynamic services) {
        if (services == null) return null;
        if (services is List) {
          return services.map((e) => e.toString()).toList();
        }
        return null;
      }

      // Helper to parse int from either String or int
      int parseInt(dynamic value) {
        if (value == null) return 0;
        if (value is int) return value;
        if (value is String) return int.tryParse(value) ?? 0;
        return 0;
      }

      // Handle nested user object if present
      final userData = json['user'] is Map<String, dynamic> ? json['user'] : null;
      final userIdFromUser = userData != null ? parseInt(userData['id']) : null;

      return GarageProfile(
        id: parseInt(json['id']),
        userId: userIdFromUser ?? parseInt(json['user_id']),
        businessName: (json['business_name'] as String?)?.trim() ?? 'No Business Name',
        mechanicName: (json['mechanic_name'] as String?)?.trim() ?? 'No Name',
        mobile: (json['mobile']?.toString() ?? 'N/A').trim(),
        city: (json['city'] as String?)?.trim() ?? 'No City',
        services: parseServices(json['services']),
        createdAt: json['created_at'] != null 
            ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing GarageProfile: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'business_name': businessName,
        'mechanic_name': mechanicName,
        'mobile': mobile,
        'city': city,
        'services': services,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  GarageProfile copyWith({
    int? id,
    int? userId,
    String? businessName,
    String? mechanicName,
    String? mobile,
    String? city,
    List<String>? services,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GarageProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      mechanicName: mechanicName ?? this.mechanicName,
      mobile: mobile ?? this.mobile,
      city: city ?? this.city,
      services: services ?? this.services,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
