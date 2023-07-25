// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BlockData _$$_BlockDataFromJson(Map<String, dynamic> json) => _$_BlockData(
      nick: json['nick'] as String?,
      memberIdx: json['memberIdx'] as int?,
      intro: json['intro'] as String?,
      profileImgUrl: json['profileImgUrl'] as String?,
      isBadge: json['isBadge'] as int?,
    );

Map<String, dynamic> _$$_BlockDataToJson(_$_BlockData instance) =>
    <String, dynamic>{
      'nick': instance.nick,
      'memberIdx': instance.memberIdx,
      'intro': instance.intro,
      'profileImgUrl': instance.profileImgUrl,
      'isBadge': instance.isBadge,
    };
