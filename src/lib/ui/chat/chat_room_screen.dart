import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/anchor.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/store/channel_store.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/util/util.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/vo/chat_item.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/widget/chat_top_date.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/widget/text_chat_item.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/widget/user_join_item.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/widget/user_leave_item.dart';
import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  final String? profileImgUrl;
  final String nick;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.nick,
    this.profileImgUrl,
  });

  @override
  ChatRoomScreenState createState() => ChatRoomScreenState();
}

class ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  late final Channel channel;
  var inputController = TextEditingController();
  final _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _focus = FocusNode();
  var currentScrollPosition = false;
  var emojiActive = false;
  var rowHeight = 50.0;

  @override
  void initState() {
    channel = ref.read(chatChannelStateProvider).channelMap[widget.roomId]!;
    inputController.addListener(() {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          rowHeight = rowKey.currentContext?.size?.height ?? 50.0;
        });
      });
    });
    _focus.onKey = (node, event) {
      if (event is RawKeyDownEvent && !Util.isMobile) {
        if (event.isShiftPressed && event.logicalKey.keyLabel == 'Enter') {
          return KeyEventResult.ignored;
        } else if (event.logicalKey.keyLabel == 'Enter') {
          sendMessage();
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    };
    _scrollController.addListener(() {
      scrollController();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focus.dispose();
    channel.leave();
    super.dispose();
  }

  void scrollController() {
    if (_scrollController.offset <= 300) {
      setState(() {
        currentScrollPosition = false;
      });
    } else if (currentScrollPosition == false) {
      setState(() {
        currentScrollPosition = true;
      });
    }
  }

  void backHandler() {
    Navigator.pop(context);
  }

  // void emojiHandler() {
  //   _focus.unfocus();
  //   setState(() {
  //     emojiActive = !emojiActive;
  //   });
  // }

  void moveScrollBottom() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.jumpTo(0);
    });
  }

  void unfocus() {
    _focus.unfocus();
    setState(() {
      emojiActive = false;
    });
  }

  void sendMessage() {
    if (!Util.isMobile) {
      _focus.requestFocus();
    }
    if (inputController.text.trim().isEmpty) return;

    channel.sendMessage(inputController.text);
    inputController.clear();

    moveScrollBottom();
  }

  @override
  Widget build(BuildContext context) {
    var chatLog = ref.watch(chatChannelStateProvider).chatLogMap[widget.roomId]!;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 50,
          titleTextStyle: const TextStyle(
            color: Color(0xff999999),
          ),
          iconTheme: const IconThemeData(
            color: Color(
              0xff666666,
            ),
          ),
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                iconSize: 20,
                alignment: Alignment.center,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.blue.shade900,
                  size: 20,
                ),
                splashRadius: 20,
                onPressed: backHandler,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nick,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: const Color(0xffdfe6f2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: unfocus,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      chatBuilder(chatLog),
                      if (currentScrollPosition)
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: FloatingActionButton.small(
                            onPressed: () {
                              _scrollController.jumpTo(0);
                              setState(() {
                                currentScrollPosition = false;
                              });
                            },
                            tooltip: "Scroll to Bottom",
                            child: const Icon(Icons.arrow_downward),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              bottomBarBuilder(),
              // if (emojiActive) emojiBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget emojiBuilder() {
  //   var emoji = Provider.of<EmojiStore>(context);
  //   emoji.initEmojiList();
  //   emoji.initChildEmojiList();
  //
  //   return Column(
  //     children: const [
  //       EmojiImages(),
  //       EmojiList(),
  //     ],
  //   );
  // }

  Container bottomBarBuilder() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Flexible(
            child: TextField(
              key: rowKey,
              focusNode: _focus,
              controller: inputController,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              cursorColor: const Color(0xff2a61be),
              // textAlignVertical: TextAlignVertical.center,
              onTap: () {},
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          Anchor(
            onTap: sendMessage,
            child: Container(
              width: 50,
              constraints: BoxConstraints(maxHeight: max(rowHeight, 50)),
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 10,
              ),
              alignment: Alignment.bottomCenter,
              decoration: inputController.text.trim().isEmpty
                  ? const BoxDecoration(
                      color: Color(0xff919191),
                    )
                  : const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff2A61BE),
                          Color(0xff5D48C6),
                        ],
                        transform: GradientRotation(pi * -0.25),
                      ),
                    ),
              child: Transform.rotate(
                angle: pi * -0.25,
                child: Icon(
                  Icons.send,
                  size: 25,
                  color: inputController.text.trim().isEmpty ? Colors.white.withOpacity(0.7) : Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget chatBuilder(List<ChatItem> chatLog) {
    bool isUnSupported = Util.isWeb || (!Util.isWeb && Util.isWindows || Util.isIOS || Util.isMacOS || Platform.isLinux || Platform.isFuchsia);
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(15),
        reverse: true,
        child: Column(
          children: [
            ...chatLog.asMap().entries.expand(
              (entry) {
                var index = entry.key;
                var log = entry.value;
                FileModel? file;
                if (log.mimeType == MimeType.file) {
                  try {
                    if (log.message is String) {
                      file = FileModel.fromJson(json.decode(log.message)[0]);
                    } else {
                      file = FileModel.fromJson(log.message[0]);
                    }
                  } catch (e) {
                    if (log.message is String) {
                      file = FileModel.fromHistoryJson(json.decode(log.message)[0]);
                    } else {
                      file = FileModel.fromHistoryJson(log.message[0]);
                    }
                  }
                }

                return [
                  if (index == 0) ...[
                    ChatTopDate(log),
                  ] else if (chatLog[index - 1].messageDt.toIso8601String().substring(0, 10) != log.messageDt.toIso8601String().substring(0, 10)) ...[
                    SizedBox(height: log.profileNameCondition || log.myProfileNameCondition || [MessageType.join, MessageType.leave, MessageType.notice].contains(log.messageType) ? 20 : 8),
                    ChatTopDate(log),
                  ],
                  SizedBox(height: log.profileNameCondition || log.myProfileNameCondition || [MessageType.join, MessageType.leave, MessageType.notice].contains(log.messageType) ? 20 : 8),
                  if (log.messageType == MessageType.join)
                    UserJoinItem(log)
                  else if (log.messageType == MessageType.leave)
                    UserLeaveItem(log)
                  else if (log.messageType == MessageType.notice)
                    const Text("공지")
                  else if (log.messageType == MessageType.custom)
                    const Text("커스텀")
                  else
                    TextChatItem(
                      log,
                    ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
