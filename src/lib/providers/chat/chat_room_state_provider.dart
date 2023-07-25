import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrix/matrix.dart';
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_room_state_provider.g.dart';

final chatRoomListStreamProvider = StateProvider<Stream>((ref) => (ref.read(chatControllerProvider('matrix')) as MatrixChatClientController).getRoomListStream());
final chatReplyProvider = StateProvider<ChatMessageModel?>((ref) => null);
final chatEditProvider = StateProvider<ChatMessageModel?>((ref) => null);
final chatDeleteProvider = StateProvider<ChatMessageModel?>((ref) => null);

// final chatRoomPinProvider = StateProvider<ChatRoomModel?>((ref) => null);
// final chatBubbleFocusProvider = StateProvider<ChatMessageModel?>((ref) => null);
final chatBubbleFocusProvider = StateProvider<int>((ref) => 0);

@Riverpod(keepAlive: true)
class ChatRoomState extends _$ChatRoomState {
  @override
  List<Room> build() {
    return [];
  }

}
