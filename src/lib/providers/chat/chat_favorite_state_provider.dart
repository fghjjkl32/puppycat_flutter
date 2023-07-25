import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/repositories/chat/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_favorite_state_provider.g.dart';

@Riverpod(keepAlive: true)
class ChatFavoriteState extends _$ChatFavoriteState {
  @override
  List<ChatFavoriteModel> build() {
    return [];
  }

  void getChatFavorite() async {
    ChatRepository chatRepository = ChatRepository();
    state = await chatRepository.getChatFavorite();
  }

}
