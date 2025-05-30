import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icar_instagram_ui/models/car_post.dart';

class EditCarScreen extends StatefulWidget {
  final CarPost car;
  final Function(CarPost) onSave;

  const EditCarScreen({
    Key? key,
    required this.car,
    required this.onSave,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required CarPost car,
    required Function(CarPost) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: EditCarScreen(
          car: car,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _priceController;
  late TextEditingController _yearController;
  late TextEditingController _mileageController;
  late TextEditingController _descriptionController;
  late String _transmissionType;
  late String _fuelType;
  late bool _isForSale;
  
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.car.brand);
    _modelController = TextEditingController(text: widget.car.model);
    _priceController = TextEditingController(text: widget.car.price.toStringAsFixed(0));
    _yearController = TextEditingController(text: widget.car.year.toString());
    _mileageController = TextEditingController(text: widget.car.mileage.toString());
    _descriptionController = TextEditingController(text: widget.car.description);
    _transmissionType = widget.car.transmission;
    _fuelType = widget.car.fuel;
    // Set initial sale/rent state based on the car's type
    _isForSale = widget.car.type.toLowerCase() == 'sale';
    
    if (kDebugMode) {
      print('Initial car type: ${widget.car.type}, isForSale: $_isForSale');
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image')),
        );
      }
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_brandController.text.isEmpty || 
        _modelController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _yearController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      // In a real app, you would upload the image to a server here
      // For now, we'll just use the existing images if no new image was picked
      final List<String> updatedImages = _pickedImage != null 
          ? [_pickedImage!.path] 
          : widget.car.images;

      // Ensure type is sent as 'sale' or 'rent' exactly as expected by the API
      final String carType = _isForSale ? 'sale' : 'rent';
      
      if (kDebugMode) {
        print('Saving car with type: $carType');
      }
      
      final updatedCar = CarPost(
        id: widget.car.id,
        type: carType,
        brand: _brandController.text,
        model: _modelController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        mileage: int.tryParse(_mileageController.text) ?? widget.car.mileage,
        year: int.tryParse(_yearController.text) ?? widget.car.year,
        transmission: _transmissionType,
        fuel: _fuelType,
        description: _descriptionController.text,
        imageUrls: updatedImages,
        sellerId: widget.car.sellerId,
        sellerName: widget.car.sellerName,
        sellerPhone: widget.car.sellerPhone,
        createdAt: widget.car.createdAt,
        isFavorite: widget.car.isFavorite,
        isWishlisted: widget.car.isWishlisted,
        enabled: widget.car.enabled,
        updatedAt: DateTime.now(),
      );
      
      widget.onSave(updatedCar);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car details updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update car details')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Edit Car',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Car Image Picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        image: _pickedImage != null
                            ? DecorationImage(
                                image: FileImage(_pickedImage!),
                                fit: BoxFit.cover,
                              )
                            : (widget.car.images.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(widget.car.images.first),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to change image',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Form Fields
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Brand', _brandController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('Model', _modelController)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Year', _yearController, textInputType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('Mileage (km)', _mileageController, textInputType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField('Price', _priceController, textInputType: TextInputType.number, prefixText: '\$ '),
                  const SizedBox(height: 12),
                  _buildTextField('Description', _descriptionController, maxLines: 3),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _transmissionType,
                    decoration: InputDecoration(
                      labelText: 'Transmission',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: ['automatic', 'manual']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type[0].toUpperCase() + type.substring(1)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _transmissionType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _fuelType,
                    decoration: InputDecoration(
                      labelText: 'Fuel Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: ['gasoline', 'diesel', 'electric', 'hybrid', 'other']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type[0].toUpperCase() + type.substring(1)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _fuelType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('For Sale'),
                    subtitle: Text(_isForSale ? 'This car is for sale' : 'This car is for rent'),
                    value: _isForSale,
                    onChanged: (value) {
                      setState(() {
                        _isForSale = value;
                        if (kDebugMode) {
                          print('Car type changed to: ${_isForSale ? 'sale' : 'rent'}');
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Save Button
          ElevatedButton(
            onPressed: _isLoading ? null : _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save Changes',
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {
    TextInputType textInputType = TextInputType.text,
    String? prefixText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLines,
      minLines: 1,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixText: prefixText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        alignLabelWithHint: true,
      ),
    );
  }
}
