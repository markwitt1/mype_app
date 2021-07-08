import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/FriendProfilePicture.dart';
import 'package:mype_app/controllers/friend_requests_controller.dart';
import 'package:mype_app/controllers/friends_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/models/user_model/user_model.dart';

Future<void> showUserDialog(BuildContext context, User user,
        {bool newFriendRequest = false}) =>
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: UserDialog(
                user,
                newFriendRequest: newFriendRequest,
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) => UserDialog(user));

class UserDialog extends HookWidget {
  final User user;

  const UserDialog(this.user, {Key? key, bool newFriendRequest = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final friendsController = useProvider(friendsControllerProvider);
    final friends = useProvider(friendsControllerProvider.state);

    final friendRequestsController =
        useProvider(friendRequestsControllerProvider);
    final friendRequests = useProvider(friendRequestsControllerProvider.state);

    useEffect(() {
      friendRequestsController.getFriendRequests();
    }, []);
    final requestOutgoing = friendRequests["outgoing"]!.any(
      ((fr) => fr.to == user.id!),
    );
    final requestIncoming = friendRequests["incoming"]!.any(
      ((fr) => fr.from == user.id!),
    );
    final isFriends = friends.containsKey(user.id);

    return Dialog(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (requestIncoming)
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  "New Friend Request!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: FriendProfilePicture(
                      fileName: user.profilePicture,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      user.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                isFriends ? Colors.red : Colors.blue)),
                        onPressed: isFriends
                            ? () {
                                friendsController.removeFriend(user.id!);
                                Navigator.of(context).pop();
                              }
                            : requestIncoming
                                ? () {
                                    friendRequestsController.accept(
                                        friendRequests["incoming"]!.firstWhere(
                                            (fr) => fr.from == user.id!));
                                    Navigator.of(context).pop();
                                  }
                                : requestOutgoing
                                    ? null
                                    : () {
                                        friendRequestsController
                                            .sendFriendRequest(user.id!);
                                        Navigator.of(context).pop();
                                      },
                        icon: isFriends
                            ? Icon(Icons.person_remove)
                            : Icon(Icons.person_add),
                        label: Text(requestIncoming
                            ? "Accept Friend Request"
                            : isFriends
                                ? "Remove Friend"
                                : "Send Friend Request"))
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
