// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_post_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MyPostState _$$_MyPostStateFromJson(Map<String, dynamic> json) =>
    _$_MyPostState(
      selectOrder: (json['selectOrder'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      currentOrder: json['currentOrder'] as int? ?? 1,
    );

Map<String, dynamic> _$$_MyPostStateToJson(_$_MyPostState instance) =>
    <String, dynamic>{
      'selectOrder': instance.selectOrder,
      'currentOrder': instance.currentOrder,
    };
