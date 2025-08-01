import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks if the user is in guest mode (used skip button).
final guestModeProvider = StateProvider<bool>((ref) => false);
