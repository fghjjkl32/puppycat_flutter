// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_image_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ContentImageData _$$_ContentImageDataFromJson(Map<String, dynamic> json) =>
    _$_ContentImageData(
      imgUrl: json['imgUrl'] as String,
      idx: json['idx'] as int,
      commentCnt: json['commentCnt'] as int?,
      likeCnt: json['likeCnt'] as int?,
      imageCnt: json['imageCnt'] as int,
    );

Map<String, dynamic> _$$_ContentImageDataToJson(_$_ContentImageData instance) =>
    <String, dynamic>{
      'imgUrl': instance.imgUrl,
      'idx': instance.idx,
      'commentCnt': instance.commentCnt,
      'likeCnt': instance.likeCnt,
      'imageCnt': instance.imageCnt,
    };
