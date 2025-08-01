import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks guest clicks for unauthenticated users who used skip.
final guestClickCountProvider = StateNotifierProvider<GuestClickCountNotifier, int>((ref) => GuestClickCountNotifier());

class GuestClickCountNotifier extends StateNotifier<int> {
  GuestClickCountNotifier() : super(0);

  void increment() => state++;
  void reset() => state = 0;
}
