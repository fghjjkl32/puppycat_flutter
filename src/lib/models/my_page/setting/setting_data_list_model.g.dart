// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_data_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SettingDataListModel _$$_SettingDataListModelFromJson(
        Map<String, dynamic> json) =>
    _$_SettingDataListModel(
      mainList: (json['mainList'] as List<dynamic>?)
              ?.map((e) => MainListData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subList: (json['subList'] as List<dynamic>?)
              ?.map((e) => SubListData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      switchState: (json['switchState'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
    );

Map<String, dynamic> _$$_SettingDataListModelToJson(
        _$_SettingDataListModel instance) =>
    <String, dynamic>{
      'mainList': instance.mainList,
      'subList': instance.subList,
      'switchState': instance.switchState,
    };
