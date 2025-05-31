import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/favorite_seller.dart';
import '../../services/api/services/favorite_seller_list_service.dart';

class MenuDrawerScreen extends StatefulWidget {
  const MenuDrawerScreen({super.key});

  @override
  State<MenuDrawerScreen> createState() => _MenuDrawerScreenState();
}

class _MenuDrawerScreenState extends State<MenuDrawerScreen> {
  bool _isFavoriteSellersExpanded = false;
  bool _isPersonalInfoExpanded = false;
  // Store language code instead of display name
  String _selectedLanguageCode = 'en'; // Default to English
  bool _isAboutUsExpanded = false;
  bool _isContactUsExpanded = false;

  final Color customIconColor = Colors.lightGreen;

  List<Widget> _buildFavoriteSellersList() {
    if (_isLoading) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (_favoriteSellers.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Text(
            'No favorite sellers yet',
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ];
    }

    return _favoriteSellers
        .map((seller) => _buildSubMenuItem(seller.fullName))
        .toList();
  }
  bool _isLoading = false;
  List<FavoriteSeller> _favoriteSellers = [];
  final FavoriteSellerListService _favoriteSellerService = FavoriteSellerListService();

  @override
  void initState() {
    super.initState();
    _loadFavoriteSellers();
  }

  Future<void> _loadFavoriteSellers() async {
    if (!_isFavoriteSellersExpanded) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final sellers = await _favoriteSellerService.getFavoriteSellers();
      if (mounted) {
        setState(() {
          _favoriteSellers = sellers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load favorite sellers: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _buildExpandableSection(
                    icon: Icons.favorite_border,
                    title: 'favorite_sellers'.tr(),
                    isExpanded: _isFavoriteSellersExpanded,
                    onTap: () {
                      setState(() {
                        _isFavoriteSellersExpanded = !_isFavoriteSellersExpanded;
                        if (_isFavoriteSellersExpanded) {
                          _loadFavoriteSellers();
                        }
                      });
                    },
                    children: _isFavoriteSellersExpanded
                        ? _buildFavoriteSellersList()
                        : [],
                  ),
                  _buildExpandableSection(
                    icon: Icons.person_outline,
                    title: 'personal_info'.tr(),
                    isExpanded: _isPersonalInfoExpanded,
                    onTap: () {
                      setState(() {
                        _isPersonalInfoExpanded = !_isPersonalInfoExpanded;
                      });
                    },
                    children: _isPersonalInfoExpanded
                        ? [
                            _buildInfoRow(Icons.person, '${'name'.tr()}: John Doe'),
                            _buildInfoRow(Icons.location_city, '${'city'.tr()}: New York'),
                            _buildInfoRow(Icons.email, '${'email'.tr()}: john.doe@example.com'),
                          ]
                        : [],
                  ),
                  _buildExpandableSection(
                    icon: Icons.language,
                    title: 'language'.tr(),
                    isExpanded: true,
                    trailingText: _currentLanguageName,
                    onTap: _showLanguageDialog,
                  ),
                  _buildExpandableSection(
                    icon: Icons.info_outline,
                    title: 'about_us'.tr(),
                    isExpanded: _isAboutUsExpanded,
                    onTap: () {
                      setState(() {
                        _isAboutUsExpanded = !_isAboutUsExpanded;
                      });
                    },
                    children: _isAboutUsExpanded
                        ? [
                            _buildDescription('about_us_description'.tr()),
                          ]
                        : [],
                  ),
                  _buildExpandableSection(
                    icon: Icons.contact_support_outlined,
                    title: 'contact_us'.tr(),
                    isExpanded: _isContactUsExpanded,
                    onTap: () {
                      setState(() {
                        _isContactUsExpanded = !_isContactUsExpanded;
                      });
                    },
                    children: _isContactUsExpanded
                        ? [
                            _buildInfoRow(Icons.phone, 'support_phone'.tr()),
                            _buildInfoRow(Icons.email, 'support_email'.tr()),
                          ]
                        : [],
                  ),
                  const Divider(height: 30, thickness: 1),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'logout'.tr(),
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: _showLogoutDialog,
                  ),
                  _buildMenuItem(
                    icon: Icons.delete_outline,
                    title: 'delete_account'.tr(),
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: _showDeleteAccountDialog,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'app_version'.tr(),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: (iconColor ?? customIconColor).withOpacity(0.1),
        child: Icon(icon, size: 20, color: iconColor ?? customIconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildExpandableSection({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    List<Widget> children = const [],
    String? trailingText,
  }) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: customIconColor.withOpacity(0.1),
            child: Icon(icon, color: customIconColor, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    trailingText,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey,
              ),
            ],
          ),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        if (isExpanded && children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(children: children),
          ),
      ],
    );
  }

  Widget _buildSubMenuItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 60.0, right: 20, top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  // Get the current locale display name
  String get _currentLanguageName {
    switch (context.locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      case 'en':
      default:
        return 'English';
    }
  }

  void _changeLanguage(String languageCode) async {
    if (context.mounted) {
      await context.setLocale(Locale(languageCode));
      if (mounted) {
        setState(() {
          _selectedLanguageCode = languageCode;
        });
      }
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('en', 'English'),
            _buildLanguageOption('fr', 'Français'),
            _buildLanguageOption('ar', 'العربية'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String code, String name) {
    final isSelected = context.locale.languageCode == code;
    return ListTile(
      title: Text(name, textAlign: TextAlign.center),
      trailing: isSelected 
          ? const Icon(Icons.check, color: Colors.blue) 
          : null,
      onTap: () {
        _changeLanguage(code);
        Navigator.pop(context);
      },
      tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout'.tr()),
        content: Text('confirm_logout'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr().toUpperCase()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // drawer
            },
            child: Text('logout'.tr().toUpperCase(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_account'.tr()),
        content: Text('confirm_delete_account'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr().toUpperCase()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // drawer
            },
            child: Text('delete_account'.tr().toUpperCase(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
