import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_list_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/comment/comment_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/follow/follow_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/notification/notification_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_list_state_provider.g.dart';

enum NotiSubType {
  follow,
  new_contents,
  mention_contents,
  img_tag,
  like_contents,
  new_comment,
  mention_comment,
  new_reply,
  like_comment,
  notice,
  event,
}

enum NotificationType {
  all,
  activity,
  notice,

  ///NOTE
  ///2023.11.14.
  ///산책하기 보류로 주석 처리
  // walk,
  ///산책하기 보류로 주석 처리 완료
}

final notificationFirstVisitProvider = StateProvider<bool>((ref) => false);

@Riverpod(keepAlive: true)
class NotificationListState extends _$NotificationListState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  NotificationType _notiType = NotificationType.all;

  @override
  PagingController<int, NotificationListItemModel> build() {
    PagingController<int, NotificationListItemModel> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      try {
        // NotificationRepository repository = ref.read(notificationRepositoryProvider);
        NotificationRepository repository = NotificationRepository(dio: ref.read(dioProvider));
        int type = _notiType.index;
        var result = await repository.getNotifications(pageKey, type == 0 ? null : type);

        var resultList = result.list.map((e) {
          if (e.senderInfo == null) {
            return e;
          }
          try {
            return e.copyWith(
              senderInfo: [e.senderInfo!.first.copyWith(profileImgUrl: '${e.senderInfo!.first.profileImgUrl}')],
              img: '${e.img}',
            );
          } catch (_) {
            return e;
          }
        }).toList();

        if (result.isFirst != null) {
          print('result.isFirst');
          ref.read(notificationFirstVisitProvider.notifier).state = true; //result.isFirst!;
        }

        print('resultList $resultList');
        //result.list.first.mentionMemberInfo.first['ko10bd036fcdcb4aad9989296f340f54cc1688623039'].first['nick']
        try {
          _lastPage = result.params!.pagination?.totalPageCount! ?? 0;
        } catch (_) {
          _lastPage = 1;
        }

        final nextPageKey = resultList.isEmpty ? null : pageKey + 1;

        if (pageKey == _lastPage) {
          state.appendLastPage(resultList);
        } else {
          state.appendPage(resultList, nextPageKey);
        }
        _apiStatus = ListAPIStatus.loaded;
      } catch (e) {
        print("errorrr ${e}");
        _apiStatus = ListAPIStatus.error;
        state.error = e;
      }
    } on APIException catch (apiException) {
      print("error ${apiException}");

      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      _apiStatus = ListAPIStatus.error;
      state.error = apiException.toString();
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void setNotificationType(NotificationType type) {
    _notiType = type;
    state.refresh();
  }

  void setFeedLike(int contentsIdx) async {
    ref.read(likeApiIsLoadingStateProvider.notifier).state = true;

    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).postLike(contentIdx: contentsIdx);
      if (result.result) {
        changedLikeState(contentsIdx, true);
      }
      ref.read(likeApiIsLoadingStateProvider.notifier).state = false;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      ref.read(likeApiIsLoadingStateProvider.notifier).state = false;
    } catch (e) {
      ref.read(likeApiIsLoadingStateProvider.notifier).state = false;
      print('notification setFeedLike error $e');
    }
  }

  void unSetFeedLike(int contentsIdx) async {
    ref.read(likeApiIsLoadingStateProvider.notifier).state = true;

    try {
      final result = await FeedRepository(dio: ref.read(dioProvider)).deleteLike(contentsIdx: contentsIdx);
      if (result.result) {
        changedLikeState(contentsIdx, false);
      }
      ref.read(likeApiIsLoadingStateProvider.notifier).state = false;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      ref.read(likeApiIsLoadingStateProvider.notifier).state = false;
    } catch (e) {
      print('notification unSetFeedLike error $e');
      ref.read(likeApiIsLoadingStateProvider.notifier).state = false;
    }
  }

  void setFollow(String followUuid) async {
    try {
      ref.read(followApiIsLoadingStateProvider.notifier).state = true;

      final result = await FollowRepository(dio: ref.read(dioProvider)).postFollow(followUuid: followUuid);
      if (result.result) {
        changedFollowState(followUuid, true);
      }
      ref.read(followApiIsLoadingStateProvider.notifier).state = false;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      ref.read(followApiIsLoadingStateProvider.notifier).state = false;
    } catch (e) {
      print('setFollow error $e');
      ref.read(followApiIsLoadingStateProvider.notifier).state = false;
    }
  }

  void unSetFollow(String followUuid) async {
    try {
      ref.read(followApiIsLoadingStateProvider.notifier).state = true;

      final result = await FollowRepository(dio: ref.read(dioProvider)).deleteFollow(followUuid: followUuid);
      if (result.result) {
        changedFollowState(followUuid, false);
      }
      ref.read(followApiIsLoadingStateProvider.notifier).state = false;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      ref.read(followApiIsLoadingStateProvider.notifier).state = false;
    } catch (e) {
      print('unSetFollow error $e');
      ref.read(followApiIsLoadingStateProvider.notifier).state = false;
    }
  }

  void setCommentLike(int commentIdx) async {
    try {
      final result = await CommentRepository(dio: ref.read(dioProvider)).postCommentLike(commentIdx: commentIdx);
      if (result.result) {
        changedLikeState(commentIdx, true);
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('setCommentLike error $e');
      rethrow;
    }
  }

  void unSetCommentLike(int commentIdx) async {
    try {
      final result = await CommentRepository(dio: ref.read(dioProvider)).deleteCommentLike(commentIdx: commentIdx);

      if (result.result) {
        changedLikeState(commentIdx, false);
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('unSetCommentLike error $e');
      rethrow;
    }
  }

  void changedLikeState(int contentsIdx, bool isLike) {
    state.itemList = state.itemList!.map((e) {
      if (e.contentsIdx != contentsIdx) {
        return e;
      }
      return e.copyWith(
        contentsLikeState: isLike ? 1 : 0,
      );
    }).toList();
    state.notifyListeners();
  }

  void changedFollowState(String followUuid, bool isFollow) {
    state.itemList = state.itemList!.map((e) {
      if (e.senderUuid != followUuid) {
        return e;
      }
      return e.copyWith(
        followState: isFollow ? 1 : 0,
      );
    }).toList();
    state.notifyListeners();
  }
}
