import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/screens/menu/menu_drawer_screen.dart';

class TowTruckNavBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
  
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final List<Widget>? actions;

  const TowTruckNavBar({
    super.key,
    required this.scaffoldKey,
    this.title = 'iCar',
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title:const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'iCar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        ...?actions,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black,size: 30,),
            onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
          ),
        ),
      ],
    );
  }

  static Widget buildDrawer(BuildContext context) {
    return const MenuDrawerScreen();
  }
}
