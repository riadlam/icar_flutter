import 'package:flutter/material.dart';
import 'base_content_widget.dart';

class SparePartsContent extends BaseContentWidget {
  const SparePartsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Spare parts\n(Coming Soon)',
        style: TextStyle(fontSize: 18, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
