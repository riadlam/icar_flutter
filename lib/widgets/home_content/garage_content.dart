import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/models/garage_service.dart';
import 'package:icar_instagram_ui/widgets/cards/garage_service_card.dart';
import 'base_content_widget.dart';

class GarageContent extends BaseContentWidget {
  const GarageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: GarageService.sampleServices.length,
      itemBuilder: (context, index) {
        final service = GarageService.sampleServices[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GarageServiceCard(
            service: service,
            onTap: () {
              // TODO: Handle service tap
            },
            onFavoritePressed: () {
              // TODO: Handle favorite toggle
            },
          ),
        );
      },
    );
  }
}
