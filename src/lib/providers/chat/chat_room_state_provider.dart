import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrix/matrix.dart';
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_room_state_provider.g.dart';

final chatRoomListStreamProvider = StateProvider<Stream>((ref) => (ref.read(chatControllerProvider('matrix')) as MatrixChatClientController).getRoomListStream());

@Riverpod(keepAlive: true)
class ChatRoomState extends _$ChatRoomState {
  @override
  List<Room> build() {
    return [];
  }

  void listenRoomState() {
     print('runnnnnn???');
    var chatClient = (ref.read(chatControllerProvider('matrix')) as MatrixChatClientController).client;
    Stream chatStream = chatClient.onSync.stream;
    chatStream.listen((event) {
       print('aaa');
      List<Room> roomList = chatClient.rooms;
      List<Room> joinedRoomList = roomList.where((e) => e.membership == Membership.join).toList();
      // List<Room> invitationRoomList = roomList.where((e) => e.membership == Membership.invite).toList();
      // for (var element in invitationRoomList) {
      //   if (element.membership != Membership.invite) {
      //     return;
      //   }
      //   final waitForRoom = element.client.waitForRoomInSync(
      //     element.id,
      //     join: true,
      //   );
      //   await element.join();
      //   await waitForRoom;
      // }

      state = joinedRoomList;
    });
  }

}
