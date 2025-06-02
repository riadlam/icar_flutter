import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'base_content_widget.dart';

class SparePartsContent extends BaseContentWidget {
  const SparePartsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'spare_parts_coming_soon'.tr(),
        style: TextStyle(fontSize: 18, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
