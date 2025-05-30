import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icar_instagram_ui/services/api/services/car_profile_service.dart';

final carProfileProvider = Provider<CarProfileService>((ref) {
  return CarProfileService(
    client: http.Client(),
    storage: const FlutterSecureStorage(),
  );
});
