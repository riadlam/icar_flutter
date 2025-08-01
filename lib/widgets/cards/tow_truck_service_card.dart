import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/tow_truck_service.dart';
import 'package:icar_instagram_ui/providers/tow_truck_wishlist_provider.dart';
import 'package:icar_instagram_ui/services/share_service.dart' as share_service;
import 'package:url_launcher/url_launcher.dart';

class TowTruckServiceCard extends StatelessWidget {
  final TowTruckService service;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onEditPressed;
  final bool showFavoriteButton;

  const TowTruckServiceCard({
    Key? key,
    required this.service,
    this.onTap,
    this.onFavoritePressed,
    this.onEditPressed,
    this.showFavoriteButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 200,
      child: Row(
        children: [
          // Left: Info Section (greenish background)
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
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
                      service.businessName.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF2E7D32),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      Icons.phone,
                      service.phoneNumber,
                      onTap: () => _launchPhone(service.phoneNumber),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.location_on, service.location),
                  ],
                ),
              ),
            ),
          ),

          // Right: Yellow Background with floating "iCar" & Truck icon
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

                // Floating yellow container on top left
                Positioned(
                  left: -40,
                  child: Container(
                    width: 50,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD59500),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                      ),
                    ),
                  ),
                ),

                // Floating "iCar" container at bottom
                Positioned(
                  bottom: 0,
                  left: -10,
                  right: 40,
                  child: Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.only(
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

                // Floating Truck Icon (top right)
                Positioned(
                  right: 10,
                  top: 20,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/images/towtruck_icon.png',
                      width: 140,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Favorite button - top right corner
                if (showFavoriteButton)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer(
                      builder: (context, ref, _) {
                        final isInWishlist = ref
                            .watch(towTruckWishlistProvider)
                            .contains(service.id);
                        return IconButton(
                          icon: Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isInWishlist ? Colors.red : Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            if (onFavoritePressed != null) {
                              onFavoritePressed!();
                            } else {
                              ref
                                  .read(towTruckWishlistProvider.notifier)
                                  .toggleWishlist(service.id);
                            }
                          },
                        );
                      },
                    ),
                  ),

                // Share button - below favorite button
                if (showFavoriteButton)
                  Positioned(
                    bottom: 5,
                    left: 70,
                    right: 5,
                    child: GestureDetector(
                      onTap: () =>
                          share_service.ShareService.shareTowTruckService(
                              context, service),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/sharebutton.webp',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Edit button - Positioned over the entire container (top right corner)
                if (onEditPressed != null)
                  Positioned(
                    top: 8,
                    left: 30,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {VoidCallback? onTap}) {
    final row = Row(
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
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: row,
      );
    } else {
      return row;
    }
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // Optionally show an error
    }
  }
}
