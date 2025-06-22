import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/spare_parts_form_sheet.dart';

class SellerAddScreen extends StatefulWidget {
  const SellerAddScreen({super.key});

  @override
  State<SellerAddScreen> createState() => _SellerAddScreenState();
}

class _SellerAddScreenState extends State<SellerAddScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  void _showAddSparePartForm() {
    final context = _scaffoldKey.currentContext;
    if (context == null || !context.mounted) return;
    
    if (_isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait...')),
      );
      return;
    }
    
    SparePartsFormSheet.show(
      context,
      onSuccess: () {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Spare part listed successfully!')),
        );
      },
      onError: (error) {
        if (!mounted) return;
        log('Error adding spare part: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to list spare part: $error')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TowTruckNavBar(
        scaffoldKey: _scaffoldKey,
        title: 'iCar',
      ),
      endDrawer: TowTruckNavBar.buildDrawer(context),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
              ),
            )
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500, // Optional: limit width on wider screens
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: _showAddSparePartForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.loginbg,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'List a Spare Part',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Add other widgets here if needed
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
