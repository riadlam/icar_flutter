import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/home_content/home_content.dart';
import '../outils/appbar_custom.dart' show AnimatedSearchAppBar;

final _log = Logger('HomeScreen');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedRoleIndex = 0;

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
                                  ? Colors.blue
                                  : Colors.grey[200],
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
