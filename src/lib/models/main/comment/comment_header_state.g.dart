// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_header_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CommentHeaderState _$$_CommentHeaderStateFromJson(
        Map<String, dynamic> json) =>
    _$_CommentHeaderState(
      isReply: json['isReply'] as bool? ?? false,
      name: json['name'] as String? ?? "",
      parentIdx: json['parentIdx'] as int? ?? null,
    );

Map<String, dynamic> _$$_CommentHeaderStateToJson(
        _$_CommentHeaderState instance) =>
    <String, dynamic>{
      'isReply': instance.isReply,
      'name': instance.name,
      'parentIdx': instance.parentIdx,
    };
