import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SparePartsCard extends StatelessWidget {
  final String partName;
  final String? location;
  final String? imageUrl;
  final String? sellerName;
  final String? mobileNumber;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final bool showFavoriteButton;

  const SparePartsCard({
    Key? key,
    required this.partName,
    this.location,
    this.imageUrl,
    this.sellerName,
    this.mobileNumber,
    this.isFavorite = false,
    this.onTap,
    this.onFavoritePressed,
    this.showFavoriteButton = true,
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
                      partName.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF2E7D32),
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    if (sellerName != null) ...[
                      _buildInfoRow(Icons.person, sellerName!),
                      const SizedBox(height: 8),
                    ],
                    if (mobileNumber != null) ...[
                      _buildInfoRow(Icons.phone, mobileNumber!),
                      const SizedBox(height: 8),
                    ],
                    if (location != null) ...[
                      _buildInfoRow(Icons.location_on, location!),
                    ],
                  ],
                ),
              ),
            ),

            // Right: Yellow Background with Image and Buttons
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFD59500),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  // Part image or placeholder
                  Positioned.fill(
                    child: imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(),
                            ),
                          )
                        : _buildPlaceholderIcon(),
                  ),

                  // Floating iCar bottom container
                  Positioned(
                    bottom: 0,
                    left: -10,
                    right: 40,
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFFdeebd9),
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
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),

                  // Favorite button
                  if (showFavoriteButton && onFavoritePressed != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 30,
                        ),
                        onPressed: onFavoritePressed,
                      ),
                    ),

                  // Share button
                  if (showFavoriteButton)
                    Positioned(
                      bottom: 5,
                      left: 70,
                      right: 5,
                      child: GestureDetector(
                        onTap: () => _shareSparePart(partName, sellerName, imageUrl),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF245124)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderIcon() {
    return const Center(
      child: Icon(
        Icons.inventory_2_outlined,
        size: 60,
        color: Colors.black26,
      ),
    );
  }

  void _shareSparePart(String partName, String? sellerName, String? imageUrl) {
    final text = 'Check out this spare part: $partName' + 
                (sellerName != null ? ' from $sellerName' : '');
    Share.share(
      text,
      subject: 'Spare Part: $partName',
    );
  }
}