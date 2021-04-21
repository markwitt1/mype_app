import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part "friend_request.freezed.dart";
part "friend_request.g.dart";

@freezed
class FriendRequest with _$FriendRequest {
  const factory FriendRequest(
      {String? id,
      required String from,
      required String to,
      @Default("") String message}) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);

  factory FriendRequest.fromDocument(DocumentSnapshot doc) =>
      FriendRequest.fromJson(doc.data()!).copyWith(id: doc.id);
}
