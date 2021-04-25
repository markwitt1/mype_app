// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$_$_UserFromJson(Map<String, dynamic> json) {
  return _$_User(
    id: json['code'] as String?,
    name: json['name'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String,
    friendIds:
        (json['friendIds'] as List<dynamic>).map((e) => e as String).toSet(),
  );
}

Map<String, dynamic> _$_$_UserToJson(_$_User instance) => <String, dynamic>{
      'code': createCode(instance.id),
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'friendIds': instance.friendIds.toList(),
    };
