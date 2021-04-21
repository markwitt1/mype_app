// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Group _$_$_GroupFromJson(Map<String, dynamic> json) {
  return _$_Group(
    id: json['id'] as String?,
    name: json['name'] as String,
    description: json['description'] as String? ?? '',
    userIds: (json['userIds'] as List<dynamic>).map((e) => e as String).toSet(),
  );
}

Map<String, dynamic> _$_$_GroupToJson(_$_Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'userIds': instance.userIds.toList(),
    };
