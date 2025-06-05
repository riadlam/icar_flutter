import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/models/garage_profile.dart';
import 'package:icar_instagram_ui/widgets/garage/garage_profile_card.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'base_content_widget.dart';

class GarageContent extends BaseContentWidget {
  const GarageContent({Key? key}) : super(key: key);

  Future<void> _refreshProfiles() async {
    // This will trigger a rebuild of the FutureBuilder
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshProfiles,
      child: FutureBuilder<List<GarageProfile>>(
        future: serviceLocator.garageService.getPublicGarageProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Failed to load garage profiles',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Refresh the widget
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final profiles = snapshot.data ?? [];

          if (profiles.isEmpty) {
            return const Center(
              child: Text('No garage profiles found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GarageProfileCard(
                  profile: profile,
                  onTap: () {
                    // Handle profile tap (e.g., navigate to details)
                  },
                  // Disable favorite and edit in public view
                  isFavorite: false,
                  showEditButton: false,
                  onFavoritePressed: null,
                  onEditPressed: null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
