import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_header_state.dart';

final commentHeaderProvider =
    StateNotifierProvider<CommentHeaderNotifier, CommentHeaderState>((ref) {
  return CommentHeaderNotifier();
});

class CommentHeaderNotifier extends StateNotifier<CommentHeaderState> {
  CommentHeaderNotifier() : super(CommentHeaderState());

  void addCommentHeader(name) {
    state = state.copyWith(name: name, isReply: true);
  }

  void resetCommentHeader() {
    state = state.copyWith(name: "", isReply: false);
  }
}
