// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_information_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MyInformationItemModel _$$_MyInformationItemModelFromJson(
        Map<String, dynamic> json) =>
    _$_MyInformationItemModel(
      memberIdx: json['memberIdx'] as int?,
      nick: json['nick'] as String?,
      simpleType: json['simpleType'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      intro: json['intro'] as String?,
      profileImgUrl: json['profileImgUrl'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$_MyInformationItemModelToJson(
        _$_MyInformationItemModel instance) =>
    <String, dynamic>{
      'memberIdx': instance.memberIdx,
      'nick': instance.nick,
      'simpleType': instance.simpleType,
      'name': instance.name,
      'phone': instance.phone,
      'intro': instance.intro,
      'profileImgUrl': instance.profileImgUrl,
      'email': instance.email,
    };
