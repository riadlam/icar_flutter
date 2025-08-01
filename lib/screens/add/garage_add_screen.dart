import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/widgets/garage/add_garage_form_sheet.dart';

class GarageAddScreen extends StatelessWidget {
  GarageAddScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TowTruckNavBar(
        title: 'iCar',
        scaffoldKey: _scaffoldKey,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => AddGarageFormSheet(
                initialName: '',
                initialCity: '',
                initialPhone: '',
                initialServices: const [],
                onSubmit: (name, city, phone, services) async {
                  // Placeholder: you can implement actual submission logic here
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Garage profile submitted!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.loginbg,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'add_garage_card'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
