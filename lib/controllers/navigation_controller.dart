import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';

final navigationControllerProvider =
    StateNotifierProvider<NavigationController>((ref) {
  return NavigationController(ref.read);
});

class NavigationController extends StateNotifier<int> {
  final Reader _read;
  NavigationController(this._read) : super(0);

  navigate(int index) {
    state = index;
  }
}
