// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FriendRequest _$_$_FriendRequestFromJson(Map<String, dynamic> json) {
  return _$_FriendRequest(
    id: json['id'] as String?,
    from: json['from'] as String,
    to: json['to'] as String,
    message: json['message'] as String? ?? '',
  );
}

Map<String, dynamic> _$_$_FriendRequestToJson(_$_FriendRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from': instance.from,
      'to': instance.to,
      'message': instance.message,
    };
