import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag_images.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/feed/feed_repository.dart';

final feedWriteProvider = StateNotifierProvider<PostFeedWriteNotifier, PostFeedState>((ref) {
  return PostFeedWriteNotifier([], ref);
});

class PostFeedWriteNotifier extends StateNotifier<PostFeedState> {
  PostFeedWriteNotifier(List<TagImages> initialTags, this.ref) : super(PostFeedState(initialTagList: initialTags, tagList: [], tagImage: [], offsetCount: 0));

  final Ref ref;

  // 이미지에 태그를 추가하는 함수입니다.
  void addTag(Tag tag, int imageIndex, BuildContext context) {
    List<TagImages> newTagImage = List.from(state.tagImage);
    int existingImageIndex = -1;

    // 이미지 인덱스를 확인하고, 해당 이미지에 이미 태그가 있으면 해당 인덱스를 저장합니다.
    for (int i = 0; i < newTagImage.length; i++) {
      if (newTagImage[i].index == imageIndex) {
        existingImageIndex = i;
        break;
      }
    }

    // 이미지에 태그가 이미 있으면, 같은 사용자 이름의 태그를 제거하고 새로운 태그를 추가합니다.
    if (existingImageIndex != -1) {
      List<Tag> newTags = List.from(newTagImage[existingImageIndex].tag);

      // find the index of the tag with the same username
      int existingTagIndex = -1;
      for (int i = 0; i < newTags.length; i++) {
        if (newTags[i].username == tag.username) {
          existingTagIndex = i;
          break;
        }
      }

      // if the tag with the same username exists, remove it
      if (existingTagIndex != -1) {
        newTags.removeAt(existingTagIndex);
      }

      newTags.add(tag);
      newTagImage[existingImageIndex] = newTagImage[existingImageIndex].copyWith(tag: newTags);
    } else {
      newTagImage.add(TagImages(index: imageIndex, tag: [tag]));
    }

    // 새로운 태그 이미지로 상태를 업데이트하고, offsetCount를 1 증가시킵니다.
    state = state.copyWith(tagImage: newTagImage, offsetCount: state.offsetCount + 1);
  }

  // 태그를 저장하는 함수입니다. 현재 상태를 그대로 저장합니다.
  void saveTag() {
    state = state.copyWith(tagImage: state.tagImage);
  }

  // 태그를 초기화하는 함수입니다.
  void resetTag() {
    state = state.copyWith(tagList: [], tagImage: [], offsetCount: 0);
    ref.watch(feedWriteCurrentTagCountProvider.notifier).state = 0;
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
    state = state.copyWith(tagImage: newTagImage, offsetCount: state.offsetCount - 1);
  }

  //이미지를 삭제하면서 해당 이미지에 연결된 모든 태그를 함께 삭제
  void removeTagsFromImage(int imageIndex) {
    List<TagImages> newTagImage = List.from(state.tagImage);
    newTagImage.removeWhere((tagImage) => tagImage.index == imageIndex);

    // 이미지 인덱스보다 큰 모든 태그 이미지의 인덱스를 1 감소시킵니다.
    for (var i = 0; i < newTagImage.length; i++) {
      if (newTagImage[i].index > imageIndex) {
        newTagImage[i] = newTagImage[i].copyWith(index: newTagImage[i].index - 1);
      }
    }

    // 새로운 태그 이미지로 상태를 업데이트합니다.
    state = state.copyWith(tagImage: newTagImage);
  }

  void updateTag(Tag oldTag, Tag newTag, int imageIndex) {
    state = state.copyWith(
      tagImage: state.tagImage.map((tagImages) {
        if (tagImages.index == imageIndex) {
          final updatedTags = tagImages.tag.map((tag) {
            if (tag == oldTag) {
              return newTag;
            } else {
              return tag;
            }
          }).toList();

          return tagImages.copyWith(tag: updatedTags);
        } else {
          return tagImages;
        }
      }).toList(),
    );
  }

  Future<ResponseModel> postFeed({
    required List<File> files,
    required int isView,
    String? location,
    String? contents,
    required PostFeedState feedState,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).postFeed(
        files: files,
        isView: isView,
        location: location,
        contents: contents,
        feedState: feedState,
      );

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('postFeed error $e');
      rethrow;
    }
  }

  Future<ResponseModel> putFeed({
    required int isView,
    String? location,
    String? contents,
    required PostFeedState feedState,
    required int contentIdx,
    required List<TagImages> initialTagList,
  }) async {
    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).putFeed(
        isView: isView,
        location: location,
        contents: contents,
        feedState: feedState,
        contentIdx: contentIdx,
        initialTagList: initialTagList,
      );

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('putFeed error $e');
      rethrow;
    }
  }

  void initializeTags(List<TagImages> initialTagImages) {
    state = state.copyWith(initialTagList: initialTagImages);
  }
}
