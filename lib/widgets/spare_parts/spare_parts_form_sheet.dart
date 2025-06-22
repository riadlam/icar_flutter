import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/providers/spare_parts_posts_provider.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/brand_dropdown.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/model_dropdown.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/category_dropdown.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/subcategory_dropdown.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

class SparePartsFormSheet extends ConsumerStatefulWidget {
  final Function() onSuccess;
  final Function(String) onError;

  const SparePartsFormSheet({
    super.key,
    required this.onSuccess,
    required this.onError,
  });

  static void show(
    BuildContext context, {
    required Function() onSuccess,
    required Function(String) onError,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SparePartsFormSheet(
        onSuccess: onSuccess,
        onError: onError,
      ),
    );
  }

  @override
  ConsumerState<SparePartsFormSheet> createState() => _SparePartsFormSheetState();
}

class _SparePartsFormSheetState extends ConsumerState<SparePartsFormSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedCategory;
  String? _selectedSubcategory;
  final List<String> _selectedSubcategories = [];
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBrand == null || 
        _selectedModel == null || 
        _selectedCategory == null || 
        _selectedSubcategories.isEmpty) {
      widget.onError('Please fill in all fields and add at least one subcategory');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await serviceLocator.sparePartsService.createSparePartsPost(
        brand: _selectedBrand!,
        model: _selectedModel!,
        spare_parts_category: _selectedCategory!,
        spare_parts_subcategories: _selectedSubcategories,
      );
      
      if (!mounted) return;
      
      // If we get here, the post was successful
      // Get the refresh provider and refresh the posts list
      final refresh = ref.read(sparePartsRefreshProvider);
      await refresh.refresh();
      
      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        widget.onError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildSubcategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubcategoryDropdownField(
          category: _selectedCategory,
          value: _selectedSubcategory,
          onChanged: (value) {
            setState(() {
              _selectedSubcategory = value;
              if (value != null && !_selectedSubcategories.contains(value)) {
                _selectedSubcategories.add(value);
              }
            });
          },
        ),
        const SizedBox(height: 8),
        // Display selected subcategories as chips
        if (_selectedSubcategories.isNotEmpty)
          Wrap(
            spacing: 8.0,
            children: _selectedSubcategories.map((subcategory) {
              return Chip(
                label: Text(subcategory),
                onDeleted: () {
                  setState(() {
                    _selectedSubcategories.remove(subcategory);
                    if (_selectedSubcategory == subcategory) {
                      _selectedSubcategory = null;
                    }
                  });
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Add Spare Part',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BrandDropdownField(
                value: _selectedBrand,
                onChanged: (value) {
                  setState(() {
                    _selectedBrand = value;
                    _selectedModel = null; // Reset model when brand changes
                  });
                },
              ),
              const SizedBox(height: 16),
              ModelDropdownField(
                brand: _selectedBrand,
                value: _selectedModel,
                onChanged: (value) {
                  setState(() {
                    _selectedModel = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CategoryDropdownField(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  _selectedSubcategory = null;
                  _selectedSubcategories.clear(); // Reset subcategories when category changes
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSubcategoryField(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.loginbg,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Create Spare Part Post',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold , color:Colors.white),
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
