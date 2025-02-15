import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'comment_data.freezed.dart';
part 'comment_data.g.dart';

@freezed
class CommentData with _$CommentData {
  factory CommentData({
    required int isBadge,
    required String memberUuid,
    int? commentLikeCnt,
    required String regDate,
    required int likeState,
    required String uuid,
    String? profileImgUrl,
    required String nick,
    required String contents,
    required int parentIdx,
    required int contentsIdx,
    required int state,
    required int idx,
    List<MentionListData>? mentionList,
    ChildCommentData? childCommentData,
    @Default(false) bool showAllReplies,
    @Default(0) int loadMoreClickCount,
    @Default(false) bool isReply,
    @Default(false) bool isLastDisPlayChild,
    // @Default(0) int remainChildCount,
    @Default(1) int pageNumber,
    @Default(false) bool isDisplayPreviousMore,
  }) = _CommentData;

  factory CommentData.fromJson(Map<String, dynamic> json) => _$CommentDataFromJson(json);
}

@freezed
class ChildCommentData with _$ChildCommentData {
  const factory ChildCommentData({
    required ParamsModel params,
    required List<CommentData> list,
  }) = _ChildCommentData;

  factory ChildCommentData.fromJson(Map<String, dynamic> json) => _$ChildCommentDataFromJson(json);
}
