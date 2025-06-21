import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/spare_parts_post.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

final sparePartsPostsProvider = FutureProvider<List<SparePartsPost>>((ref) async {
  try {
    final response = await serviceLocator.sparePartsService.getMySparePartsPosts();
    return response;
  } catch (e) {
    // Handle error appropriately
    rethrow;
  }
});
