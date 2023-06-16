// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Tag _$$_TagFromJson(Map<String, dynamic> json) => _$_Tag(
      username: json['username'] as String,
      position: const OffsetConverter()
          .fromJson(json['position'] as Map<String, double>),
    );

Map<String, dynamic> _$$_TagToJson(_$_Tag instance) => <String, dynamic>{
      'username': instance.username,
      'position': const OffsetConverter().toJson(instance.position),
    };
