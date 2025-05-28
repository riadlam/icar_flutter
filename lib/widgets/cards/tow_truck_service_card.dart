import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/models/tow_truck_service.dart';

class TowTruckServiceCard extends StatelessWidget {
  final TowTruckService service;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onEditPressed;

  const TowTruckServiceCard({
    Key? key,
    required this.service,
    this.onTap,
    this.onFavoritePressed,
    this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), // Light green background
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            height: 180,  // Height to accommodate additional info
            child: Row(
              children: [
                // Left side - Service Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          service.businessName.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2E7D32),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoRow(Icons.phone, service.phoneNumber),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.email, service.email),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.location_on, service.location),
                      ],
                    ),
                  ),
                ),
                
                // Right side - Action Buttons
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32), // Dark green
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(-2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Favorite button
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12, right: 12),
                          child: GestureDetector(
                            onTap: onFavoritePressed,
                            child: Icon(
                              service.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      // Truck icon
                      const Icon(
                        Icons.local_shipping,
                        size: 36,
                        color: Colors.white,
                      ),
                      // Call button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2E7D32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          label: const Text('iCar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Edit button - Positioned absolutely over the card
        if (onEditPressed != null)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onEditPressed,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
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
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF2E7D32)),
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
