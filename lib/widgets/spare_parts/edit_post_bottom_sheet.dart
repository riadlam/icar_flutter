import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:icar_instagram_ui/models/spare_parts_post.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart' as filter_constants;
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
  // State variables for dropdowns
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedCategory;
  String? _selectedSubcategory;

  @override
  void initState() {
    super.initState();
    // Initialize dropdown values from the post
    _selectedBrand = widget.post.brand;
    _selectedModel = widget.post.model;
    _selectedCategory = widget.post.sparePartsCategory;
    _selectedSubcategory = widget.post.sparePartsSubcategory;
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

  void _saveChanges() {
    // Ensure all required fields are filled and the selected model is valid for the brand
    if (_selectedBrand == null || _selectedModel == null || 
        _selectedCategory == null || _selectedSubcategory == null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    
    // Verify the selected model exists in the brand's models
    try {
      final brandModels = filter_constants.brandModels[_selectedBrand] ?? [];
      if (!brandModels.contains(_selectedModel)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a valid model')),
        );
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error validating model: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
      return;
    }

    final updatedPost = SparePartsPost(
      id: widget.post.id,
      userId: widget.post.userId,
      brand: _selectedBrand!,
      model: _selectedModel!,
      sparePartsCategory: _selectedCategory!,
      sparePartsSubcategory: _selectedSubcategory!,
      createdAt: widget.post.createdAt,
      updatedAt: DateTime.now(),
    );
    
    widget.onSave(updatedPost);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
