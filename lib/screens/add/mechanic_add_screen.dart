import 'package:flutter/material.dart';

class MechanicAddScreen extends StatelessWidget {
  const MechanicAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tow Truck Service'),
      ),
      body: const Center(
        child: Text('Add Tow Truck Service Form'),
      ),
    );
  }
}
