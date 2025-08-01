import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/add_card_form_sheet.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

class MechanicAddScreen extends StatelessWidget {
  MechanicAddScreen({super.key});

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
              builder: (context) => AddCardFormSheet(
                initialName: '',
                initialCity: '',
                initialPhone: '',
                onSubmit: (name, city, phone) async {
                  try {
                    // Actually submit the mechanic profile using TowTruckService
                    final serviceLocator = ServiceLocator();
                    await serviceLocator.towTruckService.createOrUpdateTowTruckProfile(
                      businessName: name,
                      driverName: name,
                      mobile: phone,
                      city: city,
                    );
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    });
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Operation completed successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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
            'add_tow_truck_service'.tr(),
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
