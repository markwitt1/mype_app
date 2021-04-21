import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/friend_requests_controller.dart';
import 'package:mype_app/models/user_model/user_model.dart';
import 'package:mype_app/repositories/user_repository.dart';

class IncomingFriendRequests extends HookWidget {
  const IncomingFriendRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final friendRequestsController =
        useProvider(friendRequestsControllerProvider);
    final friendRequests = useProvider(friendRequestsControllerProvider.state);
    final incomingFriendRequests = friendRequests["incoming"]!.toList();
    final userRepository = useProvider(userRepositoryProvider);
    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Incoming friend requests:"),
        incomingFriendRequests.length > 0
            ? /* Text("alot") */
            ListView.builder(
                shrinkWrap: true,
                itemCount: incomingFriendRequests.length,
                itemBuilder: (_, i) {
                  return FutureBuilder(
                      future: userRepository
                          .getUser(incomingFriendRequests[i].from),
                      builder: (_, AsyncSnapshot<User?> snapshot) {
                        if (snapshot.hasData) {
                          return ListTile(
                            title: Text(
                              "From: ${snapshot.data!.name}",
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.check),
                                    onPressed: () {
                                      friendRequestsController
                                          .accept(incomingFriendRequests[i]);
                                    }),
                                IconButton(
                                    icon: Icon(Icons.close), onPressed: () {})
                              ],
                            ),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      });
                })
            : Text("None")
      ]),
    );
  }
}
