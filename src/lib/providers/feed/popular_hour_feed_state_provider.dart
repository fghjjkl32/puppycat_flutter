import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/feed/feed_repository.dart';
import 'package:riverpod/riverpod.dart';

final popularHourFeedStateProvider = StateNotifierProvider<PopularHourFeedStateNotifier, FeedDataListModel>((ref) {
  return PopularHourFeedStateNotifier(ref);
});

class PopularHourFeedStateNotifier extends StateNotifier<FeedDataListModel> {
  PopularHourFeedStateNotifier(this.ref) : super(const FeedDataListModel());

  final Ref ref;

  initPosts() async {
    try {
      final lists = await FeedRepository(dio: ref.read(dioProvider)).getPopularHourDetailList(
        page: 1,
      );
      state = state.copyWith(totalCount: lists.data!.params!.pagination?.totalRecordCount! ?? 0);

      if (lists == null) {
        state = state.copyWith(page: 1, isLoading: false);
        return;
      }

      List<dynamic> resultList = lists.data!.list;
      List<FeedData> listData = resultList.map((e) {
        FeedData feedData = FeedData.fromJson(e);
        return feedData;
      }).toList();

      state = state.copyWith(
        page: 1,
        isLoading: false,
        list: listData,
        memberInfo: lists.data!.memberInfo,
      );
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('popular hour initPosts error $e');
    }
  }
}
