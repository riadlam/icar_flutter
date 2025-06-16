import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onTap;
  final double height;
  final double imageWidth;

  const CategoryCard({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.onTap,
    this.height = 100,
    this.imageWidth = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white, // Make the whole card white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              // Image on the left
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                child: Builder(
                builder: (context) {
                  try {
                    return Image.asset(
                      imagePath,
                      width: imageWidth,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Error loading image: $imagePath');
                        debugPrint('Error details: $error');
                        return Container(
                          width: imageWidth,
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
                              const SizedBox(height: 4),
                              Text(
                                'Image not found\n$imagePath',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } catch (e) {
                    debugPrint('Exception loading image: $e');
                    return Container(
                      width: imageWidth,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error_outline, size: 24, color: Colors.red),
                    );
                  }
                },
              ),
              ),
              // Text on the right
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
