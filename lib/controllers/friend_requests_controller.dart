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

  Future<void> getFriendRequests() async {
    try {
      if (_user != null && _user!.id != null) {
        state = await _read(friendRequestsRepositoryProvider)
            .getFriendRequests(_user!.id!);
      }
    } on CustomException catch (e) {
      _read(exceptionProvider).state = e;
      print(e.toString());
    }
  }

  Future<void> sendFriendRequest(String otherUserId) async {
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

            bool addedNew = state["outgoing"]!.add(friendRequest);
            state = {...state};
            if (!addedNew) {
              final e = CustomException(message: "Friend request already sent");
              _read(exceptionProvider).state = e;
              throw e;
            }
          } else {
            final e = CustomException(message: "User does not exist");
            _read(exceptionProvider).state = e;
            throw e;
          }
        } on FirebaseException catch (fe) {
          final e = CustomException(message: "Error adding friend: $fe");
          _read(exceptionProvider).state = e;
          throw e;
        }
      } else {
        final e = CustomException(message: "You are already friends!");
        _read(exceptionProvider).state = e;
        throw e;
      }
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

      _read(userRepositoryProvider).updateUser(otherUser.copyWith(
          friendIds: [...otherUser.friendIds, _user!.id!].toSet()));

      state["incoming"]!.remove(friendRequest);
      state = state;
    } else {
      throw CustomException(message: "Error accepting friend request");
    }
  }

  void reject(FriendRequest friendRequest) async {
    try {
      _read(friendRequestsRepositoryProvider)
          .deleteFriendRequest(friendRequest.id!);
      state["incoming"]!.remove(friendRequest);
      state = state;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
