import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/models/tow_truck_service.dart';
import 'package:icar_instagram_ui/widgets/cards/tow_truck_service_card.dart';
import 'base_content_widget.dart';

class TowTruckContent extends BaseContentWidget {
  const TowTruckContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: TowTruckService.sampleServices.length,
      itemBuilder: (context, index) {
        final service = TowTruckService.sampleServices[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TowTruckServiceCard(
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
