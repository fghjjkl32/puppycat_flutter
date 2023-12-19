import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/chat/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_favorite_state_provider.g.dart';

final chatFavoriteListEmptyProvider = StateProvider<bool>((ref) => true);

@Riverpod(keepAlive: true)
class ChatFavoriteState extends _$ChatFavoriteState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  late final ChatRepository _chatRepository = ChatRepository(dio: ref.read(dioProvider));

  @override
  PagingController<int, ChatFavoriteModel> build() {
    PagingController<int, ChatFavoriteModel> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      var chatFavoriteDataListModel = await _chatRepository.getChatFavoriteMembers(page: pageKey);
      final chatFavoriteList = chatFavoriteDataListModel.list;
      final pagination = chatFavoriteDataListModel.params.pagination;

      try {
        _lastPage = pagination?.totalPageCount! ?? 0;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = chatFavoriteList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(chatFavoriteList);
      } else {
        state.appendPage(chatFavoriteList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
      ref.read(chatFavoriteListEmptyProvider.notifier).state = state.itemList?.isEmpty ?? true;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  Future<bool> favoriteChatMember({
    required String targetMemberUuid,
    required bool isFavorite,
  }) async {
    try {
      final favoriteResult = await _chatRepository.favoriteChatMember(targetMemberUuid: targetMemberUuid, isFavorite: isFavorite);

      if (favoriteResult) {
        state.refresh();
      }

      return favoriteResult;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      return false;
    } catch (e) {
      print('pinChatRoom Error $e');
      return false;
    }
  }
}
