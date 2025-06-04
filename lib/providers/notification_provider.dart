import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

final unreadCountProvider = StateNotifierProvider<UnreadCountNotifier, AsyncValue<int>>((ref) {
  return UnreadCountNotifier();
});

class UnreadCountNotifier extends StateNotifier<AsyncValue<int>> {
  UnreadCountNotifier() : super(const AsyncValue.loading()) {
    loadUnreadCount();
  }

  Future<void> loadUnreadCount() async {
    state = const AsyncValue.loading();
    try {
      final count = await serviceLocator.notificationService.getUnreadCount();
      state = AsyncValue.data(count);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadUnreadCount();
  }
}
