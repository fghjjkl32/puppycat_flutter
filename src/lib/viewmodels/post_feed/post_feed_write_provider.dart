import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag_images.dart';

final postFeedWriteProvider =
    StateNotifierProvider<PostFeedWriteNotifier, PostFeedState>((ref) {
  return PostFeedWriteNotifier();
});

class PostFeedWriteNotifier extends StateNotifier<PostFeedState> {
  PostFeedWriteNotifier()
      : super(PostFeedState(tagList: [], tagImage: [], offsetCount: 0));

  void addTag(Tag tag, int imageIndex, BuildContext context) {
    List<TagImages> newTagImage = List.from(state.tagImage);
    int existingIndex = -1;

    for (int i = 0; i < newTagImage.length; i++) {
      if (newTagImage[i].index == imageIndex) {
        existingIndex = i;
        break;
      }
    }

    if (existingIndex != -1) {
      List<Tag> newTags = List.from(newTagImage[existingIndex].tag)..add(tag);
      newTagImage[existingIndex] =
          newTagImage[existingIndex].copyWith(tag: newTags);
    } else {
      newTagImage.add(TagImages(index: imageIndex, tag: [tag]));
    }

    state = state.copyWith(
        tagImage: newTagImage, offsetCount: state.offsetCount + 1);
  }

  void saveTag() {
    state = state.copyWith(tagImage: state.tagImage);
  }

  void resetTag() {
    state = state.copyWith(tagList: [], tagImage: [], offsetCount: 0);
  }

  void removeTag(Tag tag) {
    List<TagImages> newTagImage = [];

    for (var tagImages in state.tagImage) {
      List<Tag> newTags = List.from(tagImages.tag)..remove(tag);
      if (newTags.isNotEmpty) {
        newTagImage.add(TagImages(index: tagImages.index, tag: newTags));
      }
    }

    state = state.copyWith(
        tagImage: newTagImage, offsetCount: state.offsetCount - 1);
  }

  void removeTagsFromImage(int imageIndex) {
    List<TagImages> newTagImage = List.from(state.tagImage);
    newTagImage.removeWhere((tagImage) => tagImage.index == imageIndex);

    for (var i = 0; i < newTagImage.length; i++) {
      if (newTagImage[i].index > imageIndex) {
        newTagImage[i] =
            newTagImage[i].copyWith(index: newTagImage[i].index - 1);
      }
    }

    state = state.copyWith(tagImage: newTagImage);
  }
}
