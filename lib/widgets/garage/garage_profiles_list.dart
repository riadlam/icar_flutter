import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/providers/garage_profiles_provider.dart';
import 'package:icar_instagram_ui/widgets/garage/garage_profile_card.dart';
import 'package:icar_instagram_ui/models/garage_profile.dart';

class GarageProfilesList extends ConsumerWidget {
  const GarageProfilesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🔄 Building GarageProfilesList...');
    
    // Watch for changes to the garage profiles
    final garageProfilesAsync = ref.watch(garageProfilesProvider);
    
    // Handle different states of the async operation
    return garageProfilesAsync.when(
      loading: _buildLoadingState,
      error: (error, stack) {
        debugPrint('❌ Error loading garage profiles: $error');
        debugPrint('Stack trace: $stack');
        return _buildErrorState(error, stack, ref);
      },
      data: (profiles) {
        debugPrint('✅ Loaded ${profiles.length} garage profiles');
        if (profiles.isNotEmpty) {
          debugPrint('First profile: ${profiles.first.businessName} (ID: ${profiles.first.id})');
        } else {
          debugPrint('No garage profiles found');
        }
        
        return RefreshIndicator(
          onRefresh: () {
            debugPrint('🔄 Refreshing garage profiles...');
            // Return the future from refresh to properly handle the refresh indicator
            return ref.refresh(garageProfilesProvider.future).catchError((e, stackTrace) {
              debugPrint('❌ Error during refresh: $e');
              debugPrint('Stack trace: $stackTrace');
              // Re-throw to show error in UI
              throw e;
            });
          },
          child: _buildProfilesList(profiles, ref),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Builder(
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 40.0,
                height: 40.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                'Loading Garage Profiles',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Fetching your garage information...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error, StackTrace stack, WidgetRef ref) {
    // Log the error for debugging
    debugPrint('❌ Garage Profiles Error: $error');
    debugPrint('Stack trace: $stack');
    
    // Extract a user-friendly error message
    String errorMessage = 'An unexpected error occurred';
    if (error.toString().contains('Exception:')) {
      errorMessage = error.toString().split('Exception:').last.trim();
    } else if (error.toString().isNotEmpty) {
      errorMessage = error.toString();
    }
    
    // Limit error message length for UI
    if (errorMessage.length > 120) {
      errorMessage = '${errorMessage.substring(0, 120)}...';
    }
    
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(ref.context).size.height * 0.5,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48.0,
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                'Unable to Load Garage Profiles',
                style: Theme.of(ref.context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'We encountered an issue while loading your garage profiles. Please check your internet connection and try again.',
                  style: Theme.of(ref.context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 32.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  errorMessage,
                  style: Theme.of(ref.context).textTheme.bodySmall?.copyWith(
                    color: Colors.red[700],
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    icon: const Icon(Icons.refresh, size: 20.0),
                    label: const Text('Try Again'),
                    onPressed: () => ref.refresh(garageProfilesProvider.future),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 14.0,
                      ),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.help_outline, size: 20.0),
                    label: const Text('Get Help'),
                    onPressed: () {
                      // TODO: Implement help/support functionality
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 14.0,
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build an error card
  Widget _buildErrorCard(String message) {
    return Builder(
      builder: (context) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilesList(List<GarageProfile> profiles, WidgetRef ref) {
    debugPrint('🔄 Building profiles list with ${profiles.length} items');
    
    return Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        debugPrint('📱 Context has valid size: ${mediaQuery.size}');
        
        // Calculate available height for the list
        final bottomPadding = mediaQuery.padding.bottom + 16.0;
        final topPadding = mediaQuery.padding.top + 16.0;
        if (profiles.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.garage_outlined,
                        size: 48.0,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'No Garage Profiles Found',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'You haven\'t added any garage profiles yet. Get started by adding your first garage profile to manage your services and information in one place.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    FilledButton.icon(
                      icon: const Icon(Icons.add, size: 20.0),
                      label: const Text('Add Garage Profile'),
                      onPressed: () {
                        // TODO: Implement add garage profile
                        debugPrint('Add Garage Profile button pressed');
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 14.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.help_outline, size: 18.0),
                      label: const Text('Learn More About Garage Profiles'),
                      onPressed: () {
                        // TODO: Show help/about dialog
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: 0,
            bottom: 70,
           
          ),
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            try {
              final profile = profiles[index];
              debugPrint('🔄 Building profile card for ${profile.businessName} (${profile.id})');
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GarageProfileCard(
                  key: ValueKey('garage_profile_${profile.id}_${profile.updatedAt.millisecondsSinceEpoch}'),
                  profile: profile,
                  onTap: () {
                    debugPrint('👆 Tapped on garage profile: ${profile.businessName} (${profile.id})');
                    // Update the selected profile in the provider
                    ref.read(selectedGarageProfileProvider.notifier).state = profile;
                    // TODO: Navigate to profile details or show bottom sheet
                  },
                ),
              );
            } catch (e, stackTrace) {
              debugPrint('❌ Error building profile card at index $index: $e');
              debugPrint('Stack trace: $stackTrace');
              return _buildErrorCard('Error displaying profile');
            }
          },
        );
      },
    );
  }
}
