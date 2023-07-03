import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag_images.dart';

final feedWriteProvider =
    StateNotifierProvider<PostFeedWriteNotifier, PostFeedState>((ref) {
  return PostFeedWriteNotifier();
});

class PostFeedWriteNotifier extends StateNotifier<PostFeedState> {
  PostFeedWriteNotifier()
      : super(PostFeedState(tagList: [], tagImage: [], offsetCount: 0));

  // 이미지에 태그를 추가하는 함수입니다.
  void addTag(Tag tag, int imageIndex, BuildContext context) {
    List<TagImages> newTagImage = List.from(state.tagImage);
    int existingIndex = -1;

    // 이미지 인덱스를 확인하고, 해당 이미지에 이미 태그가 있으면 해당 인덱스를 저장합니다.
    for (int i = 0; i < newTagImage.length; i++) {
      if (newTagImage[i].index == imageIndex) {
        existingIndex = i;
        break;
      }
    }

    // 이미지에 태그가 이미 있으면, 기존 태그에 추가하고, 그렇지 않으면 새 태그 이미지를 추가합니다.
    if (existingIndex != -1) {
      List<Tag> newTags = List.from(newTagImage[existingIndex].tag)..add(tag);
      newTagImage[existingIndex] =
          newTagImage[existingIndex].copyWith(tag: newTags);
    } else {
      newTagImage.add(TagImages(index: imageIndex, tag: [tag]));
    }

    // 새로운 태그 이미지로 상태를 업데이트하고, offsetCount를 1 증가시킵니다.
    state = state.copyWith(
        tagImage: newTagImage, offsetCount: state.offsetCount + 1);
  }

  // 태그를 저장하는 함수입니다. 현재 상태를 그대로 저장합니다.
  void saveTag() {
    state = state.copyWith(tagImage: state.tagImage);
  }

  // 태그를 초기화하는 함수입니다.
  void resetTag() {
    state = state.copyWith(tagList: [], tagImage: [], offsetCount: 0);
  }

  // 특정 태그를 제거하는 함수입니다.
  void removeTag(Tag tag) {
    List<TagImages> newTagImage = [];

    // 각 태그 이미지에서 특정 태그를 전체 제거합니다. 그리고
    for (var tagImages in state.tagImage) {
      List<Tag> newTags = List.from(tagImages.tag)..remove(tag);
      if (newTags.isNotEmpty) {
        newTagImage.add(TagImages(index: tagImages.index, tag: newTags));
      }
    }

    // 새로운 태그 이미지로 상태를 업데이트하고, offsetCount를 1개 감소시킵니다.
    state = state.copyWith(
        tagImage: newTagImage, offsetCount: state.offsetCount - 1);
  }

  //이미지를 삭제하면서 해당 이미지에 연결된 모든 태그를 함께 삭제
  void removeTagsFromImage(int imageIndex) {
    List<TagImages> newTagImage = List.from(state.tagImage);
    newTagImage.removeWhere((tagImage) => tagImage.index == imageIndex);

    // 이미지 인덱스보다 큰 모든 태그 이미지의 인덱스를 1 감소시킵니다.
    for (var i = 0; i < newTagImage.length; i++) {
      if (newTagImage[i].index > imageIndex) {
        newTagImage[i] =
            newTagImage[i].copyWith(index: newTagImage[i].index - 1);
      }
    }

    // 새로운 태그 이미지로 상태를 업데이트합니다.
    state = state.copyWith(tagImage: newTagImage);
  }
}
