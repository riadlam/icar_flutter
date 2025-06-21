import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/models/spare_parts_post.dart';
import 'package:icar_instagram_ui/providers/spare_parts_posts_provider.dart';
import 'package:icar_instagram_ui/services/ui/bottom_sheet_service.dart' as bottom_sheet_service;

class SparePartsPostsGrid extends ConsumerWidget {
  const SparePartsPostsGrid({Key? key}) : super(key: key);

  Future<void> _showEditBottomSheet(SparePartsPost post, BuildContext context) async {
    print('Opening bottom sheet for post: ${post.id}');
    try {
      await bottom_sheet_service.BottomSheetService.showEditPostBottomSheet(
        context: context,
        post: post,
        onSave: (updatedPost) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Changes saved successfully')),
            );
          }
        },
        onDelete: () {
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post deleted')),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      print('Error showing bottom sheet: $e');
      print('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error opening editor')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(sparePartsPostsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'My Posts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF245124),
            ),
          ),
        ),
        const SizedBox(height: 8),
        postsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading posts: $error'),
          ),
          data: (posts) {
            if (posts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('No posts available')),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _buildPostCard(context, post);
              },
            );
          },
        ),
      ],
    );
  }

  String _getBrandImagePath(String brand) {
    // Convert brand name to match the image file naming convention
    String formattedBrand = brand
        .replaceAll(' ', '_')
        .replaceAll('.', '')
        .replaceAll('/', '');
    
    // Check for specific brand name mappings if needed
    if (brand.toLowerCase() == 'bmw') return 'assets/images/brandimages/BMW.jpg';
    if (brand.toLowerCase() == 'audi') return 'assets/images/brandimages/audi.jpg';
    if (brand.toLowerCase() == 'mercedes') return 'assets/images/brandimages/Mercedes-Benz.PNG';
    
    // Default path for other brands
    return 'assets/images/brandimages/$formattedBrand.PNG';
  }

  Widget _buildPostCard(BuildContext context, SparePartsPost post) {
    print('Building post card for post: ${post.id}');
    // Get brand image path
    final brandImagePath = _getBrandImagePath(post.brand);
    
    // Get category image path (fallback if brand image not found)
    final category = post.sparePartsCategory.toLowerCase();
    String categoryImagePath = 'assets/images/spare_parts/placeholder.png';
    
    // Handle tap on post card
    void _handleTap() {
      print('Tapped on post: ${post.id}');
      _showEditBottomSheet(post, context);
    }
    
    if (category.contains('filter')) {
      categoryImagePath = 'assets/images/categoryImages/Filtre.png';
    } else if (category.contains('freinage') || category.contains('brake')) {
      categoryImagePath = 'assets/images/categoryImages/Freinage.png';
    } else if (category.contains('pneu') || category.contains('tire')) {
      categoryImagePath = 'assets/images/categoryImages/Pneus et produits associés.png';
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        final cardPadding = isSmallScreen ? 8.0 : 12.0;
        final imageHeight = isSmallScreen ? 120.0 : 150.0;
        final brandLogoSize = isSmallScreen ? 24.0 : 32.0;
        final detailSize = isSmallScreen ? 10.0 : 12.0;
        
        return GestureDetector(
          onTap: _handleTap,
          behavior: HitTestBehavior.opaque,
          child: Card(
            elevation: 2,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image with brand logo
                Stack(
                  children: [
                    // Category image as background
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        categoryImagePath,
                        width: double.infinity,
                        height: imageHeight,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported, size: 40),
                        ),
                      ),
                    ),
                    // Brand logo in the top-right corner
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          brandImagePath,
                          width: brandLogoSize,
                          height: brandLogoSize,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.edit, 
                            size: brandLogoSize * 0.75,
                            color: AppColors.loginbg,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Post details
                Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Brand
                      Text(
                        post.brand.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color:  AppColors.loginbg,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 2),
                      
                      // Model
                      Text(
                        post.model,
                        style: TextStyle(
                         fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color:  AppColors.loginbg,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 6),
                      
                      // Category
                      Container(
                  
                        child: Row(
                          children: [
                            Text(
                              post.sparePartsCategory,
                              style: TextStyle(
                               fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color:  AppColors.loginbg,
                              height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      if (post.sparePartsSubcategory.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        // Subcategory
                        Container(

                          child: Row(
                            children: [
                            
                              Text(
                                post.sparePartsSubcategory,
                                style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color:  AppColors.loginbg,
                                height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  // No dispose method needed as this widget doesn't have any controllers to clean up
}
