import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_enter_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_controller_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_msg_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/widget/chat_msg_item.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomUuid;
  final String nick;
  final String targetMemberUuid;
  final String? profileImgUrl;
  final ChatEnterModel? chatEnterModel;
  final int? userState;

  const ChatRoomScreen({
    super.key,
    required this.roomUuid,
    required this.nick,
    required this.targetMemberUuid,
    this.profileImgUrl,
    this.chatEnterModel,
    this.userState,
  });

  @override
  ChatRoomScreenState createState() => ChatRoomScreenState();
}

class ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  late final chatProviderNotifier = ref.read(chatRoomListStateProvider.notifier);
  late final _chatHistoryPagingController = ref.read(chatMessageStateProvider);
  final AutoScrollController _scrollController = AutoScrollController();
  final TextEditingController _sendController = TextEditingController();
  final FocusNode _inputFocus = FocusNode();
  late Future _initChatFuture;

  // late ChatController _chatController;
  bool _scrolledUp = false;
  late ChatEnterModel? _chatEnterModel;
  late ChatController? _chatController = ref.watch(chatControllerStateProvider);

  //TODO
  //시나리오 테스트용 변수
  bool _switchValue = false;
  late Timer _timerForTest;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollController);

    _chatEnterModel = widget.chatEnterModel;
    _initChatFuture = _initChat();

    _inputFocus.addListener(() {
      print('_inputFocus.hasFocus ${_inputFocus.hasFocus}');
      setState(() {});
    });
  }

  @override
  void dispose() {
    print('1 - _chatController.disconnect();');
    if (_chatController != null) {
      _chatController!.disconnect();
    }
    super.dispose();
  }

  Future<ChatEnterModel> _initChat() async {
    try {
      _chatEnterModel ??= await chatProviderNotifier.createChatRoom(targetMemberUuid: widget.targetMemberUuid);

      if (_chatEnterModel == null) {
        print('error??');
        throw 'Chat Enter Model is Null';
      }

      final myInfo = ref.read(myInfoStateProvider);
      final targetMemberList = [widget.targetMemberUuid, myInfo.uuid ?? ''];

      final chatControllerProvider = ref.read(chatControllerStateProvider.notifier);

      _chatController = await ref.read(chatControllerStateProvider.notifier).connect(chatEnterModel: _chatEnterModel!, targetMemberList: targetMemberList);

      return _chatEnterModel!;
    } catch (e) {
      rethrow;
    }
  }

  void _updateScrollController() {
    if (!mounted) {
      return;
    }
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels > 0 && _scrolledUp == false) {
      setState(() => _scrolledUp = true);
      // _scrolledUp = true;
    } else if (_scrollController.position.pixels == 0 && _scrolledUp == true) {
      setState(() => _scrolledUp = false);
      // _scrolledUp = false;
    }
  }

  void scrollDown() async {
    _scrollController.jumpTo(0);
  }

  void _send(String msg) async {
    if (msg.isEmpty) {
      return;
    }

    if (_chatController == null || !await _chatController!.isConnected()) {
      context.push('/dialog/errorDialog', extra: '네트워크가 불안정합니다'.tr());
      return;
    }

    final myInfo = ref.read(myInfoStateProvider);

    final String profileImg = myInfo.profileImgUrl ?? '';
    await ref.read(chatControllerStateProvider.notifier).sendMessage(msg, profileImg);
    // _chatController!.send(msg, profileImg, '');

    _sendController.clear();
    _inputFocus.unfocus();
    scrollDown();
  }

  Widget _buildTextField([bool isBlock = false]) {
    return SizedBox(
      height: 48,
      child: Theme(
        data: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: kNeutralColor100,
                blurRadius: 18.0,
                spreadRadius: 35,
                offset: Offset(0.0, 20),
              ),
            ],
            color: kNeutralColor100,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
            child: TextField(
              enabled: widget.userState == 0 ? false : true,
              controller: _sendController,
              focusNode: _inputFocus,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0, color: kBorderPrimary),
                  borderRadius: BorderRadius.circular(100.0),
                  gapPadding: 10.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0, color: kBorderPrimary),
                  borderRadius: BorderRadius.circular(100.0),
                  gapPadding: 10.0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0, color: kBorderPrimary),
                  borderRadius: BorderRadius.circular(100.0),
                  gapPadding: 10.0,
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0, color: kBorderPrimary),
                  borderRadius: BorderRadius.circular(100.0),
                  gapPadding: 10.0,
                ),
                hintText: widget.userState == 0 ? '메시지를 보낼 수 없습니다.' : '메시지.메시지를 입력해 주세요'.tr(),
                hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
                contentPadding: const EdgeInsets.fromLTRB(20, 15, 12, 15),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 12),
                  child: IconButton(
                    onPressed: () => _send(_sendController.text.trim()),
                    icon: ImageIcon(
                      AssetImage('assets/image/chat/icon_send_de.png'),
                      color: _inputFocus.hasFocus ? kIconActionPrimary : kIconSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateBlock(String msgDateTime) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(msgDateTime) * 1000);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Bubble(
          radius: const Radius.circular(100.0),
          padding: const BubbleEdges.fromLTRB(16, 10, 16, 10),
          // mainAxisAlignment: MainAxisAlignment.center,
          alignment: Alignment.center,
          color: kNeutralColor500.withOpacity(0.8),
          child: Text(
            DateFormat("yyyy-MM-dd").format(dateTime),
            style: kBody11SemiBoldStyle.copyWith(color: kWhiteColor),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(bool isViewProfileImg, String url) {
    if (!isViewProfileImg) {
      return const SizedBox(
        width: 34,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: InkWell(
        onTap: () {
          print('move user page');
          // context.push('/member/userPage/${widget.nick}/${widget.targetMemberUuid}/null');
          context.push("/member/userPage", extra: {"nick": widget.nick, "memberUuid": widget.targetMemberUuid});
        },
        child: SizedBox(
          // color: Colors.red,
          width: 28,
          height: 28,
          child: getProfileAvatar(url),
        ),
      ),
    );
  }

  // Widget _hashTagText(String text) {
  //   return DetectableText(
  //     text: text,
  //     detectionRegExp: detectionRegExp(atSign: false) ??
  //         RegExp(
  //           "(?!\\n)(?:^|\\s)([#]([$detectionContentLetters]+))|$urlRegexContent",
  //           multiLine: true,
  //         ),
  //     detectedStyle: kBody13RegularStyle.copyWith(color: kSecondaryColor500),
  //     basicStyle: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
  //     onTap: (tappedText) {
  //       ///TODO
  //       /// 해시태그 검색 페이지 이동
  //       /// 밖에서 함수 받아오기
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);
    _chatController = ref.watch(chatControllerStateProvider);
    // ref.listen(chatControllerStateProvider, (previous, next) {
    //   print('chatControllerStateProvider listen');
    // });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nick,
          style: kTitle18BoldStyle.copyWith(color: kTextPrimary, height: 1.4),
        ),
        backgroundColor: kPreviousNeutralColor100,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            // size: 20,
          ),
          onPressed: () async {
            if (_chatController != null) {
              // _chatController!.disconnect(true);
              await ref.read(chatControllerStateProvider.notifier).disconnect(true);
            }
            context.pop();
          },
        ),
        actions: [
          ///NOTE
          ///Test용 코드
          Switch(
              value: _switchValue,
              onChanged: (value) async {
                setState(() {
                  _switchValue = value;
                });

                if (value) {
                  _timerForTest = Timer.periodic(Duration(seconds: 1), (timer) async {
                    await ref.read(chatControllerStateProvider.notifier).sendMessage(
                          timer.tick.toString(),
                          null,
                        );
                  });
                } else {
                  if (_timerForTest.isActive) {
                    _timerForTest.cancel();
                  }
                }
              }),
        ],
      ),
      floatingActionButton: _scrolledUp
          ? Padding(
              padding: const EdgeInsets.only(bottom: 56.0),
              child: FloatingActionButton.small(
                  backgroundColor: kNeutralColor100,
                  foregroundColor: kPreviousTextBodyColor,
                  onPressed: scrollDown,
                  elevation: 1,
                  child: const ImageIcon(
                    AssetImage('assets/image/chat/icon_down.png'),
                    size: 20,
                  )),
            )
          : null,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            _inputFocus.unfocus();
          },
          child: DefaultOnWillPopScope(
            onWillPop: () async {
              if (_chatController != null) {
                // _chatController!.disconnect(true);
                await ref.read(chatControllerStateProvider.notifier).disconnect(true);
              }

              return true;
            },
            child: FutureBuilder(
              future: _initChatFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                ChatEnterModel chatEnterModel = snapshot.data;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: PagedListView<int, ChatMessageModel>(
                          pagingController: _chatHistoryPagingController,
                          scrollController: _scrollController,
                          reverse: true,
                          builderDelegate: PagedChildBuilderDelegate<ChatMessageModel>(
                            noItemsFoundIndicatorBuilder: (context) {
                              return const SizedBox.shrink();
                            },
                            firstPageProgressIndicatorBuilder: (context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            itemBuilder: (context, item, index) {
                              bool isViewDateBlock = ref.read(chatMessageStateProvider.notifier).checkViewDateBlock(index);
                              bool isViewMsgTime = ref.read(chatMessageStateProvider.notifier).checkNeedViewTime(index);
                              bool isConsecutively = ref.read(chatMessageStateProvider.notifier).checkConsecutively(index);
                              bool isMine = item.isMine;
                              bool isViewProfileImg = !isMine & !isConsecutively; //상대방이 보낸 메시지이면서 연속적이지 않는 메시지일 때
                              double chatMsgBottomPadding = ref.read(chatMessageStateProvider.notifier).getChatMsgBottomPadding(index);
                              // double chatMsgPadding = isViewMsgTime ? 16.0 : 2.0;

                              // final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(item.dateTime) * 1000);
                              //
                              // if (index == 0) {
                              //   print('last item $item');
                              //   _chatController.read(msg: item.msg, score: item.score, memberUuid: myInfo.uuid ?? '');
                              // }

                              return Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, chatMsgBottomPadding),
                                child: Column(
                                  children: [
                                    isViewDateBlock ? _buildDateBlock(item.dateTime) : const SizedBox.shrink(),
                                    Row(
                                      // mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildProfile(isViewProfileImg, widget.profileImgUrl ?? ''),
                                        Expanded(
                                          child: AutoScrollTag(
                                            key: UniqueKey(),
                                            controller: _scrollController,
                                            index: index,
                                            child: ChatMessageItem(
                                              chatMessageModel: item.copyWith(
                                                isViewTime: isViewMsgTime,
                                                isConsecutively: isConsecutively,
                                              ),
                                              isError: false,
                                              isSending: false,
                                              isRedacted: false,
                                              onReport: (chatMsgModel) async {
                                                await ref
                                                    .read(chatMessageStateProvider.notifier)
                                                    .reportChatMessage(
                                                      roomUuid: widget.roomUuid,
                                                      message: chatMsgModel.msg,
                                                      score: chatMsgModel.score,
                                                      targetMemberUuid: widget.targetMemberUuid,
                                                    )
                                                    .then((value) {
                                                  if (value) {
                                                    print('1 - report run?');
                                                    ref.read(chatControllerStateProvider.notifier).reportMessage(
                                                          originMsg: chatMsgModel.originData,
                                                          score: chatMsgModel.score,
                                                        );
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: _scrolledUp ? 0.0 : 2.0),
                        child: _buildTextField(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
