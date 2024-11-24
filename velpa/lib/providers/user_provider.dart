import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/services/admin_service.dart';

final userPermissionsProvider =
    StateNotifierProvider<UserPermissionsNotifier, Map<String, bool>>((ref) {
  return UserPermissionsNotifier();
});

class UserPermissionsNotifier extends StateNotifier<Map<String, bool>> {
  UserPermissionsNotifier() : super({});
  final adminService = AdminService();

  Future<bool> checkPermission(String action) async {
    if (state.containsKey(action)) {
      return state[action]!;
    }

    final hasPermission = await adminService.checkUserPermissions(action);
    state = {...state, action: hasPermission};
    return hasPermission;
  }

  void clearCache() {
    state = {};
  }
}
