import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/follow/follow_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/follow/follow_state.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/follow/follow_repository.dart';
import 'package:rxdart/rxdart.dart';

class FollowUserStateNotifier extends StateNotifier<Map<String, bool>> {
  final Ref ref;

  FollowUserStateNotifier(this.ref) : super({});

  Map<String, bool> _initialFollowStates = {}; // 초기 상태를 저장할 맵

  void setFollowState(String memberUuid, bool followState) {
    //상태 변경
    state = {...state, memberUuid: followState};

    // 초기 상태가 설정되지 않았으면 현재 상태를 저장합니다.
    _initialFollowStates.putIfAbsent(memberUuid, () => followState);

    EasyDebounce.debounce(
      'setFollowState',
      const Duration(
        milliseconds: 500,
      ),
      () async {
        // 초기 상태와 현재 상태가 다른 경우에만 API 호출
        if (_initialFollowStates[memberUuid] != followState) {
          if (followState) {
            // 팔로우 API 호출
            await ref.read(followStateProvider.notifier).postFollow(followUuid: memberUuid);
            print("팔로우 API 호출");
          } else {
            // 언팔로우 API 호출
            await ref.read(followStateProvider.notifier).deleteFollow(followUuid: memberUuid);
            print("언팔로우 API 호출");
          }
          // API 호출 후 초기 상태 업데이트
          _initialFollowStates[memberUuid] = followState;
        }
      },
    );
  }

  void resetState() {
    state = {};
  }

  bool? getFollowState(String memberUuid) {
    return state[memberUuid];
  }
}

final followUserStateProvider = StateNotifierProvider<FollowUserStateNotifier, Map<String, bool>>(
  (ref) => FollowUserStateNotifier(ref),
);

final followStateProvider = StateNotifierProvider<FollowStateNotifier, FollowState>((ref) {
  return FollowStateNotifier(ref);
});

class FollowStateNotifier extends StateNotifier<FollowState> {
  final Ref ref;

  FollowStateNotifier(this.ref)
      : super(FollowState(
          followerListState: const FollowDataListModel(),
          followListState: const FollowDataListModel(),
        )) {
    followerSearchQuery.stream.debounceTime(const Duration(milliseconds: 500)).listen((query) async {
      await searchFollowerList(query.$1, query.$2);
    });
    followSearchQuery.stream.debounceTime(const Duration(milliseconds: 500)).listen((query) async {
      await searchFollowList(query.$1, query.$2);
    });
  }

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

  initFollowerList({
    required String memberUuid,
    int? initPage,
  }) async {
    followerCurrentPage = 1;

    final page = initPage ?? state.followerListState.page;

    try {
      final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowerList(memberUuid: memberUuid, page: page);

      followerMaxPages = lists.params!.pagination?.endPage ?? 0;

      state = state.copyWith(followerListState: state.followerListState.copyWith(totalCount: lists.params!.pagination?.totalRecordCount! ?? 0));

      if (lists == null) {
        state = state.copyWith(followerListState: state.followerListState.copyWith(page: page, isLoading: false));
        return;
      }

      state = state.copyWith(followerListState: state.followerListState.copyWith(page: page, isLoading: false, list: lists.list));
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('initFloowerList error $e');
    }
  }

