import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/car_post.dart';
import '../models/garage_service.dart';
import '../models/tow_truck_service.dart';
import '../models/spare_parts_search_params.dart';

class ShareService {
  // Private constructor
  const ShareService._internal();
  
  // Factory constructor
  factory ShareService() => _instance;
  
  // Singleton instance
  static final ShareService _instance = ShareService._internal();
  
  // Static method to share a car post
  static final ShareService instance = ShareService._instance;
  static Future<void> shareCarPost(
    BuildContext context, 
    CarPost post, {
    String? imagePath,
  }) async {
    // Ensure we have a valid context
    if (!context.mounted) return;
    
    // Create a share text with car details
    final shareText = 'Check out this ${post.brand} ${post.model} ${post.year} for ${post.formattedPrice}\n\n';
    
    // Show a bottom sheet with sharing options
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Share this car',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              
              // Share options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    // First row of share options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareButton(
                          context: context,
                          icon: Icons.message_rounded,
                          label: 'Message',
                          onTap: () => Navigator.pop(context, {'type': 'message'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.email_rounded,
                          label: 'Email',
                          onTap: () => Navigator.pop(context, {'type': 'email'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.link_rounded,
                          label: 'Copy Link',
                          onTap: () => Navigator.pop(context, {'type': 'copy'}),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Second row of social options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareButton(
                          context: context,
                          icon: Icons.facebook,
                          label: 'Facebook',
                          iconColor: const Color(0xFF1877F2),
                          onTap: () => Navigator.pop(context, {'type': 'facebook'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.chat_rounded, // Using chat icon as a replacement for WhatsApp
                          label: 'WhatsApp',
                          iconColor: const Color(0xFF25D366), // Fixed color format
                          onTap: () => Navigator.pop(context, {'type': 'whatsapp'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.photo_camera_back_rounded,
                          label: 'Instagram',
                          iconColor: const Color(0xFFE1306C),
                          onTap: () => Navigator.pop(context, {'type': 'instagram'}),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Cancel button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );

    if (result == null) return;

    final shareUrl = 'https://icar.com/cars/${post.id}';
    final fullShareText = '$shareText$shareUrl';

    switch (result['type']) {
      case 'message':
        await _shareViaSMS(fullShareText);
        break;
      case 'email':
        await _shareViaEmail(fullShareText, post);
        break;
      case 'copy':
        await Share.share(shareUrl);
        break;
      case 'facebook':
        await _shareViaFacebook(fullShareText);
        break;
      case 'whatsapp':
        await _shareViaWhatsApp(fullShareText);
        break;
      case 'instagram':
        await _shareViaInstagram(shareUrl);
        break;
    }
  }

  static Widget _buildShareButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: (iconColor ?? Theme.of(context).primaryColor).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Removed _buildSocialButton as we're now using _buildShareButton for all buttons

  static Future<void> _shareViaSMS(String text) async {
    try {
      final uri = Uri(
        scheme: 'sms',
        queryParameters: {'body': text},
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await Share.share(text);
      }
    } catch (e) {
      await Share.share(text);
    }
  }

  static Future<void> _shareViaEmail(String text, dynamic post) async {
    try {
      String subject;
      
      if (post is CarPost) {
        subject = 'Check out this ${post.brand} ${post.model} ${post.year}';
      } else if (post is String) {
        subject = 'Check out $post';
      } else {
        subject = 'Check this out';
      }
      
      final uri = Uri(
        scheme: 'mailto',
        queryParameters: {
          'subject': subject,
          'body': text,
        },
      );
      final url = uri.toString().replaceAll('+', ' ');
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        await Share.share(text);
      }
    } catch (e) {
      debugPrint('Error sharing via email: $e');
      await Share.share(text);
    }
  }

  static Future<void> _shareViaFacebook(String text) async {
    try {
      final uri = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(text)}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await Share.share(text);
      }
    } catch (e) {
      await Share.share(text);
    }
  }

  static Future<void> _shareViaWhatsApp(String text) async {
    final url = Uri.https(
      'wa.me',
      '/',
      {'text': text},
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      await Share.share(text);
    }
  }

  static Future<void> _shareViaInstagram(String url) async {
    try {
      // Instagram doesn't support direct sharing of text via URL scheme
      // This will open the Instagram app or store
      final instagramUrl = 'https://www.instagram.com';
      
      if (await canLaunchUrl(Uri.parse(instagramUrl))) {
        await launchUrl(Uri.parse(instagramUrl));
      } else {
        // If Instagram app is not installed, open in browser
        final webUrl = 'https://www.instagram.com/?url=${Uri.encodeComponent(url)}';
        if (await canLaunchUrl(Uri.parse(webUrl))) {
          await launchUrl(Uri.parse(webUrl));
        } else {
          await Share.share(url);
        }
      }
    } catch (e) {
      debugPrint('Error sharing to Instagram: $e');
      // Fallback to default share
      await Share.share(url);
    }
  }

  // Share a garage profile
  static Future<void> shareTowTruckService(
    BuildContext context, 
    TowTruckService service, {
    String? imagePath,
  }) async {
    // Ensure we have a valid context
    if (!context.mounted) return;
    
    // Create a share text with tow truck service details
    final shareText = 'Check out ${service.businessName} - Professional towing service in ${service.location}\n\n';
    
    // Show a bottom sheet with sharing options
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Share this tow service',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              
              // Share options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    // First row of share options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareButton(
                          context: context,
                          icon: Icons.message_rounded,
                          label: 'Message',
                          onTap: () => Navigator.pop(context, {'type': 'message'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.email_rounded,
                          label: 'Email',
                          onTap: () => Navigator.pop(context, {'type': 'email'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.link_rounded,
                          label: 'Copy Link',
                          onTap: () => Navigator.pop(context, {'type': 'copy'}),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Second row of social options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareButton(
                          context: context,
                          icon: Icons.facebook,
                          label: 'Facebook',
                          iconColor: const Color(0xFF1877F2),
                          onTap: () => Navigator.pop(context, {'type': 'facebook'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.chat_rounded,
                          label: 'WhatsApp',
                          iconColor: const Color(0xFF25D366),
                          onTap: () => Navigator.pop(context, {'type': 'whatsapp'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.photo_camera_back_rounded,
                          label: 'Instagram',
                          iconColor: const Color(0xFFE1306C),
                          onTap: () => Navigator.pop(context, {'type': 'instagram'}),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Cancel button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result == null) return;

    final shareUrl = 'https://icar.com/tow-trucks/${service.id}';
    final fullShareText = '$shareText$shareUrl';

    switch (result['type']) {
      case 'message':
        await _shareViaSMS(fullShareText);
        break;
      case 'email':
        await _shareViaEmail(fullShareText, service.businessName);
        break;
      case 'copy':
        await Share.share(shareUrl);
        break;
      case 'facebook':
        await _shareViaFacebook(fullShareText);
        break;
      case 'whatsapp':
        await _shareViaWhatsApp(fullShareText);
        break;
      case 'instagram':
        await _shareViaInstagram(shareUrl);
        break;
    }
  }

  static Future<void> shareSparePartsProfile(
    BuildContext context, 
    SparePartsProfile profile, {
    String? imagePath,
  }) async {
    // Ensure we have a valid context
    if (!context.mounted) return;
    
    // Create a share text with spare parts details
    final shareText = 'Check out ${profile.storeName} - ${profile.storeName} in ${profile.city}\n\n';
    
    // Show a bottom sheet with sharing options
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Share this spare part',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              
              // Share options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    // First row of share options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareButton(
                          context: context,
                          icon: Icons.message_rounded,
                          label: 'Message',
                          onTap: () => Navigator.pop(context, {'type': 'message'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.email_rounded,
                          label: 'Email',
                          onTap: () => Navigator.pop(context, {'type': 'email'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.copy_rounded,
                          label: 'Copy Link',
                          onTap: () => Navigator.pop(context, {'type': 'copy'}),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Second row of share options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareButton(
                          context: context,
                          icon: Icons.facebook_rounded,
                          label: 'Facebook',
                          onTap: () => Navigator.pop(context, {'type': 'facebook'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.share,
                          label: 'WhatsApp',
                          onTap: () => Navigator.pop(context, {'type': 'whatsapp'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.photo_camera_back_rounded,
                          label: 'Instagram',
                          onTap: () => Navigator.pop(context, {'type': 'instagram'}),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );

    if (result == null) return;

    // Generate a share URL (this would be your actual URL in production)
    final shareUrl = 'https://icar.com/spare-parts/${Uri.encodeComponent(profile.storeName)}';
    final fullShareText = '$shareText$shareUrl';

    // Handle the selected share option
    switch (result['type']) {
      case 'message':
        await Share.share(fullShareText);
        break;
      case 'email':
        await _shareViaEmail(fullShareText, profile.storeName);
        break;
      case 'copy':
        await Share.share(shareUrl);
        break;
      case 'facebook':
        await _shareViaFacebook(fullShareText);
        break;
      case 'whatsapp':
        await _shareViaWhatsApp(fullShareText);
        break;
      case 'instagram':
        await _shareViaInstagram(shareUrl);
        break;
    }
  }

  static Future<void> shareGarageProfile(
    BuildContext context, 
    GarageService garage, {
    String? imagePath,
  }) async {
    // Ensure we have a valid context
    if (!context.mounted) return;
    
    // Create a share text with garage details
    final shareText = 'Check out ${garage.businessName} - ${garage.services.take(3).join(', ')}${garage.services.length > 3 ? '...' : ''}\n\n';
    
    // Show a bottom sheet with sharing options
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Share this garage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              
              // Share options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    // First row of share options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareButton(
                          context: context,
                          icon: Icons.message_rounded,
                          label: 'Message',
                          onTap: () => Navigator.pop(context, {'type': 'message'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.email_rounded,
                          label: 'Email',
                          onTap: () => Navigator.pop(context, {'type': 'email'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.link_rounded,
                          label: 'Copy Link',
                          onTap: () => Navigator.pop(context, {'type': 'copy'}),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Second row of social options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareButton(
                          context: context,
                          icon: Icons.facebook,
                          label: 'Facebook',
                          iconColor: const Color(0xFF1877F2),
                          onTap: () => Navigator.pop(context, {'type': 'facebook'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.chat_rounded,
                          label: 'WhatsApp',
                          iconColor: const Color(0xFF25D366),
                          onTap: () => Navigator.pop(context, {'type': 'whatsapp'}),
                        ),
                        _buildShareButton(
                          context: context,
                          icon: Icons.photo_camera_back_rounded,
                          label: 'Instagram',
                          iconColor: const Color(0xFFE1306C),
                          onTap: () => Navigator.pop(context, {'type': 'instagram'}),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Cancel button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result == null) return;

    final shareUrl = 'https://icar.com/garages/${garage.id}';
    final fullShareText = '$shareText$shareUrl';

    switch (result['type']) {
      case 'message':
        await _shareViaSMS(fullShareText);
        break;
      case 'email':
        await _shareViaEmail(fullShareText, garage.businessName);
        break;
      case 'copy':
        await Share.share(shareUrl);
        break;
      case 'facebook':
        await _shareViaFacebook(fullShareText);
        break;
      case 'whatsapp':
        await _shareViaWhatsApp(fullShareText);
        break;
      case 'instagram':
        await _shareViaInstagram(shareUrl);
        break;
    }
  }
}
