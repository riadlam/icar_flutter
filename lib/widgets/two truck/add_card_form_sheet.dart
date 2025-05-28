import 'package:flutter/material.dart';

class AddCardFormSheet extends StatefulWidget {
  final String? initialName;
  final String? initialCity;
  final String? initialPhone;
  final String? initialAdditionalPhone;
  final String? initialEmail;
  final Function(String, String, String, String?, String?)? onSubmit;

  const AddCardFormSheet({
    super.key,
    this.initialName = '',
    this.initialCity = '',
    this.initialPhone = '',
    this.initialAdditionalPhone = '',
    this.initialEmail = '',
    this.onSubmit,
  });

  @override
  State<AddCardFormSheet> createState() => _AddCardFormSheetState();
}

class _AddCardFormSheetState extends State<AddCardFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _phoneController;
  late final TextEditingController _additionalPhoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _cityController = TextEditingController(text: widget.initialCity);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _additionalPhoneController = TextEditingController(text: widget.initialAdditionalPhone);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _additionalPhoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _getButtonText() {
    return widget.initialName?.isNotEmpty == true ? 'Update' : 'Submit';
  }

  void _handleSubmit() {
    if (widget.onSubmit != null) {
      widget.onSubmit!(
        _nameController.text.trim(),
        _cityController.text.trim(),
        _phoneController.text.trim(),
        _additionalPhoneController.text.trim().isNotEmpty ? _additionalPhoneController.text.trim() : null,
        _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      );
    }
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4CAF50); // Material green 500
    final Color lightGreenBackground = primaryGreen.withOpacity(0.06); // subtle background

    final inputDecoration = (IconData icon, String hint) => InputDecoration(
          prefixIcon: Icon(icon, color: primaryGreen),
          hintText: hint,
          filled: true,
          fillColor: lightGreenBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        );

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.initialName?.isNotEmpty == true ? 'Edit Card Details' : 'Add Card Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: inputDecoration(Icons.person, 'Your Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: inputDecoration(Icons.location_city, 'City'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: inputDecoration(Icons.phone_android, 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _additionalPhoneController,
              decoration: inputDecoration(Icons.phone, 'Additional Phone Number (optional)'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: inputDecoration(Icons.email, 'Email Address (optional)'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _handleSubmit,
              child: Text(
                _getButtonText(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
