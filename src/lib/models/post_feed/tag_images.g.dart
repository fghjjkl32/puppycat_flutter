// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TagImages _$$_TagImagesFromJson(Map<String, dynamic> json) => _$_TagImages(
      index: json['index'] as int,
      tags: (json['tags'] as List<dynamic>)
          .map(
              (e) => const OffsetConverter().fromJson(e as Map<String, double>))
          .toList(),
    );

Map<String, dynamic> _$$_TagImagesToJson(_$_TagImages instance) =>
    <String, dynamic>{
      'index': instance.index,
      'tags': instance.tags.map(const OffsetConverter().toJson).toList(),
    };
