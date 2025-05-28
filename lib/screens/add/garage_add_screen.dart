import 'package:flutter/material.dart';

class GarageAddScreen extends StatelessWidget {
  const GarageAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Garage Service'),
      ),
      body: const Center(
        child: Text('Add Garage Service Form'),
      ),
    );
  }
}
