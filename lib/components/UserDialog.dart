import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/FriendProfilePicture.dart';
import 'package:mype_app/controllers/friend_requests_controller.dart';
import 'package:mype_app/controllers/friends_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/models/user_model/user_model.dart';

showUserDialog(BuildContext context, user) => showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(
          opacity: a1.value,
          child: UserDialog(user),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) => UserDialog(user));

/* showDialog(
    context: context,
    builder: (_) {
      /* return Transform.translate(
        offset: Offset(animation.value, 0),
        child: */
      return UserDialog(user);
    });
 */
class UserDialog extends HookWidget {
  final User user;

  const UserDialog(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final friendsController = useProvider(friendsControllerProvider);
    final friendRequestsController =
        useProvider(friendRequestsControllerProvider);
    final friendRequests = useProvider(friendRequestsControllerProvider.state);
    final ownUser = useProvider(userControllerProvider.state);

    final requestOutgoing = friendRequests["outgoing"]!.any(
      ((fr) => fr.to == user.id!),
    );
    final requestIncoming = friendRequests["incoming"]!.any(
      ((fr) => fr.from == user.id!),
    );
    final isFriends = ownUser!.friendIds.contains(user.id);

    return Dialog(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                              }
                            : requestIncoming
                                ? () {
                                    friendRequestsController.accept(
                                        friendRequests["incoming"]!.firstWhere(
                                            (fr) => fr.from == user.id!));
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
