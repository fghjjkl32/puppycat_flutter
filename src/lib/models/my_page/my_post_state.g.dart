// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_post_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MyPostState _$$_MyPostStateFromJson(Map<String, dynamic> json) =>
    _$_MyPostState(
      myPostState:
          SelectPost.fromJson(json['myPostState'] as Map<String, dynamic>),
      myKeepState:
          SelectPost.fromJson(json['myKeepState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_MyPostStateToJson(_$_MyPostState instance) =>
    <String, dynamic>{
      'myPostState': instance.myPostState,
      'myKeepState': instance.myKeepState,
    };
