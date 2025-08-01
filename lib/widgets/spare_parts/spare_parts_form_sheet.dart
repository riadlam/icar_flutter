import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/providers/spare_parts_posts_provider.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/dropdown_fields.dart'
    as dropdown_fields;
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
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SparePartsFormSheet(
                onSuccess: onSuccess,
                onError: onError,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ConsumerState<SparePartsFormSheet> createState() =>
      _SparePartsFormSheetState();
}

class _SparePartsFormSheetState extends ConsumerState<SparePartsFormSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedCategory;
  String? _selectedSubcategory;
  final List<String> _selectedSubcategories = [];
  bool _isLoading = false;
  bool _isAvailable = true;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBrand == null ||
        _selectedModel == null ||
        _selectedCategory == null ||
        _selectedSubcategories.isEmpty) {
      widget.onError('please_fill_all_fields_subcategory'.tr());
      return;
    }

    setState(() => _isLoading = true);

    try {
      await serviceLocator.sparePartsService.createSparePartsPost(
        brand: _selectedBrand!,
        model: _selectedModel!,
        spare_parts_category: _selectedCategory!,
        spare_parts_subcategories: _selectedSubcategories,
        is_available: _isAvailable ? 1 : 0,
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
        dropdown_fields.SubcategoryDropdownField(
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
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'list_a_spare_part'.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
              dropdown_fields.BrandDropdownField(
                value: _selectedBrand,
                onChanged: (value) {
                  setState(() {
                    _selectedBrand = value;
                    _selectedModel = null; // Reset model when brand changes
                  });
                },
              ),
              const SizedBox(height: 16),
              dropdown_fields.ModelDropdownField(
                brand: _selectedBrand,
                value: _selectedModel,
                onChanged: (value) {
                  setState(() {
                    _selectedModel = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              dropdown_fields.CategoryDropdownField(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _selectedSubcategory =
                        null; // Reset subcategory when category changes
                    _selectedSubcategories.clear();
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSubcategoryField(),
              const SizedBox(height: 50),
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
                    : Text(
                        'create_spare_part_post'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
