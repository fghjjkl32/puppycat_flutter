import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'comment_data.freezed.dart';
part 'comment_data.g.dart';

@freezed
class CommentData with _$CommentData {
  factory CommentData({
    required String nick,
    required int likeCnt,
    required int likeState,
    required int isBadge,
    required int memberIdx,
    required String contents,
    required int parentIdx,
    required int contentsIdx,
    required String regDate,
    required int state,
    required int idx,
    required String uuid,
    String? url,
    ChildCommentData? childCommentData,
  }) = _CommentData;

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);
}

@freezed
class ChildCommentData with _$ChildCommentData {
  const factory ChildCommentData({
    required ParamsModel params,
    required List<CommentData> list,
  }) = _ChildCommentData;

  factory ChildCommentData.fromJson(Map<String, dynamic> json) =>
      _$ChildCommentDataFromJson(json);
}
