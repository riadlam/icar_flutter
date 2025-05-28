import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  // Initialize logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runZonedGuarded(
    () {
      runApp(
        EasyLocalization(
          path: 'assets/translations',
          saveLocale: true,
          startLocale: const Locale('en'),
          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
            Locale('ar'),
          ],
          fallbackLocale: const Locale('en'),
          child: ScreenUtilInit(
            designSize: const Size(360, 690), // Default design size for mobile
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) => const ProviderScope(
              child: MyApp(),
            ),
          ),
        ),
      );
    },
    (error, stackTrace) {
      Logger('GlobalErrorHandler').severe('Uncaught error', error, stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'iCar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: AppRouter.router,
    );
  }
}
