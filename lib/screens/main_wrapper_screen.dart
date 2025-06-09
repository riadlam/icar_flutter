import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainWrapperScreen extends StatefulWidget {
  final Widget child;

  const MainWrapperScreen({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _selectedNavIndex = 0;

  void _onItemTapped(int index) {
    // Don't update the selected index for the add button
    if (index == 2) {
      context.go('/add');
      return;
    }

    setState(() {
      _selectedNavIndex = index;
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          // Wishlist screen
          context.go('/wishlist');
          break;
        case 3:
          // Profile screen
          context.go('/profile');
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // Role is now handled by the provider and fetched from the backend
        // We always want to show the profile icon regardless of role
        
        return Scaffold(
          body: SafeArea(
            child: widget.child,
          ),
          bottomNavigationBar: BottomNavigationBarWidget(
            currentIndex: _selectedNavIndex,
            onTap: _onItemTapped,
            showProfile: true, // Always show profile icon
          ),
        );
      },
    );
  }
}
