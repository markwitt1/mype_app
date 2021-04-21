import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/models/friend_request/friend_request.dart';
import 'package:mype_app/models/user_model/user_model.dart';
import 'package:mype_app/repositories/custom_exception.dart';
import 'package:mype_app/repositories/friend_requests_repository.dart';
import 'package:mype_app/repositories/user_repository.dart';

final friendRequestsControllerProvider =
    // ignore: top_level_function_literal_block
    StateNotifierProvider((ProviderReference ref) {
  final user = ref.watch(userControllerProvider.state);
  return FriendRequestsController(ref.read, user)..getFriendRequests();
});

class FriendRequestsController
    extends StateNotifier<Map<String, Set<FriendRequest>>> {
  final Reader _read;
  final User? _user;
  FriendRequestsController(this._read, this._user)
      : super({
          "incoming": Set(),
          "outgoing": Set(),
        });

  getFriendRequests() async {
    if (_user != null && _user!.id != null) {
      state = await _read(friendRequestsRepositoryProvider)
          .getFriendRequests(_user!.id!);
    }
  }

  sendFriendRequest(String otherUserId) async {
    if ((_user != null && _user!.id != null)) {
      if (!_user!.friendIds.contains(otherUserId)) {
        try {
          final otherUser =
              await _read(userRepositoryProvider).getUser(otherUserId);
          if (otherUser != null && otherUser.id != null) {
            final friendRequest = await _read(friendRequestsRepositoryProvider)
                .createFriendRequest(FriendRequest(
              from: _user!.id!,
              to: otherUser.id!,
            ));
/* 
            await _read(userRepositoryProvider).updateUser(_user!.copyWith(
                friendIds: [..._user!.friendIds, otherUserId].toSet()));
            final updatedOtherUser = otherUser.copyWith(
                friendIds: [...otherUser.friendIds, _user!.id!].toSet());
            await _read(userRepositoryProvider).updateUser(updatedOtherUser);
            state[otherUserId] = updatedOtherUser; */

            bool addedNew = state["outgoing"]!.add(friendRequest);
            if (!addedNew)
              throw CustomException(message: "Friend request already sent");
          } else
            throw CustomException(message: "User does not exist");
        } on FirebaseException catch (e) {
          return throw CustomException(message: "Error adding friend: $e");
        }
      } else
        throw CustomException(message: "You are already friends!");
    }
  }

  void accept(FriendRequest friendRequest) async {
    final otherUser =
        await _read(userRepositoryProvider).getUser(friendRequest.from);
    if (_user != null &&
        otherUser != null &&
        !_user!.friendIds.contains(friendRequest.from) &&
        friendRequest.to == _user!.id) {
      _read(friendRequestsRepositoryProvider)
          .deleteFriendRequest(friendRequest.id!);
      _read(userControllerProvider).updateUser(_user!.copyWith(
          friendIds: [..._user!.friendIds, friendRequest.from].toSet()));

      _read(userControllerProvider).updateUser(otherUser.copyWith(
          friendIds: [...otherUser.friendIds, _user!.id!].toSet()));
    } else {
      throw CustomException(message: "Error accepting friend request");
    }
  }
}
