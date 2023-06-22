// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TagImages _$$_TagImagesFromJson(Map<String, dynamic> json) => _$_TagImages(
      index: json['index'] as int,
      tag: (json['tag'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_TagImagesToJson(_$_TagImages instance) =>
    <String, dynamic>{
      'index': instance.index,
      'tag': instance.tag,
    };
