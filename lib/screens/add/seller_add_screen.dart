import 'package:flutter/material.dart';

class SellerAddScreen extends StatelessWidget {
  const SellerAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Spare Part'),
      ),
      body: const Center(
        child: Text('Add Spare Part Form'),
      ),
    );
  }
}
