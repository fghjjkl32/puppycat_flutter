import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_header_state.freezed.dart';
part 'comment_header_state.g.dart';

@freezed
class CommentHeaderState with _$CommentHeaderState {
  factory CommentHeaderState({
    @Default(false) bool isReply,
    @Default(false) bool isEdit,
    @Default("") String name,
    @Default(null) int? commentIdx,
    @Default(false) bool hasInput,
    @Default("") String controllerValue,
    @Default(false) bool hasSetControllerValue,
  }) = _CommentHeaderState;

  factory CommentHeaderState.fromJson(Map<String, dynamic> json) => _$CommentHeaderStateFromJson(json);
}
