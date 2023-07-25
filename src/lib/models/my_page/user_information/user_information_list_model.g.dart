// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserInformationListModel _$$_UserInformationListModelFromJson(
        Map<String, dynamic> json) =>
    _$_UserInformationListModel(
      list: (json['list'] as List<dynamic>?)
              ?.map((e) =>
                  UserInformationItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isLoading: json['isLoading'] as bool? ?? true,
    );

Map<String, dynamic> _$$_UserInformationListModelToJson(
        _$_UserInformationListModel instance) =>
    <String, dynamic>{
      'list': instance.list,
      'isLoading': instance.isLoading,
    };
