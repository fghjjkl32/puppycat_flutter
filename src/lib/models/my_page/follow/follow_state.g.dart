// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FollowState _$$_FollowStateFromJson(Map<String, dynamic> json) =>
    _$_FollowState(
      followerListState: FollowDataListModel.fromJson(
          json['followerListState'] as Map<String, dynamic>),
      followListState: FollowDataListModel.fromJson(
          json['followListState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_FollowStateToJson(_$_FollowState instance) =>
    <String, dynamic>{
      'followerListState': instance.followerListState,
      'followListState': instance.followListState,
    };
