import 'package:pet_mobile_social_flutter/common/library/chat/store/channel_store.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/vo/chat_item.dart';
import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';

class CustomHandler extends ChannelHandler {
  // late final ChannelStore _channel;
  final ChannelStore? channelStore;

  CustomHandler({
    this.channelStore,
  });

  void reset() {
    if (channelStore == null) {
      return;
    }

    if (channelStore!.channelMap.isNotEmpty) {
      channelStore!.reset();
    }
  }

  @override
  void onJoinUser(ChannelMessageModel message, [String? roomId]) async {
    await channelStore!.getChannel(roomId!)?.requestClientList();
  }

  @override
  void onCustom(ChannelMessageModel message, [String? roomId]) {}

  @override
  void onBroadCast(ChannelMessageModel message, [String? roomId]) {
    print('socket broadCast ??');
  }

  @override
  void onMessage(ChannelMessageModel message, [String? roomId]) {
    if (roomId == null) {
      return;
    }
    if (channelStore == null) {
      return;
    }

    print('aaaaa ?');
    var chatData = ChatItem.fromChannelMessageModel(message);
    channelStore!.addChatLogs(roomId!, chatData);
  }

  @override
  void onNotice(ChannelMessageModel message, [String? roomId]) {
    if (roomId == null) {
      return;
    }
    if (channelStore == null) {
      return;
    }
    var chatData = ChatItem.fromChannelMessageModel(message)..messageType = MessageType.notice;
    channelStore!.addChatLogs(roomId!, chatData);
  }
}
