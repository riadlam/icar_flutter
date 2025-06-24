import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';
import 'package:icar_instagram_ui/models/spare_parts_post.dart';
import 'package:icar_instagram_ui/providers/spare_parts_posts_provider.dart';
import 'package:icar_instagram_ui/services/ui/bottom_sheet_service.dart' as bottom_sheet_service;
import 'package:icar_instagram_ui/services/api/service_locator.dart';

class SparePartsPostsGrid extends ConsumerWidget {
  const SparePartsPostsGrid({Key? key}) : super(key: key);

  Future<void> _showEditBottomSheet(SparePartsPost post, BuildContext context, WidgetRef ref) async {
    print('Opening bottom sheet for post: ${post.id}');
    try {
      await bottom_sheet_service.BottomSheetService.showEditPostBottomSheet(
        context: context,
        post: post,
        onSave: (updatedPost) async {
          if (!context.mounted) return;
          
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final refresh = ref.read(sparePartsRefreshProvider);
          
          try {
            // Show loading indicator
            final success = await serviceLocator.sparePartsService.updateSparePartsPost(
              postId: updatedPost.id,
              brand: updatedPost.brand,
              model: updatedPost.model,
              sparePartsCategory: updatedPost.sparePartsCategory,
              sparePartsSubcategory: updatedPost.sparePartsSubcategory,
            );
            
            if (success) {
              // Refresh the posts list
              await refresh.refresh();
              
              if (context.mounted) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Post updated successfully')),
                );
                // The bottom sheet will be automatically closed after this callback
              }
            } else {
              if (context.mounted) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Failed to update post')),
                );
              }
            }
          } catch (e) {
            if (context.mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('Error updating post: ${e.toString()}')),
              );
            }
            print('Error updating post: $e');
          }
        },
        onDelete: () async {
          try {
            // Show a confirmation dialog
            final shouldDelete = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Post'),
                content: const Text('Are you sure you want to delete this post?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ) ?? false;

            if (shouldDelete && context.mounted) {
              // Show loading indicator
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              
              // Get the refresh function from the provider
              final refresh = ref.read(sparePartsRefreshProvider);
              
              // Call the delete API
              final success = await serviceLocator.sparePartsService.deleteSparePartsPost(post.id);
              
              if (success) {
                // Refresh the posts list
                await refresh.refresh();
                
                if (context.mounted) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Post deleted successfully')),
                  );
                  navigator.pop(); // Close the bottom sheet
                }
              } else {
                if (context.mounted) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Failed to delete post')),
                  );
                }
              }
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error deleting post: ${e.toString()}')),
              );
            }
            print('Error deleting post: $e');
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
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final postsAsync = ref.watch(sparePartsPostsProvider(selectedCategory));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Posts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF245124),
                ),
              ),
              // Category filter dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.loginbg),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text('Categories'),
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.loginbg),
                    elevation: 16,
                    style: const TextStyle(color: AppColors.loginbg, fontSize: 14),
                    onChanged: (String? newValue) {
                      ref.read(selectedCategoryProvider.notifier).state = newValue;
                    },
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...FilterConstants.sparePartsCategories.map<DropdownMenuItem<String>>((category) {
                        return DropdownMenuItem<String>(
                          value: category['name'],
                          child: Text(category['name'] ?? 'Unknown'),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        postsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            print('Error loading posts: $error');
            print('Stack trace: $stack');
            return Center(
              child: Text('Error loading posts: ${error.toString()}'),
            );
          },
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
                return _buildPostCard(context, post, ref);
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

  Widget _buildPostCard(BuildContext context, SparePartsPost post, WidgetRef ref) {
    print('Building post card for post: ${post.id}');
    // Get brand image path
    final brandImagePath = _getBrandImagePath(post.brand);
    
    // Get category image path (fallback if brand image not found)
    final category = post.sparePartsCategory.toLowerCase();
    String categoryImagePath = 'assets/images/spare_parts/placeholder.png';
    
    // Handle tap on post card
    void _handleTap() {
      print('Tapped on post: ${post.id}');
      _showEditBottomSheet(post, context, ref);
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
                        child: Icon(Icons.edit, 
                            size: brandLogoSize * 0.75,
                            color: AppColors.loginbg,
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
                                post.sparePartsSubcategory.length > 25
                                    ? post.sparePartsSubcategory.substring(0, 25) + '..'
                                    : post.sparePartsSubcategory,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.loginbg,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.visible, // use visible since you're managing overflow manually
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
