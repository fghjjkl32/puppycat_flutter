// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CommentData _$$_CommentDataFromJson(Map<String, dynamic> json) =>
    _$_CommentData(
      nick: json['nick'] as String,
      likeCnt: json['likeCnt'] as int,
      isBadge: json['isBadge'] as int,
      memberIdx: json['memberIdx'] as int,
      contents: json['contents'] as String,
      parentIdx: json['parentIdx'] as int,
      contentsIdx: json['contentsIdx'] as int,
      regDate: json['regDate'] as String,
      state: json['state'] as int,
      idx: json['idx'] as int,
      uuid: json['uuid'] as String,
      url: json['url'] as String?,
      childCommentData: json['childCommentData'] == null
          ? null
          : ChildCommentData.fromJson(
              json['childCommentData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CommentDataToJson(_$_CommentData instance) =>
    <String, dynamic>{
      'nick': instance.nick,
      'likeCnt': instance.likeCnt,
      'isBadge': instance.isBadge,
      'memberIdx': instance.memberIdx,
      'contents': instance.contents,
      'parentIdx': instance.parentIdx,
      'contentsIdx': instance.contentsIdx,
      'regDate': instance.regDate,
      'state': instance.state,
      'idx': instance.idx,
      'uuid': instance.uuid,
      'url': instance.url,
      'childCommentData': instance.childCommentData,
    };

_$_ChildCommentData _$$_ChildCommentDataFromJson(Map<String, dynamic> json) =>
    _$_ChildCommentData(
      params: ParamsModel.fromJson(json['params'] as Map<String, dynamic>),
      list: (json['list'] as List<dynamic>)
          .map((e) => CommentData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ChildCommentDataToJson(_$_ChildCommentData instance) =>
    <String, dynamic>{
      'params': instance.params,
      'list': instance.list,
    };
