import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/models/spare_parts_post.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart' as filter_constants;
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/brand_dropdown.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/model_dropdown.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/category_dropdown.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/subcategory_dropdown.dart';

class EditPostBottomSheet extends StatefulWidget {
  final SparePartsPost post;
  final Function(SparePartsPost) onSave;
  final Function() onDelete;

  const EditPostBottomSheet({
    Key? key,
    required this.post,
    required this.onSave,
    required this.onDelete,
  }) : super(key: key);

  @override
  _EditPostBottomSheetState createState() => _EditPostBottomSheetState();
}

class _EditPostBottomSheetState extends State<EditPostBottomSheet> {
  // State variables for dropdowns and toggle
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedCategory;
  String? _selectedSubcategory;
  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    // Initialize values from the post
    _selectedBrand = widget.post.brand;
    _selectedModel = widget.post.model;
    _selectedCategory = widget.post.sparePartsCategory;
    _selectedSubcategory = widget.post.sparePartsSubcategory;
    // Ensure isAvailable is properly set based on the post data
    _isAvailable = widget.post.isAvailable == true;
    
    if (kDebugMode) {
      print('EditPostBottomSheet - Initial isAvailable: $_isAvailable');
      print('Post data - isAvailable: ${widget.post.isAvailable}');
    }
  }

  // No need for dispose since we're not using controllers anymore
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16, top: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Edit Post',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            BrandDropdownField(
              value: _selectedBrand,
              onChanged: (value) {
                setState(() {
                  _selectedBrand = value;
                  _selectedModel = null; // Reset model when brand changes
                });
              },
            ),
            const SizedBox(height: 12),
            ModelDropdownField(
              brand: _selectedBrand,
              value: _selectedModel,
              onChanged: (value) {
                if (value != _selectedModel) {
                  setState(() {
                    _selectedModel = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            CategoryDropdownField(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _selectedSubcategory = null; // Reset subcategory when category changes
                });
              },
            ),
            const SizedBox(height: 12),
            SubcategoryDropdownField(
              category: _selectedCategory,
              value: _selectedSubcategory,
              onChanged: (value) {
                setState(() {
                  _selectedSubcategory = value;
                });
              },
            ),
            const SizedBox(height: 24),
            // Availability Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'availability'.tr(),
                  style: theme.textTheme.titleMedium,
                ),
                Row(
                  children: [
                    Text(
                      _isAvailable ? 'available'.tr() : 'not_available'.tr(),
                      style: TextStyle(
                        color: _isAvailable ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Delete' , style: TextStyle(color:Colors.white),),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Save Changes' , style: TextStyle(color:Colors.white),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Text field building method removed as we're using dropdowns now

  Future<void> _saveChanges() async {
    // Ensure all required fields are filled and the selected model is valid for the brand
    if (_selectedBrand == null || _selectedModel == null || 
        _selectedCategory == null || _selectedSubcategory == null) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please_fill_all_fields'.tr())),
        );
      }
      return;
    }

    // Verify the selected model exists in the brand's models
    try {
      final brandModels = filter_constants.brandModels[_selectedBrand] ?? [];
      if (!brandModels.contains(_selectedModel)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('please_select_valid_model'.tr())),
          );
        }
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error validating model: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_occurred_try_again'.tr())),
        );
      }
      return;
    }

    try {
      if (kDebugMode) {
        print('Sending update with is_available: ${_isAvailable ? 1 : 0}');
      }
      
      final success = await serviceLocator.sparePartsService.updateSparePartsPost(
        postId: widget.post.id,
        brand: _selectedBrand!,
        model: _selectedModel!,
        sparePartsCategory: _selectedCategory!,
        sparePartsSubcategory: _selectedSubcategory!,
        is_available: _isAvailable ? 1 : 0,
      );

      if (success) {
        if (mounted) {
          if (kDebugMode) {
            print('Update successful, creating updated post with isAvailable: $_isAvailable');
          }
          
          final updatedPost = SparePartsPost(
            id: widget.post.id,
            userId: widget.post.userId,
            brand: _selectedBrand!,
            model: _selectedModel!,
            sparePartsCategory: _selectedCategory!,
            sparePartsSubcategory: _selectedSubcategory!,
            isAvailable: _isAvailable, // Make sure this is set correctly
            createdAt: widget.post.createdAt,
            updatedAt: DateTime.now(),
          );
          
          widget.onSave(updatedPost);
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('update_failed_try_again'.tr())),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating post: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_occurred_try_again'.tr())),
        );
      }
    }
  }
}
