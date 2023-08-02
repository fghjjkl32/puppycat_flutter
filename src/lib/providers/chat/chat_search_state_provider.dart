import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrix/matrix.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_search_state_provider.g.dart';

@Riverpod(keepAlive: true)
class ChatSearchState extends _$ChatSearchState {
  @override
  List<ChatFavoriteModel> build() {
    return [];
  }

}
