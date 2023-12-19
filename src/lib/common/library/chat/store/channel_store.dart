import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/vo/chat_item.dart';
import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';

final chatChannelStateProvider = StateProvider<ChannelStore>((ref) => ChannelStore());

class ChannelStore extends ChangeNotifier {
  // Channel? channel;
  Map<String, Channel> channelMap = {};

  // List<ChatItem> chatLog = [];
  Map<String, List<ChatItem>> chatLogMap = {};
  List<UserModel> clientList = [];
  Map<String, String> translateClientKeyMap = {};

  // void setChannel(Channel channel) {
  //   this.channel = channel;
  //   notifyListeners();
  // }

  void addChannel(String roomId, Channel channel) {
    channelMap[roomId] = channel;
    notifyListeners();
  }

  Channel? getChannel(String roomId) {
    if (channelMap.containsKey(roomId)) {
      return channelMap[roomId];
    } else {
      return null;
    }
  }

  // void setChatLog(List<ChatItem> chatLog) {
  //   this.chatLog = chatLog;
  //   for (var i = 0; i < this.chatLog.length; i++) {
  //     if (i != 0) {
  //       this.chatLog[i - 1].nextClientKey = this.chatLog[i].clientKey;
  //       this.chatLog[i - 1].nextDt = this.chatLog[i].messageDt;
  //       this.chatLog[i]
  //         ..previousClientKey = this.chatLog[i - 1].clientKey
  //         ..previousDt = this.chatLog[i - 1].messageDt;
  //     }
  //     this.chatLog[i].isMe = this.chatLog[i].clientKey == channel?.user?.clientKey;
  //   }
  //   notifyListeners();
  // }

  void setChatLogs(String roomId, List<ChatItem> chatLog) {
    for (var i = 0; i < chatLog.length; i++) {
      if (i != 0) {
        chatLog[i - 1].nextClientKey = chatLog[i].clientKey;
        chatLog[i - 1].nextDt = chatLog[i].messageDt;
        chatLog[i]
          ..previousClientKey = chatLog[i - 1].clientKey
          ..previousDt = chatLog[i - 1].messageDt;
      }
      chatLog[i].isMe = chatLog[i].clientKey == channelMap[roomId]?.user?.clientKey;
    }

    chatLogMap[roomId] = chatLog;
    notifyListeners();
  }

  // void addChatLog(ChatItem data) {
  //   if (chatLog.isNotEmpty) {
  //     chatLog.last.nextClientKey = data.clientKey;
  //     chatLog.last.nextDt = data.messageDt;
  //     data.previousClientKey = chatLog.last.clientKey;
  //     data.previousDt = chatLog.last.messageDt;
  //   }
  //   chatLog.add(data..isMe = data.clientKey == channel?.user?.clientKey);
  //   notifyListeners();
  // }

  void addChatLogs(String roomId, ChatItem data) {
    List<ChatItem> chatLog = chatLogMap[roomId] ?? [];

    if (chatLog.isNotEmpty) {
      chatLog.last.nextClientKey = data.clientKey;
      chatLog.last.nextDt = data.messageDt;
      data.previousClientKey = chatLog.last.clientKey;
      data.previousDt = chatLog.last.messageDt;
    }
    chatLog.add(data..isMe = data.clientKey == channelMap[roomId]?.user?.clientKey);
    chatLogMap[roomId] = chatLog;
    notifyListeners();
  }

  // void setClientList(List<UserModel> clientList) {
  //   this.clientList = clientList;
  //   notifyListeners();
  // }
  //
  // void addClientList(UserModel data) {
  //   clientList.add(data);
  //   notifyListeners();
  // }

  // void addTranslate(String clientKey, String translateLanguage) {
  //   translateClientKeyMap[clientKey] = translateLanguage;
  //   notifyListeners();
  // }
  //
  // void removeTranslate(String clientKey) {
  //   translateClientKeyMap.remove(clientKey);
  //   notifyListeners();
  // }

  void reset() {
    channelMap.clear();
    chatLogMap.clear();
    clientList.clear();
    translateClientKeyMap = {};
    notifyListeners();
  }
}
