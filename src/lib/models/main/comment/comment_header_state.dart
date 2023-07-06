import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_header_state.freezed.dart';
part 'comment_header_state.g.dart';

@freezed
class CommentHeaderState with _$CommentHeaderState {
  factory CommentHeaderState({
    @Default(false) bool isReply,
    @Default("") String name,
  }) = _CommentHeaderState;

  factory CommentHeaderState.fromJson(Map<String, dynamic> json) =>
      _$CommentHeaderStateFromJson(json);
}
