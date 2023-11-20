import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:matrix/matrix.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_list_item_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/comment/comment_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/follow/follow_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/notification/notification_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/policy/policy_repository.dart';
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

      // NotificationRepository repository = ref.read(notificationRepositoryProvider);
      NotificationRepository repository = NotificationRepository(dio: ref.read(dioProvider));
      var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;
      int type = _notiType.index;
      var result = await repository.getNotifications(loginMemberIdx, pageKey, type == 0 ? null : type);

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
        _lastPage = result.params!.pagination!.totalPageCount!;
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
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void setNotificationType(NotificationType type) {
    _notiType = type;
    state.refresh();
  }

  void setFeedLike(int memberIdx, int contentsIdx) async {
    ref.read(likeApiIsLoadingStateProvider.notifier).state = true;

    final result = await FeedRepository(dio: ref.read(dioProvider)).postLike(memberIdx: memberIdx, contentIdx: contentsIdx);
    if (result.result) {
      changedLikeState(contentsIdx, true);
    }
    ref.read(likeApiIsLoadingStateProvider.notifier).state = false;
  }

  void unSetFeedLike(int memberIdx, int contentsIdx) async {
    ref.read(likeApiIsLoadingStateProvider.notifier).state = true;

    final result = await FeedRepository(dio: ref.read(dioProvider)).deleteLike(memberIdx: memberIdx, contentsIdx: contentsIdx);
    if (result.result) {
      changedLikeState(contentsIdx, false);
    }
    ref.read(likeApiIsLoadingStateProvider.notifier).state = false;
  }

  void setFollow(int memberIdx, int followIdx) async {
    ref.read(followApiIsLoadingStateProvider.notifier).state = true;

    final result = await FollowRepository(dio: ref.read(dioProvider)).postFollow(memberIdx: memberIdx, followIdx: followIdx);
    if (result.result) {
      changedFollowState(followIdx, true);
    }
    ref.read(followApiIsLoadingStateProvider.notifier).state = false;
  }

  void unSetFollow(int memberIdx, int followIdx) async {
    ref.read(followApiIsLoadingStateProvider.notifier).state = true;

    final result = await FollowRepository(dio: ref.read(dioProvider)).deleteFollow(memberIdx: memberIdx, followIdx: followIdx);
    if (result.result) {
      changedFollowState(followIdx, false);
    }
    ref.read(followApiIsLoadingStateProvider.notifier).state = false;
  }

  void setCommentLike(int memberIdx, int commentIdx) async {
    final result = await CommentRepository(dio: ref.read(dioProvider)).postCommentLike(memberIdx: memberIdx, commentIdx: commentIdx);
    if (result.result) {
      changedLikeState(commentIdx, true);
    }
  }

  void unSetCommentLike(int memberIdx, int commentIdx) async {
    final result = await CommentRepository(dio: ref.read(dioProvider)).deleteCommentLike(memberIdx: memberIdx, commentIdx: commentIdx);

    if (result.result) {
      changedLikeState(commentIdx, false);
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

  void changedFollowState(int followIdx, bool isFollow) {
    state.itemList = state.itemList!.map((e) {
      if (e.senderIdx != followIdx) {
        return e;
      }
      return e.copyWith(
        followState: isFollow ? 1 : 0,
      );
    }).toList();
    state.notifyListeners();
  }
}

//
// @Riverpod(keepAlive: true)
// class NotificationListState extends _$NotificationListState {
//   @override
//   List<NotificationListItemModel> build() {
//     return [];
//   }
//
//   void getNotifications() async {
//     final NotificationRepository notificationRepository = NotificationRepository();
//     try {
//       var memberIdx = ref.read(userInfoProvider).userModel!.idx;
//       var result = await notificationRepository.getNotifications(memberIdx);
//       state = result;
//       print('notification list $result');
//     } catch (e) {
//       print('get Notification List Error - $e');
//       state = [];
//     }
//   }
//
// }
