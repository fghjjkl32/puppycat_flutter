import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/keep_contents/keep_contents_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'first_feed_detail_state_provider.g.dart';

final firstFeedEmptyProvider = StateProvider<bool>((ref) => true);

final firstFeedStatusProvider = StateProvider<ListAPIStatus>((ref) => ListAPIStatus.idle);

@Riverpod(keepAlive: true)
class FirstFeedDetailState extends _$FirstFeedDetailState {
  String? feedImgDomain;
  MemberInfoListData? memberInfo;
  final Map<String, FeedData?> firstFeedStateMap = {};
  final Map<String, MemberInfoListData?> firstFeedMemberInfoStateMap = {};

  @override
  FeedData? build() {
    return null;
  }

  Future<FeedData?> getFirstFeedState(String contentType, int contentIdx) async {
    try {
      Future(() {
        ref.read(firstFeedStatusProvider.notifier).state = ListAPIStatus.loading;
      });

      FeedResponseModel searchResult = feedNullResponseModel;

      if (contentType == "myContent" || contentType == "myDetailContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getMyContentsDetail(contentIdx: contentIdx);
      } else if (contentType == "myTagContent" ||
          contentType == "userTagContent" ||
          contentType == "userContent" ||
          contentType == "FollowCardContent" ||
          contentType == "myLikeContent" ||
          contentType == "mySaveContent" ||
          contentType == "searchContent" ||
          contentType == "popularWeekContent" ||
          contentType == "popularHourContent" ||
          contentType == "notificationContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(contentIdx: contentIdx);
      } else if (contentType == "myKeepContent") {
        searchResult = await KeepContentsRepository(dio: ref.read(dioProvider)).getMyKeepContentDetail(contentIdx: contentIdx);
      }

      bool isResponseDataEmpty = searchResult.data!.list.isEmpty;
      ref.read(firstFeedEmptyProvider.notifier).state = isResponseDataEmpty;
      memberInfo = searchResult.data!.memberInfo?.first;
      feedImgDomain = searchResult.data!.imgDomain;

      Future(() {
        ref.read(firstFeedStatusProvider.notifier).state = ListAPIStatus.loaded;
      });
      if (!isResponseDataEmpty) {
        FeedData firstFeed = searchResult.data!.list.first;
        state = firstFeed;
        return firstFeed;
      } else {
        state = null;
        return null;
      }
    } on APIException catch (apiException) {
      Future(() {
        ref.read(firstFeedStatusProvider.notifier).state = ListAPIStatus.error;
      });
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = null;
    } catch (e) {
      Future(() {
        ref.read(firstFeedStatusProvider.notifier).state = ListAPIStatus.error;
      });
      print('fetchFirstFeedState error $e');
      state = null;
    }
    return null;
  }

  void getStateForUser(String memberUuid) {
    memberInfo = firstFeedMemberInfoStateMap[memberUuid] ?? MemberInfoListData();

    state = firstFeedStateMap[memberUuid] ?? FeedData(idx: 0);
  }

  void saveStateForUser(String memberUuid) {
    firstFeedStateMap[memberUuid] = state;
    firstFeedMemberInfoStateMap[memberUuid] = memberInfo;
  }
}
