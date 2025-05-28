import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/services/api/services/car_service.dart';

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
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _yearController = TextEditingController();
  final _mileageController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
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
      _nameController.text = widget.car!.name;
      _brandController.text = widget.car!.brand;
      _modelController.text = widget.car!.model;
      _priceController.text = widget.car!.price.toString();
      _yearController.text = widget.car!.year.toString();
      _mileageController.text = widget.car!.mileage.toString();
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
      _images.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final brand = _brandController.text.trim();
    final model = _modelController.text.trim();
    final price = double.tryParse(_priceController.text) ?? 0;
    final year = int.tryParse(_yearController.text) ?? DateTime.now().year;
    final mileage = int.tryParse(_mileageController.text) ?? 0;
    final description = _descriptionController.text.trim();

    if (_images.isEmpty && widget.car == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one image')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
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

      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create car: ${e.toString()}')),
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
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _descriptionController.dispose();
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
                onTap: _pickImage,
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
                  child: _images.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              'Add Photos (${_images.length}/10)',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            PageView.builder(
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      File(_images[index].path),
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
                                  '${_images.length}/10',
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
              _buildTextField(
                controller: _nameController, 
                label: 'Car Name', 
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _brandController,
                      label: 'Brand',
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _modelController,
                      label: 'Model',
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: 'Price',
                      keyboardType: TextInputType.number,
                      prefix: '\$',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _yearController,
                      label: 'Year',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
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
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        prefixText: prefix,
        suffixText: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
