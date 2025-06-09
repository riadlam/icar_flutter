import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/services/api/services/car_service.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart' as filter_constants;

class CarFormSheet extends StatefulWidget {
  final CarPost? car;
  final VoidCallback? onSuccess;
  final Function(String)? onError;

  const CarFormSheet({
    Key? key,
    this.car,
    this.onSuccess,
    this.onError,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    CarPost? car,
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) {
    // If the widget was removed from the tree while the popup was on screen,
    // we can't show the dialog.
    if (!context.mounted) return Future.value();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CarFormSheet(
          car: car,
          onSuccess: onSuccess,
          onError: onError,
        ),
      ),
    );
  }

  @override
  State<CarFormSheet> createState() => _CarFormSheetState();
}

class _CarFormSheetState extends State<CarFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  
  // Dropdown state
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedYear;
  List<String> _availableModels = [];
  final List<String> _availableBrands = filter_constants.FilterConstants.brands;
  final List<String> _availableYears = filter_constants.FilterConstants.years;
  
  void _updateModelsForBrand(String? brand) {
    setState(() {
      _selectedBrand = brand;
      _availableModels = brand != null 
          ? filter_constants.FilterConstants.getModelsForBrand(brand)
          : [];
      _selectedModel = null; // Reset model when brand changes
    });
  }
  
  final _priceController = TextEditingController();
  final _yearController = TextEditingController();
  final _mileageController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  final List<String> _existingImageUrls = [];
  final List<String> _removedImageUrls = [];
  final CarService _carService = serviceLocator.carService;
  bool _isLoading = false;
  bool _isEnabled = true;
  String _listingType = 'sale'; // 'sale' or 'rent'
  String _transmission = 'automatic'; // 'automatic' or 'manual'
  String _fuelType = 'gasoline'; // 'gasoline', 'diesel', 'electric', 'hybrid'

  @override
  void initState() {
    super.initState();
    if (widget.car != null) {
      _selectedBrand = widget.car!.brand;
      _selectedModel = widget.car!.model;
      _brandController.text = widget.car!.brand;
      _modelController.text = widget.car!.model;
      _selectedYear = widget.car!.year.toString();
      if (widget.car!.brand.isNotEmpty) {
        _updateModelsForBrand(widget.car!.brand);
      }
      _priceController.text = widget.car!.price.toString();
      _yearController.text = widget.car!.year.toString();
      _mileageController.text = widget.car!.mileage.toString();
      _descriptionController.text = widget.car!.description;
      _isEnabled = widget.car!.enabled;
      _transmission = widget.car!.transmission.toLowerCase();
      _fuelType = widget.car!.fuel.toLowerCase();
      _listingType = widget.car!.type.toLowerCase();
      
      // Store existing image URLs
      if (widget.car!.imageUrls != null) {
        _existingImageUrls.addAll(widget.car!.imageUrls!);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        imageQuality: 85,
      );
      
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _images.addAll(pickedFiles);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick images')),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      if (index < _existingImageUrls.length) {
        // If removing an existing image, move it to removed list
        _removedImageUrls.add(_existingImageUrls.removeAt(index));
      } else {
        // If removing a new image, just remove it
        _images.removeAt(index - _existingImageUrls.length);
      }
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final brand = _selectedBrand ?? '';
    final model = _selectedModel ?? '';
    final price = double.tryParse(_priceController.text) ?? 0;
    final year = int.tryParse(_yearController.text) ?? DateTime.now().year;
    final mileage = int.tryParse(_mileageController.text) ?? 0;
    final description = _descriptionController.text.trim();

    // Check if we have at least one image
    if (_images.isEmpty && (widget.car == null || _existingImageUrls.isEmpty)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one image')),
        );
      }
      return;
    }
    
    // Convert XFile to File for upload
    final List<File> imageFiles = [];
    for (var image in _images) {
      imageFiles.add(File(image.path));
    }

    setState(() => _isLoading = true);

    try {
      if (widget.car != null) {
        // Update existing car
        final updates = {
          'type': _listingType, // Add the type field
          'brand': brand,
          'model': model,
          'price': price.toString(),
          'mileage': mileage.toString(),
          'year': year.toString(),
          'transmission': _transmission,
          'fuel': _fuelType,
          'description': description,
          'enabled': _isEnabled ? '1' : '0',
        };
        
        if (kDebugMode) {
          print('Updating car with type: ${_listingType}');
        }

        await _carService.updateCar(
          carId: widget.car!.id,
          updates: updates,
          newImages: imageFiles,
          removedImageUrls: _removedImageUrls,
        );
      } else {
        // Create new car
        // Convert XFile to File
        final List<File> imageFiles = [];
        for (var image in _images) {
          imageFiles.add(File(image.path));
        }

        await _carService.createCar(
          type: _listingType,
          brand: brand,
          model: model,
          price: price,
          mileage: mileage,
          year: year,
          transmission: _transmission,
          fuel: _fuelType,
          description: description,
          images: imageFiles,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = widget.car == null 
            ? 'Failed to create car: ${e.toString()}' 
            : 'Failed to update car: ${e.toString()}';
            
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        widget.onError?.call(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _brandController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _descriptionController.dispose();
    
    // Clear state variables
    _selectedBrand = null;
    _selectedModel = null;
    _selectedYear = null;
    _availableModels = [];
    _images.clear();
    _existingImageUrls.clear();
    _removedImageUrls.clear();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.car == null ? 'Add New Car' : 'Edit Car',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.car != null) // Only show enable/disable in edit mode
                    Row(
                      children: [
                        const Text('Enable', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Switch(
                          value: _isEnabled,
                          onChanged: (value) {
                            setState(() {
                              _isEnabled = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Listing Type
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'sale',
                      label: Text('For Sale'),
                    ),
                    ButtonSegment(
                      value: 'rent',
                      label: Text('For Rent'),
                    ),
                  ],
                  selected: {_listingType},
                  onSelectionChanged: (Set<String> selection) {
                    setState(() {
                      _listingType = selection.first;
                    });
                  },
                ),
              ),
              
              // Image Picker
              GestureDetector(
                onTap: _images.length + _existingImageUrls.length < 10 ? _pickImage : null,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: _images.isEmpty && _existingImageUrls.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              'Add Photos (${_images.length + _existingImageUrls.length}/10)',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            PageView.builder(
                              itemCount: _existingImageUrls.length + _images.length,
                              itemBuilder: (context, index) {
                                final isExisting = index < _existingImageUrls.length;
                                final imageIndex = isExisting ? index : index - _existingImageUrls.length;
                                
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    isExisting
                                        ? Image.network(
                                            _existingImageUrls[imageIndex],
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => 
                                              const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                          )
                                        : Image.file(
                                            File(_images[imageIndex].path),
                                            fit: BoxFit.cover,
                                          ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_images.length + _existingImageUrls.length}/10',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Form Fields

              Wrap(
  spacing: 16, // Space between the dropdowns horizontally
  runSpacing: 16, // Space when wrapping to a new line
  children: [
    SizedBox(
      width: MediaQuery.of(context).size.width >= 600
          ? (MediaQuery.of(context).size.width - 48) / 2 // For larger screens
          : double.infinity, // Full width on small screens
      child: DropdownButtonFormField<String>(
        value: _selectedBrand,
        decoration: const InputDecoration(
          labelText: 'Brand',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        hint: const Text('Select Brand'),
        items: _availableBrands.map((String brand) {
          return DropdownMenuItem<String>(
            value: brand,
            child: Text(brand),
          );
        }).toList(),
        onChanged: (String? newValue) {
          _updateModelsForBrand(newValue);
          _brandController.text = newValue ?? '';
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a brand';
          }
          return null;
        },
      ),
    ),
    SizedBox(
      width: MediaQuery.of(context).size.width >= 600
          ? (MediaQuery.of(context).size.width - 48) / 2
          : double.infinity,
      child: DropdownButtonFormField<String>(
        value: _selectedModel,
        decoration: const InputDecoration(
          labelText: 'Model',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        hint: const Text('Select Model'),
        items: _availableModels.map((String model) {
          return DropdownMenuItem<String>(
            value: model,
            child: Text(model),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedModel = newValue;
            _modelController.text = newValue ?? '';
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a model';
          }
          return null;
        },
        isExpanded: true,
        disabledHint: _selectedBrand == null 
            ? const Text('Select a brand first')
            : null,
      ),
    ),
  ],
),

              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  // Price Field
                  SizedBox(
                    width: MediaQuery.of(context).size.width >= 600
                        ? (MediaQuery.of(context).size.width - 64) / 3
                        : (MediaQuery.of(context).size.width - 32) / 2,
                    child: _buildTextField(
                      controller: _priceController,
                      label: 'Price',
                      keyboardType: TextInputType.number,
                      prefix: '\$',
                    ),
                  ),
                  
                  // Year Dropdown
                  SizedBox(
                    width: MediaQuery.of(context).size.width >= 600
                        ? (MediaQuery.of(context).size.width - 64) / 3
                        : (MediaQuery.of(context).size.width - 32) / 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedYear,
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      hint: const Text('Select Year'),
                      items: _availableYears.map((String year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedYear = newValue;
                          _yearController.text = newValue ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a year';
                        }
                        return null;
                      },
                      isExpanded: true,
                    ),
                  ),
                  
                  // Mileage Field
                  SizedBox(
                    width: MediaQuery.of(context).size.width >= 600
                        ? (MediaQuery.of(context).size.width - 64) / 3
                        : double.infinity,
                    child: _buildTextField(
                      controller: _mileageController,
                      label: 'Mileage',
                      keyboardType: TextInputType.number,
                      suffix: 'km',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Transmission and Fuel Type
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _transmission,
                      decoration: InputDecoration(
                        labelText: 'Transmission',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      items: ['automatic', 'manual'].map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type[0].toUpperCase() + type.substring(1)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _transmission = newValue;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _fuelType,
                      decoration: InputDecoration(
                        labelText: 'Fuel Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      items: ['gasoline', 'diesel', 'electric', 'hybrid'].map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type[0].toUpperCase() + type.substring(1)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _fuelType = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
                        widget.car == null ? 'List Car' : 'Save Changes',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    String? prefix,
    String? suffix,
  }) {
    // Skip year field as we'll handle it with a dropdown
    if (label.toLowerCase() == 'year') {
      return const SizedBox.shrink();
    }
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixText: prefix,
        suffixText: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (keyboardType == TextInputType.number) {
          // Check if it's a valid number
          final number = double.tryParse(value);
          if (number == null || number <= 0) {
            return 'Please enter a valid $label';
          }
          // Special validation for year field
          if (label.toLowerCase().contains('year')) {
            final currentYear = DateTime.now().year;
            if (number < 1886 || number > currentYear + 1) { // 1886 is when the first car was made
              return 'Please enter a year between 1886 and ${currentYear + 1}';
            }
          }
        }
        
        return null;
      },
    );
  }
}
