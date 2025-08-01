import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/services/api/services/spare_parts_service.dart';

final sparePartsProfileProvider = FutureProvider<SparePartsProfile>((ref) async {
  try {
    return await serviceLocator.sparePartsService.getSparePartsProfile();
  } catch (e) {
    // Re-throw the error to be handled by the UI
    rethrow;
  }
});

final sellerSparePartsProvider = FutureProvider.family<List<SparePart>, dynamic>((ref, sellerId) async {
  try {
    return await serviceLocator.sparePartsService.getSparePartsBySeller(sellerId);
  } catch (e) {
    // Re-throw the error to be handled by the UI
    rethrow;
  }
});
