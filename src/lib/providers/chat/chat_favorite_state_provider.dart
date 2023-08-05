import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/repositories/chat/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_favorite_state_provider.g.dart';

final chatFavoriteStatusChangedProvider = StateProvider<bool>((ref) => false);

@Riverpod(keepAlive: true)
class ChatFavoriteState extends _$ChatFavoriteState {
  @override
  List<ChatFavoriteModel> build() {
    return [];
  }

  void getChatFavorite(int memberIdx) async {
    ChatRepository chatRepository = ref.read(chatRepositoryProvider);

    state = await chatRepository.getChatFavorite(memberIdx);
    ref.read(chatFavoriteStatusChangedProvider.notifier).state = false;
  }

  Future<bool> setChatFavorite(int memberIdx, String chatMemberId) async {
    ChatRepository chatRepository = ref.read(chatRepositoryProvider);

    bool result = await chatRepository.setChatFavorite(memberIdx, chatMemberId);

    getChatFavorite(memberIdx);
    ref.read(chatFavoriteStatusChangedProvider.notifier).state = result;
    return result;
  }

  Future<bool> unSetChatFavorite(int memberIdx, String chatMemberId) async {
    ChatRepository chatRepository = ref.read(chatRepositoryProvider);

    bool result = await chatRepository.unSetChatFavorite(memberIdx, chatMemberId);

    getChatFavorite(memberIdx);
    ref.read(chatFavoriteStatusChangedProvider.notifier).state = result;
    return result;
  }
}
