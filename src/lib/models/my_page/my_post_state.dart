import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_post_state.freezed.dart';

part 'my_post_state.g.dart';

@freezed
class MyPostState with _$MyPostState {
  factory MyPostState({
    @Default([]) List<int> selectOrder,
    @Default(1) int currentOrder,
  }) = _MyPostState;

  factory MyPostState.fromJson(Map<String, dynamic> json) =>
      _$MyPostStateFromJson(json);
}
