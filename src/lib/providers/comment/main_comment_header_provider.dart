import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/comment/comment_header_state.dart';

final commentValueProvider = StateProvider<TextEditingController>((ref) => TextEditingController());

final commentHeaderProvider = StateNotifierProvider<CommentHeaderNotifier, CommentHeaderState>((ref) {
  return CommentHeaderNotifier();
});

class CommentHeaderNotifier extends StateNotifier<CommentHeaderState> {
  CommentHeaderNotifier() : super(CommentHeaderState());

  void addReplyCommentHeader(name, commentIdx) {
    print('commentIdx $commentIdx');
    state = state.copyWith(name: name, isReply: true, isEdit: false, commentIdx: commentIdx);
  }

  void resetReplyCommentHeader() {
    state = state.copyWith(
      name: "",
      isReply: false,
      isEdit: false,
      commentIdx: null,
      controllerValue: '',
      hasInput: false,
    );
  }

  void addEditCommentHeader(name, commentIdx) {
    state = state.copyWith(
      name: name,
      isReply: false,
      isEdit: true,
      commentIdx: commentIdx,
      hasSetControllerValue: true, // Add this line
    );
  }

  void setHasInput(bool value) {
    state = state.copyWith(hasInput: value);
  }

  void setControllerValue(String value) {
    state = state.copyWith(controllerValue: value);
  }

  void resetHasSetControllerValue() {
    state = state.copyWith(hasSetControllerValue: false);
  }
}
