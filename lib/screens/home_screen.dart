import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:logging/logging.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/home_content/home_content.dart';
import '../outils/appbar_custom.dart' show AnimatedSearchAppBar;
import '../providers/notification_provider.dart';

final _log = Logger('HomeScreen');

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver, RouteAware {
  int _selectedRoleIndex = 0;
  RouteObserver<PageRoute>? _routeObserver;
  PageRoute? _currentRoute;

  List<Map<String, dynamic>> get _roles => [
    {'icon': Icons.directions_car, 'label': 'rent_sell_car'.tr()},
    {'icon': Icons.shopping_cart, 'label': 'spare_parts'.tr()},
    {'icon': Icons.local_shipping, 'label': 'tow_truck'.tr()},
    {'icon': Icons.build, 'label': 'garage'.tr()},
  ];

  final List<Widget> _contentWidgets = const [
    CarPostsContent(),
    SparePartsContent(),
    TowTruckContent(),
    GarageContent(),
  ];

  void _onRoleSelected(int index) {
    _log.fine('Role selected: ${_roles[index]["label"]}');
    setState(() {
      _selectedRoleIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedRoleIndex = 0;
    WidgetsBinding.instance.addObserver(this);
    _refreshNotifications(); // Initial refresh
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get the current route
    final newRoute = ModalRoute.of(context);
    if (newRoute is! PageRoute) return;
    
    // If the route hasn't changed, do nothing
    if (newRoute == _currentRoute) return;
    
    // Unsubscribe from the old route if it exists
    if (_routeObserver != null && _currentRoute != null) {
      _routeObserver!.unsubscribe(this);
    }
    
    // Subscribe to the new route
    _currentRoute = newRoute;
    _routeObserver = _currentRoute!.navigator?.widget.observers.firstWhere(
      (observer) => observer is RouteObserver<PageRoute>,
      orElse: () => RouteObserver<PageRoute>(),
    ) as RouteObserver<PageRoute>;
    
    _routeObserver?.subscribe(this, _currentRoute!);
  }

  @override
  void dispose() {
    // Unsubscribe from route observer if we have one
    if (_routeObserver != null && _currentRoute != null) {
      _routeObserver!.unsubscribe(this);
    }
    
    // Clean up
    _routeObserver = null;
    _currentRoute = null;
    
    // Remove other observers
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    // Called when a new route is pushed on top
  }

  @override
  void didPopNext() {
    // Called when the current route is popped and this route becomes visible again
    _refreshNotifications();
  }

  void _refreshNotifications() {
    if (!mounted) return;
    
    // Schedule the refresh for after the current build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(unreadCountProvider.notifier).refresh();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshNotifications();
    }
  }

  @override
  void didPush() {
    // Called when this route is pushed
    _refreshNotifications();
  }
  
  @override
  void didPop() {
    // Called when this route is popped
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedSearchAppBar(),
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _roles.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _onRoleSelected(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: _selectedRoleIndex == index
                                  ? AppColors.loginbg
                                  : Colors.grey[199],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _roles[index]['icon'],
                                  color: _selectedRoleIndex == index
                                      ? Colors.white
                                      : Colors.grey[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _roles[index]['label'],
                                  style: TextStyle(
                                    color: _selectedRoleIndex == index
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Expanded(
              child: _contentWidgets[_selectedRoleIndex],
            ),
          ],
        ),
      ),
    );
  }
}
