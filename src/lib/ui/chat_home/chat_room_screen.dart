import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_enter_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_msg_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/widget/chat_msg_item.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  final String nick;
  final String targetMemberUuid;
  final String? profileImgUrl;
  final ChatEnterModel? chatEnterModel;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.nick,
    required this.targetMemberUuid,
    this.profileImgUrl,
    this.chatEnterModel,
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
  late ChatController _chatController;
  bool _scrolledUp = false;
  late ChatEnterModel? _chatEnterModel;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollController);

    _chatEnterModel = widget.chatEnterModel;
    _initChatFuture = _initChat();
  }

  @override
  void dispose() {
    _chatController.disconnect();
    super.dispose();
  }

  Future<ChatEnterModel> _initChat() async {
    try {
      _chatEnterModel ??= await chatProviderNotifier.createChatRoom(targetMemberUuid: widget.targetMemberUuid);

      if (_chatEnterModel == null) {
        print('error??');
        throw 'Chat Enter Model is Null';
      }

      _chatController = ChatController(roomUuid: _chatEnterModel!.roomId, token: _chatEnterModel!.generateToken);
      _chatController.connect(chatWSBaseUrl, (chatMessageModel) {
        ref.read(chatMessageStateProvider.notifier).addChatMessage(chatMessageModel);
      });
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

    _chatController.send(msg);

    _sendController.clear();
    _inputFocus.unfocus();
    scrollDown();
  }

  Widget _buildTextField([bool isBlock = false]) {
    return Container(
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
      child: Column(
        children: [
          // _buildReplyOrEdit(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
            child: TextField(
              controller: _sendController,
              focusNode: _inputFocus,
              decoration: InputDecoration(
                hintText: '메시지.메시지를 입력해 주세요'.tr(),
                hintStyle: kBody12RegularStyle400.copyWith(color: kNeutralColor500),
                contentPadding: const EdgeInsets.fromLTRB(20, 15, 12, 15),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 12),
                  child: IconButton(
                    onPressed: () => _send(_sendController.text.trim()),
                    icon: ImageIcon(
                      const AssetImage('assets/image/chat/icon_send_de.png'),
                      color: _inputFocus.hasFocus ? kPreviousPrimaryColor : kPreviousTextBodyColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
          color: kPreviousNeutralColor500,
          child: Text(
            DateFormat("yyyy-MM-dd").format(dateTime),
            style: kBody11SemiBoldStyle.copyWith(color: kNeutralColor100),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nick),
        backgroundColor: kPreviousNeutralColor100,
      ),
      floatingActionButton: _scrolledUp
          ? Padding(
              padding: const EdgeInsets.only(bottom: 56.0),
              child: FloatingActionButton.small(
                  backgroundColor: kNeutralColor100,
                  foregroundColor: kPreviousTextBodyColor,
                  onPressed: scrollDown,
                  elevation: 4,
                  child: const ImageIcon(
                    AssetImage('assets/image/chat/icon_down.png'),
                    size: 20,
                  )),
            )
          : null,
      body: SafeArea(
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

                          final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(item.dateTime) * 1000);

                          return Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, chatMsgBottomPadding),
                            child: Column(
                              children: [
                                isViewDateBlock ? _buildDateBlock(item.dateTime) : const SizedBox.shrink(),
                                Row(
                                  // mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                                  children: [
                                    _buildProfile(isViewProfileImg, ''),
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
    );
  }
}
