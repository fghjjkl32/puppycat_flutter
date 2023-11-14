import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_state.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/follow/follow_repository.dart';
import 'package:rxdart/rxdart.dart';

final followApiIsLoadingStateProvider = StateProvider<bool>((ref) => false);

class FollowUserStateNotifier extends StateNotifier<Map<int, bool>> {
  FollowUserStateNotifier() : super({});

  void setFollowState(int memberIdx, bool followState) {
    state = {...state, memberIdx: followState};
  }

  void resetState() {
    state = {};
  }

  bool? getFollowState(int memberIdx) {
    return state[memberIdx];
  }
}

final followUserStateProvider = StateNotifierProvider<FollowUserStateNotifier, Map<int, bool>>(
  (ref) => FollowUserStateNotifier(),
);

final followStateProvider = StateNotifierProvider<FollowStateNotifier, FollowState>((ref) {
  final loginMemberIdx = ref.watch(userInfoProvider).userModel!.idx;
  return FollowStateNotifier(loginMemberIdx, ref);
});

class FollowStateNotifier extends StateNotifier<FollowState> {
  final int loginMemberIdx;
  final Ref ref;

  FollowStateNotifier(this.loginMemberIdx, this.ref)
      : super(FollowState(
          followerListState: const FollowDataListModel(),
          followListState: const FollowDataListModel(),
        )) {
    followerSearchQuery.stream.debounceTime(const Duration(milliseconds: 500)).listen((query) async {
      await searchFollowerList(query);
    });
    followSearchQuery.stream.debounceTime(const Duration(milliseconds: 500)).listen((query) async {
      await searchFollowList(query);
    });
  }

  int userMemberIdx = 0;

  int followerMaxPages = 1;
  int followerCurrentPage = 1;
  int followMaxPages = 1;
  int followCurrentPage = 1;

  bool isFollowerSearching = false;
  String followerSearchWord = '';
  int searchFollowerCurrentPage = 1;

  bool isFollowSearching = false;
  String followSearchWord = '';
  int searchFollowCurrentPage = 1;

  initFollowerList([memberIdx, int? initPage]) async {
    followerCurrentPage = 1;

    final page = initPage ?? state.followerListState.page;
    final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowerList(memberIdx: memberIdx, page: page, loginMemberIdx: loginMemberIdx);

    followerMaxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(followerListState: state.followerListState.copyWith(totalCount: lists.data.params!.pagination!.totalRecordCount!));

    if (lists == null) {
      state = state.copyWith(followerListState: state.followerListState.copyWith(page: page, isLoading: false));
      return;
    }

    state = state.copyWith(followerListState: state.followerListState.copyWith(page: page, isLoading: false, list: lists.data.list));
  }

  loadMoreFollowerList(memberIdx) async {
    if (isFollowerSearching) {
      if (searchFollowerCurrentPage >= followerMaxPages) {
        state = state.copyWith(followerListState: state.followerListState.copyWith(isLoadMoreDone: true));
        return;
      }

      StringBuffer bf = StringBuffer();

      bf.write('try to request loading ${state.followerListState.isLoading} at ${state.followerListState.page + 1}');
      if (state.followerListState.isLoading) {
        bf.write(' fail');
        return;
      }
      bf.write(' success');

      state = state.copyWith(followerListState: state.followerListState.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false));

      final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowerSearchList(
        memberIdx: memberIdx,
        page: searchFollowerCurrentPage + 1,
        searchWord: followerSearchWord,
        loginMemberIdx: loginMemberIdx,
      );

      if (lists == null) {
        state = state.copyWith(followerListState: state.followerListState.copyWith(isLoadMoreError: true, isLoading: false));
        return;
      }

      if (lists.data.list.isNotEmpty) {
        state = state.copyWith(
          followerListState: state.followerListState.copyWith(
            isLoading: false,
            list: [...state.followerListState.list, ...lists.data.list],
          ),
        );
        searchFollowerCurrentPage++;
      } else {
        state = state.copyWith(followerListState: state.followerListState.copyWith(isLoading: false));
      }
    } else {
      if (followerCurrentPage >= followerMaxPages) {
        state = state.copyWith(followerListState: state.followerListState.copyWith(isLoadMoreDone: true));
        return;
      }

      StringBuffer bf = StringBuffer();

      bf.write('try to request loading ${state.followerListState.isLoading} at ${state.followerListState.page + 1}');
      if (state.followerListState.isLoading) {
        bf.write(' fail');
        return;
      }
      bf.write(' success');

      state = state.copyWith(followerListState: state.followerListState.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false));

      final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowerList(
        memberIdx: memberIdx,
        page: state.followerListState.page + 1,
        loginMemberIdx: loginMemberIdx,
      );

      if (lists == null) {
        state = state.copyWith(followerListState: state.followerListState.copyWith(isLoadMoreError: true, isLoading: false));
        return;
      }

