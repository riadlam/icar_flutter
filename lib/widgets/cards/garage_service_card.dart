import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/models/garage_service.dart';

class GarageServiceCard extends StatelessWidget {
  final GarageService service;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onEditPressed;


  const GarageServiceCard({
    Key? key,
    required this.service,
    this.onTap,
    this.onFavoritePressed,
    this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 200,
        child: Row(
          children: [
            // Left: Info Section
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFdeebd9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service.ownerName.isNotEmpty
                          ? service.ownerName.toUpperCase()
                          : service.businessName.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF245124),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.phone, service.phoneNumber),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.location_on, service.location),
                  ],
                ),
              ),
            ),

            // Right: Yellow Background with Floating Elements
            Expanded(
              flex: 1,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Yellow Background
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFD59500),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    alignment: Alignment.center,
                  ),

                  // Floating left yellow bubble
                  Positioned(
                    left: -40,
                    child: Container(
                      width: 50,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD59500),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  // Floating iCar bottom container
                  Positioned(
                    bottom: 0,
                    left: -10,
                    right: 40,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFdeebd9),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "iCar",
                        style: TextStyle(
                          color: Color(0XFF245124),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),

                  // Car Icon (Top Right)
                  Positioned(
                    right: 30,
                    top: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.car_rental,
                        size: 90,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Favorite button
                  if (onFavoritePressed != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onFavoritePressed,
                        child: Icon(
                          service.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                  // Edit button
                  if (onEditPressed != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: GestureDetector(
                        onTap: onEditPressed,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF245124),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF245124)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