  loadMoreFollowerList(String memberUuid) async {
    try {
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
          memberUuid: memberUuid,
          page: searchFollowerCurrentPage + 1,
          searchWord: followerSearchWord,
        );

        if (lists == null) {
          state = state.copyWith(followerListState: state.followerListState.copyWith(isLoadMoreError: true, isLoading: false));
          return;
        }

        if (lists.list.isNotEmpty) {
          state = state.copyWith(
            followerListState: state.followerListState.copyWith(
              isLoading: false,
              list: [...state.followerListState.list, ...lists.list],
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
          memberUuid: memberUuid,
          page: state.followerListState.page + 1,
        );

        if (lists == null) {
          state = state.copyWith(followerListState: state.followerListState.copyWith(isLoadMoreError: true, isLoading: false));
          return;
        }

        if (lists.list.isNotEmpty) {
          state = state.copyWith(
            followerListState: state.followerListState.copyWith(
              page: state.followerListState.page + 1,
              isLoading: false,
              list: [...state.followerListState.list, ...lists.list],
            ),
          );
          followerCurrentPage++;
        } else {
          state = state.copyWith(followerListState: state.followerListState.copyWith(isLoading: false));
        }
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('loadMoreFollowerList error $e');
    }
  }

  Future<void> refreshFollowerList(String memberUuid) async {
    initFollowerList(memberUuid: memberUuid, initPage: 1);
    followerCurrentPage = 1;
  }

  initFollowList({
    required String memberUuid,
    int? initPage,
  }) async {
    followCurrentPage = 1;

    final page = initPage ?? state.followListState.page;

    try {
      final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowList(
        memberUuid: memberUuid,
        page: page,
      );

      followMaxPages = lists.params!.pagination?.endPage ?? 0;

      state = state.copyWith(followListState: state.followListState.copyWith(totalCount: lists.params!.pagination?.totalRecordCount! ?? 0));

      if (lists == null) {
        state = state.copyWith(followListState: state.followListState.copyWith(page: page, isLoading: false));
        return;
      }

      state = state.copyWith(followListState: state.followListState.copyWith(page: page, isLoading: false, list: lists.list));
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('initFollowList error $e');
    }
  }

  loadMoreFollowList(String memberUuid) async {
    try {
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
          memberUuid: memberUuid,
          page: searchFollowCurrentPage + 1,
          searchWord: followSearchWord,
        );

        if (lists == null) {
          state = state.copyWith(followListState: state.followListState.copyWith(isLoadMoreError: true, isLoading: false));
          return;
        }

        if (lists.list.isNotEmpty) {
          state = state.copyWith(
            followListState: state.followListState.copyWith(
              isLoading: false,
              list: [...state.followListState.list, ...lists.list],
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
          memberUuid: memberUuid,
          page: state.followListState.page + 1,
        );

        if (lists == null) {
          state = state.copyWith(followListState: state.followListState.copyWith(isLoadMoreError: true, isLoading: false));
          return;
        }

        if (lists.list.isNotEmpty) {
          state = state.copyWith(
            followListState: state.followListState.copyWith(
              page: state.followListState.page + 1,
              isLoading: false,
              list: [...state.followListState.list, ...lists.list],
            ),
          );
          followCurrentPage++;
        } else {
          state = state.copyWith(followListState: state.followListState.copyWith(isLoading: false));
        }
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('loadMoreFollowList error $e');
    }
  }

  final followerSearchQuery = PublishSubject<(String, String)>();
  final followSearchQuery = PublishSubject<(String, String)>();

  Future<void> searchFollowerList(String memberUuid, String searchWord) async {
    followerSearchWord = searchWord;
    isFollowerSearching = true;
    searchFollowerCurrentPage = 1;

    try {
      final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowerSearchList(
        memberUuid: memberUuid,
        page: 1,
        searchWord: searchWord,
      );

      if (lists == null) {
        state = state.copyWith(followerListState: state.followerListState.copyWith(page: 1, isLoading: false, list: []));
        return;
      }

      state = state.copyWith(followerListState: state.followerListState.copyWith(page: 1, isLoading: false, list: lists.list));
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('searchFollowerList error $e');
    }
  }

  Future<void> searchFollowList(String memberUuid, String searchWord) async {
    followSearchWord = searchWord;
    isFollowSearching = true;
    searchFollowCurrentPage = 1;

    try {
      final lists = await FollowRepository(dio: ref.read(dioProvider)).getFollowSearchList(
        memberUuid: memberUuid,
        page: 1,
        searchWord: searchWord,
      );

      if (lists == null) {
        state = state.copyWith(followListState: state.followListState.copyWith(page: 1, isLoading: false, list: []));
        return;
      }

      state = state.copyWith(followListState: state.followListState.copyWith(page: 1, isLoading: false, list: lists.list));
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('searchFollowList error $e');
    }
  }

  Future<ResponseModel> postFollow({
    required String followUuid,
  }) async {
    try {
      final result = await FollowRepository(dio: ref.read(dioProvider)).postFollow(followUuid: followUuid);

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);

      throw apiException.toString();
    } catch (e) {
      print('postFollow error $e');
      rethrow;
    }
  }

  Future<ResponseModel> deleteFollow({
    required String followUuid,
  }) async {
    try {
      final result = await FollowRepository(dio: ref.read(dioProvider)).deleteFollow(followUuid: followUuid);

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);

      throw apiException.toString();
    } catch (e) {
      print('deleteFollow error $e');
      rethrow;
    }
  }

  Future<ResponseModel> deleteFollower({
    required String followUuid,
  }) async {
    try {
      final result = await FollowRepository(dio: ref.read(dioProvider)).deleteFollower(followUuid: followUuid);

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);

      throw apiException.toString();
    } catch (e) {
      print('deleteFollower error $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    followerSearchQuery.close();
    followSearchQuery.close();
    super.dispose();
  }
}
