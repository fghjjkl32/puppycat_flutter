import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/keep_contents/keep_contents_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'first_feed_detail_state_provider.g.dart';

final firstFeedEmptyProvider = StateProvider<bool>((ref) => true);

final firstFeedStatusProvider = StateProvider<ListAPIStatus>((ref) => ListAPIStatus.idle);

// final firstFeedDetailFutureStateProvider = FutureProvider<FeedData?>((ref){
//   ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(contentType, contentIdx)
// });

// @Riverpod(keepAlive: true)
// Future<FeedData?> fetchFirstFeedData(String contentType, int contentIdx) async {
//   return await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(contentType, contentIdx);
// }

@Riverpod(keepAlive: true)
class FirstFeedDetailState extends _$FirstFeedDetailState {
  String? feedImgDomain;
  MemberInfoListData? memberInfo;
  final Map<int, FeedData?> firstFeedStateMap = {};
  final Map<int, MemberInfoListData?> firstFeedMemberInfoStateMap = {};

  @override
  FeedData? build() {
    return null;
  }

  Future<FeedData?> getFirstFeedState(String contentType, int contentIdx) async {
    // final userInfoModel = ref.read(userInfoProvider).userModel;
    int loginMemberIdx = 0;
    try {
      loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;
    } catch (e) {
      print('getFeedState Error $e');
      state = null;
      return null;
    }

    try {
      Future(() {
        ref.read(firstFeedStatusProvider.notifier).state = ListAPIStatus.loading;
      });

      FeedResponseModel searchResult = feedNullResponseModel;

      if (contentType == "myContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getMyContentsDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "myTagContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "userContent" || contentType == "FollowCardContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx, contentIdx: contentIdx!);
      } else if (contentType == "userTagContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "myLikeContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "mySaveContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "myDetailContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getMyContentsDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "myKeepContent") {
        searchResult = await KeepContentsRepository(dio: ref.read(dioProvider)).getMyKeepContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "searchContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "popularWeekContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "popularHourContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      } else if (contentType == "notificationContent") {
        searchResult = await FeedRepository(dio: ref.read(dioProvider)).getContentDetail(loginMemberIdx: loginMemberIdx!, contentIdx: contentIdx!);
      }

      bool isResponseDataEmpty = searchResult.data.list.isEmpty;
      ref.read(firstFeedEmptyProvider.notifier).state = isResponseDataEmpty;
      memberInfo = searchResult.data.memberInfo?.first;
      feedImgDomain = searchResult.data.imgDomain;

      Future(() {
        ref.read(firstFeedStatusProvider.notifier).state = ListAPIStatus.loaded;
      });
      if (!isResponseDataEmpty) {
        FeedData firstFeed = searchResult.data.list.first;
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

  void getStateForUser(int userId) {
    memberInfo = firstFeedMemberInfoStateMap[userId] ?? MemberInfoListData();

    state = firstFeedStateMap[userId] ?? FeedData(idx: 0);
  }

  void saveStateForUser(int userId) {
    firstFeedStateMap[userId] = state;
    firstFeedMemberInfoStateMap[userId] = memberInfo;
  }
}
