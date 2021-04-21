// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mype_marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MypeMarker _$_$_MypeMarkerFromJson(Map<String, dynamic> json) {
  return _$_MypeMarker(
    id: json['id'] as String?,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    imageIds:
        (json['imageIds'] as List<dynamic>).map((e) => e as String).toList(),
    groupIds:
        (json['groupIds'] as List<dynamic>).map((e) => e as String).toSet(),
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
}

Map<String, dynamic> _$_$_MypeMarkerToJson(_$_MypeMarker instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageIds': instance.imageIds,
      'groupIds': instance.groupIds.toList(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
