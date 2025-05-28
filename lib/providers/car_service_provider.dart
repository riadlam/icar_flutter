import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:icar_instagram_ui/services/api/services/car_service.dart';

final carServiceProvider = Provider<CarService>((ref) {
  return CarService(
    client: http.Client(),
    storage: const FlutterSecureStorage(),
  );
});
