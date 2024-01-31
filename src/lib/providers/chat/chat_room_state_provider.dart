import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/custom_handler.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/store/channel_store.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/vo/chat_item.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/chat/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart' hide ChatRoomModel;
import 'package:web_socket_channel/web_socket_channel.dart';

part 'chat_room_state_provider.g.dart';

final chatRoomListEmptyProvider = StateProvider<bool>((ref) => false);

final chatSocketStateProvider = StateProvider<Future<WebSocketChannel>>((ref) async {
  final socket = await VChatCloud.connectSocket();
  // await ref.read(chatRoomStateProvider.notifier).initSocketStream(socket);
  return socket;
});

@Riverpod(keepAlive: true)
class ChatRoomState extends _$ChatRoomState {
  StreamSubscription? _subscription;
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  late final ChatRepository _chatRepository = ChatRepository(dio: ref.read(dioProvider));

  @override
  PagingController<int, ChatRoomModel> build() {
    PagingController<int, ChatRoomModel> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // if (_apiStatus == ListAPIStatus.loading) {
      //   return;
      // }

      _apiStatus = ListAPIStatus.loading;

      var chatRoomDataListModel = await _chatRepository.getChatRooms(page: pageKey);
      List<ChatRoomModel> chatRoomList = chatRoomDataListModel.list;
      final pagination = chatRoomDataListModel.params.pagination;

      try {
        _lastPage = pagination?.totalPageCount! ?? 0;
      } catch (_) {
        _lastPage = 1;
      }

      ///NOTE
      ///채팅 룸에 연결 및 마지막 메시지 설정
      chatRoomList = await connectRooms(chatRoomList);

      final nextPageKey = chatRoomList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(chatRoomList);
      } else {
        state.appendPage(chatRoomList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
      ref.read(chatRoomListEmptyProvider.notifier).state = state.itemList?.isEmpty ?? true;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  Future<String> createChatRoom({
    required String targetMemberUuid,
  }) async {
    try {
      final roomId = await _chatRepository.createRoom(targetMemberUuid: targetMemberUuid, maxUser: 2);
      return roomId;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      return '';
    } catch (e) {
      print('createChatRoom Error $e');
      return '';
    }
  }

  Future<bool> pinChatRoom({
    required String roomUuid,
    required bool isPin,
  }) async {
    try {
      final pinResult = await _chatRepository.pinChatRoom(roomUuid: roomUuid, isPin: isPin);

      if (pinResult) {
        state.refresh();
      }

      return pinResult;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      return false;
    } catch (e) {
      print('pinChatRoom Error $e');
      return false;
    }
  }

  Future<List<ChatRoomModel>> connectRooms(List<ChatRoomModel> rooms) async {
    final myInfo = ref.read(myInfoStateProvider);
    ChannelStore channelStore = ref.read(chatChannelStateProvider);

    List<ChatRoomModel> returnRooms = [];
    try {
      print('111111');
      for (var room in rooms) {
        String roomId = room.roomId;
        // String roomId = 'VBrhzLZgGG-nAFo5CS7jp-20210802120142';
        // String roomId = 'phzFRNVDOX-C34e30XOe7-20231222132959';
        print('222222');
        // Channel channel = await VChatCloud.connect(CustomHandler(roomId: roomId, channelStore: channelStore));
        final socket = await ref.read(chatSocketStateProvider);

        Channel channel = Channel(socket, CustomHandler());
        print('33333');
        channelStore.addChannel(
          roomId,
          channel,
        );

        print('channelStore ${channelStore.channelMap}');

        var user = UserModel(
          roomId: roomId,
          nickName: myInfo.nick ?? 'unknown',
          userInfo: {},
          clientKey: myInfo.uuid,
        );
        print('44444 / ${user.toString()}');
        ChannelResultModel history;
        try {
          print('4444-1');
          channel.user = user;
          channel = channel.leave();
          // print('4444-1-1');
          history = await channel.join(user);
          print('4444-2');
        } catch (e) {
          print('4444-4');
          history = await channel.join(user);
          print('4444-5');
        }

        print('55555');
        List<ChatItem> list = [];
        list.addAll((history.body["history"] as List<dynamic>)
            .reversed // 역순으로 추가
            .map((e) => ChatItem.fromJson(e as Map<String, dynamic>)));
        print('66666');
        channelStore.setChatLogs(roomId, list);
        print('77777');
        final lastMsg = list.isNotEmpty ? list.first.message : '';
        returnRooms.add(
          room.copyWith(
            lastMsg: lastMsg,
          ),
        );
        print('88888');
      }
      print('999999');
      return returnRooms;
    } catch (e) {
      print('vchat error $e');
      VChatCloud.disconnect();
      // if (e is VChatCloudError) {
      //   Util.showToast(e.message);
      // } else if (e is Error) {
      //   logger.e("$e ${e.stackTrace}");
      //   Util.showToast("알 수 없는 오류로 접속에 실패했습니다.");
      // }
      return returnRooms;
    }
  }

  Future initSocketStream(WebSocketChannel client) async {
    print('initSocketStream');
    // client ??= await ref.read(chatSocketStateProvider);
    final channelStroe = ref.read(chatChannelStateProvider);
    final handler = CustomHandler(channelStore: channelStroe);

    _subscription ??= client.stream.listen((event) async {
      var data = Channel.decode(event);
      print('data111 ${data.body}');
      var message = ChannelMessageModel.fromJson(data.body)..error = data.error;
      final roomId = message.roomId;
      print('roomId $roomId / message $message');

      if (roomId == null) {
        // 첫 조인 시 히스토리 수신
        if (data.address == "join_user_init") {
          // String roomName = data.body['roomName'];
          // String targetMemberUuid = roomName.split('^').last;
          // final tmpRoomId = await createChatRoom(targetMemberUuid: targetMemberUuid);

          // print('roomName $roomName');
          // print('roomId $tmpRoomId');
          // final channel = channelStroe.getChannel(tmpRoomId);
          final channel = channelStroe.getChannel('VBrhzLZgGG-nAFo5CS7jp-20210802120142');
          if (channel == null) {
            print('channel 1 is null');
            return;
          }

          if (!channel.joined.isCompleted) {
            if (data.error != null) {
              channel.joined.completeError(data.error!);
            } else {
              channel.joined.complete(data);
            }
          }
        }

        print('roomId is null');
        return;
      }
      final channel = channelStroe.getChannel(roomId);
      if (channel == null) {
        print('channel 2 is null');

        return;
      }

      if (data.address == "s2c.notify.custom/60CFA203FC623D5547F13B1C27A2F6FA") {
        print('aaaaaaaa');
        handler.onBroadCast(message, roomId);
      }
      if (data.address == "s2c.notify.message/$roomId") {
        handler.onMessage(message, roomId);
      }
      // if (data.address.startsWith("s2c.personal.whisper/$roomId")) {
      //   handler.onWhisper(message, roomId);
      // }
      // if (data.address == "s2c.notify.notice/$roomId") {
      //   handler.onNotice(message, roomId);
      // }
      if (data.address == "s2c.notify.custom/$roomId") {
        handler.onCustom(message, roomId);
      }
      if (data.address == "s2c.notify.join.user/$roomId") {
        handler.onJoinUser(message, roomId);
      }
      // if (data.address == "s2c.notify.leave.user/$roomId") {
      //   handler.onLeaveUser(message, roomId);
      // }
      // if (data.address == "s2c.notify.kick.user/$roomId") {
      //   handler.onKickUser(message, roomId);
      // }
      // if (data.address == "s2c.notify.unkick.user/$roomId") {
      //   handler.onUnkickUser(message, roomId);
      // }
      // if (data.address == "s2c.notify.mute.user/$roomId") {
      //   handler.onMuteUser(message, roomId);
      // }
      // if (data.address == "s2c.notify.unmute.user/$roomId") {
      //   handler.onUnmuteUser(message, roomId);
      // }
      if (data.address.startsWith("s2c.personal.duplicate.user/$roomId")) {
        print('aaaa ??');
        handler.onPersonalDuplicateUser(message, roomId);
      }
      // if (data.address.startsWith("s2c.personal.invite/$roomId")) {
      //   handler.onPersonalInvite(message, roomId);
      // }
      // if (data.address.startsWith("s2c.personal.kick.user/$roomId")) {
      //   handler.onPersonalKickUser(message, roomId);
      // }
      // if (data.address.startsWith("s2c.personal.mute.user/$roomId")) {
      //   handler.onMuteUser(message, roomId);
      // }
      // if (data.address.startsWith("s2c.personal.unmute.user/$roomId")) {
      //   handler.onUnmuteUser(message, roomId);
      // }

      if (channel.gCallback != null) {
        channel.gCallback!(data);
      }
    });

    return this;
  }
}
