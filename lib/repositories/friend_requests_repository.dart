import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/general_providers.dart';
import 'package:mype_app/models/friend_request/friend_request.dart';

import 'custom_exception.dart';

final friendRequestsRepositoryProvider = Provider<FriendRequestsRepository>(
    (ref) => FriendRequestsRepository(ref.read));

class FriendRequestsRepository {
  final Reader _read;

  const FriendRequestsRepository(this._read);

  Future<Map<String, Set<FriendRequest>>> getFriendRequests(
      String userId) async {
    Map<String, Set<FriendRequest>> friendRequests = {
      "outgoing": Set(),
      "incoming": Set()
    };
    final res = await _read(firebaseFirestoreProvider)
        .collection("friendRequests")
        .get();
    for (final doc in res.docs) {
      final request = FriendRequest.fromDocument(doc);
      if (request.from == userId) {
        friendRequests["outgoing"]!.add(request);
      } else if (request.to == userId) {
        friendRequests["incoming"]!.add(request);
      }
    }
    return friendRequests;
  }

  Future<FriendRequest> createFriendRequest(FriendRequest request) async {
    try {
      final doc = await _read(firebaseFirestoreProvider)
          .collection("friendRequests")
          .add(request.toJson());
      return request.copyWith(id: doc.id);
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<void> deleteFriendRequest(String id) async {
    try {
      await _read(firebaseFirestoreProvider)
          .collection("friendRequests")
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
