import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/filter_controller.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';

class FilterWindow extends HookWidget {
  const FilterWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterController = useProvider(filterControllerProvider);
    final filteredGroups = useProvider(filterControllerProvider.state);
    final allGroups =
        useProvider(groupsControllerProvider.state).values.toSet();

    final selectedGroups = useState<Set<Group>>(
        filteredGroups == null ? allGroups : filteredGroups);

    useEffect(() {
      selectedGroups.value =
          filteredGroups == null ? allGroups : filteredGroups;
    }, [filteredGroups]);

    return Scaffold(
        appBar: AppBar(
          title: Text("Filter Markers"),
        ),
        body: ListView.builder(
            itemCount: allGroups.length,
            itemBuilder: (context, i) => CheckboxListTile(
                key: Key(allGroups.elementAt(i).id!),
                title: Text(allGroups.elementAt(i).name),
                value: selectedGroups.value
                    .where((group) => allGroups.elementAt(i).id == group.id)
                    .isNotEmpty,
                onChanged: (value) {
                  if (value != null) {
                    if (value) {
                      filterController.setGroups([
                        ...selectedGroups.value,
                        allGroups.elementAt(i)
                      ].toSet());
                    } else {
                      selectedGroups.value.remove(allGroups.elementAt(i));
                      filterController.setGroups(selectedGroups.value);
                    }
                  }
                })));
  }
}
