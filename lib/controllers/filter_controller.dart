import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';

final filterControllerProvider = StateNotifierProvider<FilterController>((ref) {
  final allGroups = ref.watch(groupsControllerProvider.state).values.toSet();
  return FilterController(ref.read, allGroups);
});

class FilterController extends StateNotifier<Set<Group>?> {
  final Reader _read;
  final Set<Group> allGroups;
  FilterController(this._read, this.allGroups) : super(null);

  setGroups(Set<Group> groups) {
    if (groups.containsAll(allGroups)) {
      state = null;
    } else {
      state = groups;
    }
  }
}
