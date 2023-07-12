// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserInfoModel _$$_UserInfoModelFromJson(Map<String, dynamic> json) =>
    _$_UserInfoModel(
      userModel: json['userModel'] == null
          ? null
          : UserModel.fromJson(json['userModel'] as Map<String, dynamic>),
      chatUserModel: json['chatUserModel'] == null
          ? null
          : ChatUserModel.fromJson(
              json['chatUserModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_UserInfoModelToJson(_$_UserInfoModel instance) =>
    <String, dynamic>{
      'userModel': instance.userModel,
      'chatUserModel': instance.chatUserModel,
    };
