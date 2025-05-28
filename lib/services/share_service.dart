import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/car_post.dart';

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
    // Use the navigator key if the context is no longer mounted
    final currentContext = context;
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: currentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Share via',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ShareService._buildShareButton(
                    context: context,
                    icon: Icons.message,
                    label: 'Message',
                    onTap: () => Navigator.pop(context, {'type': 'message'}),
                  ),
                  ShareService._buildShareButton(
                    context: context,
                    icon: Icons.mail_outline,
                    label: 'Email',
                    onTap: () => Navigator.pop(context, {'type': 'email'}),
                  ),
                  ShareService._buildShareButton(
                    context: context,
                    icon: Icons.copy,
                    label: 'Copy Link',
                    onTap: () => Navigator.pop(context, {'type': 'copy'}),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ShareService._buildSocialButton(
                    context: context,
                    icon: 'assets/images/facebook.png',
                    label: 'Facebook',
                    onTap: () => Navigator.pop(context, {'type': 'facebook'}),
                  ),
                  ShareService._buildSocialButton(
                    context: context,
                    icon: 'assets/images/whatsapp.png',
                    label: 'WhatsApp',
                    onTap: () => Navigator.pop(context, {'type': 'whatsapp'}),
                  ),
                  ShareService._buildSocialButton(
                    context: context,
                    icon: 'assets/images/instagram.png',
                    label: 'Instagram',
                    onTap: () => Navigator.pop(context, {'type': 'instagram'}),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );

    if (result == null) return;

    final shareUrl = 'https://yourapp.com/cars/${post.id}';
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
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  static Widget _buildSocialButton({
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              icon,
              width: 28,
              height: 28,
              errorBuilder: (_, __, ___) => const Icon(Icons.share),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

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

  static Future<void> _shareViaEmail(String text, CarPost post) async {
    try {
      final emailSubject = 'Check out this ${post.brand} ${post.model}';
      final uri = Uri(
        scheme: 'mailto',
        queryParameters: {
          'subject': emailSubject,
          'body': text,
        },
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await Share.share(text, subject: emailSubject);
      }
    } catch (e) {
      // If everything fails, just share the text without subject
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
      final uri = Uri.parse('instagram://share?url=${Uri.encodeComponent(url)}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
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
      await Share.share(url);
    }
  }
}
