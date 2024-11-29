import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/user_provider.dart';

final appStateProvider = Provider((ref) {
  return AppStateController(ref);
});

class AppStateController {
  final Ref ref;

  AppStateController(this.ref);

  void resetAppState() {
    // Nollaa kaikki tarvittavat providerit hallitusti
    ref.invalidate(currentUserProvider);
    // Muiden providereiden nollaus tarvittaessa
  }
}