      if (lists.data.list.isNotEmpty) {
        state = state.copyWith(
          followerListState: state.followerListState.copyWith(
            page: state.followerListState.page + 1,
            isLoading: false,
            list: [...state.followerListState.list, ...lists.data.list],
          ),
        );
        followerCurrentPage++;
      } else {
        state = state.copyWith(followerListState: state.followerListState.copyWith(isLoading: false));
      }
    }
  }

  Future<void> refreshFollowerList(memberIdx) async {
    initFollowerList(memberIdx, 1);
    followerCurrentPage = 1;
  }

  initFollowList([memberIdx, int? initPage]) async {
    followCurrentPage = 1;

    final page = initPage ?? state.followListState.page;
    final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowList(
      memberIdx: memberIdx,
      page: page,
      loginMemberIdx: loginMemberIdx,
    );

    followMaxPages = lists.data.params!.pagination!.endPage!;

    state = state.copyWith(followListState: state.followListState.copyWith(totalCount: lists.data.params!.pagination!.totalRecordCount!));

    if (lists == null) {
      state = state.copyWith(followListState: state.followListState.copyWith(page: page, isLoading: false));
      return;
    }

    state = state.copyWith(followListState: state.followListState.copyWith(page: page, isLoading: false, list: lists.data.list));
  }

  loadMoreFollowList(memberIdx) async {
    if (isFollowSearching) {
      if (searchFollowCurrentPage >= followMaxPages) {
        state = state.copyWith(followListState: state.followListState.copyWith(isLoadMoreDone: true));
        return;
      }

      StringBuffer bf = StringBuffer();

      bf.write('try to request loading ${state.followListState.isLoading} at ${state.followListState.page + 1}');
      if (state.followListState.isLoading) {
        bf.write(' fail');
        return;
      }
      bf.write(' success');

      state = state.copyWith(followListState: state.followListState.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false));

      final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowSearchList(
        memberIdx: memberIdx,
        page: searchFollowCurrentPage + 1,
        searchWord: followSearchWord,
        loginMemberIdx: loginMemberIdx,
      );

      if (lists == null) {
        state = state.copyWith(followListState: state.followListState.copyWith(isLoadMoreError: true, isLoading: false));
        return;
      }

      if (lists.data.list.isNotEmpty) {
        state = state.copyWith(
          followListState: state.followListState.copyWith(
            isLoading: false,
            list: [...state.followListState.list, ...lists.data.list],
          ),
        );
        searchFollowCurrentPage++;
      } else {
        state = state.copyWith(followListState: state.followListState.copyWith(isLoading: false));
      }
    } else {
      if (followCurrentPage >= followMaxPages) {
        state = state.copyWith(followListState: state.followListState.copyWith(isLoadMoreDone: true));
        return;
      }

      StringBuffer bf = StringBuffer();

      bf.write('try to request loading ${state.followListState.isLoading} at ${state.followListState.page + 1}');
      if (state.followListState.isLoading) {
        bf.write(' fail');
        return;
      }
      bf.write(' success');

      state = state.copyWith(followListState: state.followListState.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false));

      final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowList(
        memberIdx: memberIdx,
        page: state.followListState.page + 1,
        loginMemberIdx: loginMemberIdx,
      );

      if (lists == null) {
        state = state.copyWith(followListState: state.followListState.copyWith(isLoadMoreError: true, isLoading: false));
        return;
      }

      if (lists.data.list.isNotEmpty) {
        state = state.copyWith(
          followListState: state.followListState.copyWith(
            page: state.followListState.page + 1,
            isLoading: false,
            list: [...state.followListState.list, ...lists.data.list],
          ),
        );
        followCurrentPage++;
      } else {
        state = state.copyWith(followListState: state.followListState.copyWith(isLoading: false));
      }
    }
  }

  final followerSearchQuery = PublishSubject<String>();
  final followSearchQuery = PublishSubject<String>();

  Future<void> searchFollowerList(String searchWord) async {
    followerSearchWord = searchWord;
    isFollowerSearching = true;
    searchFollowerCurrentPage = 1;

    final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowerSearchList(
      memberIdx: userMemberIdx,
      page: 1,
      searchWord: searchWord,
      loginMemberIdx: loginMemberIdx,
    );

    if (lists == null) {
      state = state.copyWith(followerListState: state.followerListState.copyWith(page: 1, isLoading: false, list: []));
      return;
    }

    state = state.copyWith(followerListState: state.followerListState.copyWith(page: 1, isLoading: false, list: lists.data.list));
  }

  Future<void> searchFollowList(String searchWord) async {
    followSearchWord = searchWord;
    isFollowSearching = true;
    searchFollowCurrentPage = 1;

    final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowSearchList(
      memberIdx: userMemberIdx,
      page: 1,
      searchWord: searchWord,
      loginMemberIdx: loginMemberIdx,
    );

    if (lists == null) {
      state = state.copyWith(followListState: state.followListState.copyWith(page: 1, isLoading: false, list: []));
      return;
    }

    state = state.copyWith(followListState: state.followListState.copyWith(page: 1, isLoading: false, list: lists.data.list));
  }

  Future<ResponseModel> postFollow({
    required memberIdx,
    required followIdx,
  }) async {
    ref.read(followApiIsLoadingStateProvider.notifier).state = true;
    final result = await FollowRepository(dio: ref.read(dioProvider)).postFollow(memberIdx: memberIdx, followIdx: followIdx);
    ref.read(followApiIsLoadingStateProvider.notifier).state = false;

    return result;
  }

  Future<ResponseModel> deleteFollow({
    required memberIdx,
    required followIdx,
  }) async {
    ref.read(followApiIsLoadingStateProvider.notifier).state = true;
    final result = await FollowRepository(dio: ref.read(dioProvider)).deleteFollow(memberIdx: memberIdx, followIdx: followIdx);
    ref.read(followApiIsLoadingStateProvider.notifier).state = false;

    return result;
  }

  Future<ResponseModel> deleteFollower({
    required memberIdx,
    required followIdx,
  }) async {
    ref.read(followApiIsLoadingStateProvider.notifier).state = true;
    final result = await FollowRepository(dio: ref.read(dioProvider)).deleteFollower(memberIdx: memberIdx, followIdx: followIdx);
    ref.read(followApiIsLoadingStateProvider.notifier).state = false;

    return result;
  }

  @override
  void dispose() {
    followerSearchQuery.close();
    followSearchQuery.close();
    super.dispose();
  }
}
