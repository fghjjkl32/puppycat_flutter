import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:matrix/matrix.dart' hide Visibility;
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/filtered_timeline_extension.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/ios_badge_client_extension.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/room_status_extension.dart';
import 'package:pet_mobile_social_flutter/components/comment/comment_custom_text_field.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_information/user_information_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat/chat_msg_item.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final Room room;

  const ChatRoomScreen({required this.room, Key? key}) : super(key: key);

  @override
  ChatRoomScreenState createState() => ChatRoomScreenState();
}

class ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  String? readMarkerEventId;
  Future<void>? loadTimelineFuture;
  Timeline? _timeline;
  late Client _client;
  Future<void>? _setReadMarkerFuture;
  final TextEditingController _sendController = TextEditingController();
  final FocusNode _inputFocus = FocusNode();
  int _count = 0;
  final AutoScrollController _scrollController = AutoScrollController();
  bool _scrolledUp = false;

  @override
  void initState() {
    _scrollController.addListener(_updateScrollController);
    super.initState();
    var userInfoModel = ref.read(userInfoProvider);
    _client = (ref.read(chatControllerProvider(ChatControllerInfo(provider: 'matrix', clientName: 'puppycat_${userInfoModel.userModel!.idx}'))).controller as MatrixChatClientController).client;
    readMarkerEventId = widget.room.fullyRead;
    loadTimelineFuture = _getTimeline(eventContextId: readMarkerEventId);

    // Future(() {
    //   ref.watch(userInformationStateProvider.notifier).getInitUserInformation(ref.watch(userModelProvider)?.idx, widget.memberIdx);
    // });
  }

  Future<void> _getTimeline({
    String? eventContextId,
    Duration timeout = const Duration(seconds: 7),
  }) async {
    await _client.roomsLoading;
    await _client.accountDataLoading; //.then((_) => readMarkerEventId = widget.room.fullyRead);
    if (eventContextId != null && (!eventContextId.isValidMatrixId || eventContextId.sigil != '\$')) {
      eventContextId = null;
    }

    try {
      _timeline = await widget.room
          .getTimeline(
            onChange: (i) {
              _listKey.currentState?.setState(() {});
            },
            onInsert: (i) {
              _listKey.currentState?.insertItem(i);
              _count++;
            },
            onRemove: (i) {
              _count--;
              _listKey.currentState?.removeItem(i, (_, __) => const ListTile());
            },
            onUpdate: () {
              updateView();
            },
            eventContextId: eventContextId,
          )
          .timeout(timeout);
    } catch (e, s) {
      if (!mounted) return;
      _timeline = await widget.room.getTimeline(onUpdate: updateView);
      if (!mounted) return;
      if (e is TimeoutException || e is IOException) {
        print('timeout');
        scrollToEventId(eventContextId!, _timeline!);
      }
    }

    _timeline!.requestKeys(onlineKeyBackupOnly: false);
    if (_timeline!.events.isNotEmpty) {
      if (widget.room.markedUnread) widget.room.markUnread(false);
      setReadMarker();
    }
  }

  void updateView() {
    if (!mounted) return;
    setState(() {});
  }

  void _send(String msg) async {
    if (msg.isEmpty) {
      return;
    }

    ChatMessageModel? replyModel = ref.read(chatReplyProvider);
    ChatMessageModel? editModel = ref.read(chatEditProvider);
    Event? replyEvent;
    if (replyModel != null) {
      replyEvent = _timeline?.events[replyModel.idx];
    }

    if (widget.room.isAbandonedDMRoom) {
      // widget.room.client.startDirectChat(widget.room.getDmID(), enableEncryption: false);
      await widget.room.client.inviteUser(widget.room.id, widget.room.getDmID());
    }

    widget.room.sendTextEvent(msg, inReplyTo: replyEvent, editEventId: editModel?.id);
    _sendController.clear();
    _inputFocus.unfocus();
    ref.read(chatReplyProvider.notifier).state = null;
    ref.read(chatEditProvider.notifier).state = null;
  }

  void _resend(Event event, Timeline timeline) {
    // final event = selectedEvents.first;
    if (event.status.isError) {
      event.sendAgain();
    }
    final allEditEvents = event.aggregatedEvents(timeline, RelationshipTypes.edit).where((e) => e.status.isError);
    for (final e in allEditEvents) {
      e.sendAgain();
    }
  }

  void _delete(ChatMessageModel chatMessageModel) async {
    Event? event = _timeline?.events[chatMessageModel.idx];
    if (event == null) {
      return;
    }

    if (event.status.isError) {
      await event.redactEvent();
      await event.remove();
      // await _client.database!.removeEvent(event.eventId, event.room.id);
    } else {
      await event.redactEvent();
    }
  }

  void requestHistory(Timeline timeline) async {
    if (!timeline!.canRequestHistory) return;
    try {
      await timeline!.requestHistory(historyCount: 100);
    } catch (err) {
      print('history err $err');
      rethrow;
    }
  }

  void requestFuture() async {
    final timeline = _timeline;
    if (timeline == null) {
      return;
    }
    if (!timeline.canRequestFuture) {
      return;
    }
    try {
      final mostRecentEventId = timeline.events.first.eventId;
      await timeline.requestFuture(historyCount: 100);
      setReadMarker(eventId: mostRecentEventId);
      print('read mostrecentevent');
    } catch (err) {
      print('future err : $err');
      rethrow;
    }
  }

  void setReadMarker({String? eventId}) {
    if (_setReadMarkerFuture != null) return;
    if (eventId == null && !widget.room.hasNewMessages && widget.room.notificationCount == 0) {
      return;
    }

    if (eventId == widget.room.fullyRead) {
      print('aaaaaaa');
      return;
    } else {
      print('bbbbbb');
    }

    final timeline = _timeline;
    if (timeline == null || timeline.events.isEmpty) return;

    eventId ??= timeline.events.first.eventId;
    Logs().v('Set read marker...', eventId);
    // ignore: unawaited_futures
    _setReadMarkerFuture = timeline.setReadMarker(eventId: eventId).then((_) {
      _setReadMarkerFuture = null;
    });
    // widget.room.client.updateIosBadge();
  }

  bool _checkConsecutively(List<Event> events, int index) {
    if (events.length <= index + 1) {
      return false;
    }

    if (index < 0) {
      return false;
    }

    if (events[index] == events.last) {
      return false;
    }

    try {
      /// NOTE
      /// Next 가 이전 메시지
      Event curEvent = events[index];
      Event nextEvent = events[index + 1];

      int tempIdx = index;
      bool isMessage = false;
      do {
        // print('_checkConsecutively 1-1 ${nextEvent.plaintextBody} / ${nextEvent.isVisibleInGui} / $tempIdx / ${nextEvent.isVisibleInGui} / ${nextEvent.relationshipType != RelationshipTypes.edit}');
        if (nextEvent.isVisibleInGui && nextEvent.relationshipType != RelationshipTypes.edit) {
          isMessage = true;
        }
        tempIdx = tempIdx + 1;
        nextEvent = events[tempIdx];
      } while (!isMessage);

      if (curEvent.senderId == nextEvent.senderId) {
        if (curEvent.originServerTs.sameOneMinute(nextEvent.originServerTs)) {
          return false;
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool _checkNeedViewTime(List<Event> events, int index) {
    if (index < 0) {
      return false;
    }

    if (events[index] == events[index].room.lastMessageEvent) {
      return true;
    }

    try {
      /// NOTE
      /// Next 가 다음 메시지
      Event curEvent = events[index];
      Event nextEvent = events[index - 1];

      int tempIdx = index;
      bool isMessage = false;
      do {
        // print('_checkNeedViewTime 1-1 ${nextEvent.plaintextBody} / ${nextEvent.isVisibleInGui} / $tempIdx / ${nextEvent.isVisibleInGui} / ${nextEvent.relationshipType != RelationshipTypes.edit}');
        if (nextEvent.isVisibleInGui && nextEvent.relationshipType != RelationshipTypes.edit) {
          isMessage = true;
        }
        tempIdx = tempIdx - 1;
        nextEvent = events[tempIdx];
      } while (!isMessage);

      // print('_checkNeedViewTime ${curEvent.senderId == nextEvent.senderId} / ${curEvent.plaintextBody} / ${nextEvent.plaintextBody} / ${curEvent.originServerTs} / ${nextEvent.originServerTs}');

      if (curEvent.senderId == nextEvent.senderId) {
        if (curEvent.originServerTs.sameOneMinute(nextEvent.originServerTs)) {
          return true;
        }
        return false;
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  double _getPadding(List<Event> events, int index) {
    if (index < 0) {
      return 4.0;
    }

    if (events[index] == events[index].room.lastMessageEvent) {
      return 20.0;
    }

    try {
      /// NOTE
      /// Next 가 다음 메시지
      Event curEvent = events[index];
      Event nextEvent = events[index - 1];

      int tempIdx = index;
      bool isMessage = false;
      do {
        // print('_checkNeedViewTime 1-1 ${nextEvent.plaintextBody} / ${nextEvent.isVisibleInGui} / $tempIdx / ${nextEvent.isVisibleInGui} / ${nextEvent.relationshipType != RelationshipTypes.edit}');
        if (nextEvent.isVisibleInGui && nextEvent.relationshipType != RelationshipTypes.edit) {
          isMessage = true;
        }
        tempIdx = tempIdx - 1;
        nextEvent = events[tempIdx];
      } while (!isMessage);

      if (curEvent.senderId == nextEvent.senderId) {
        if (curEvent.relationshipType == RelationshipTypes.reply) {
          return 20.0;
        }
        return 4.0;
      }

      return 20.0;
    } catch (e) {
      return 20.0;
    }
  }

  bool _checkNeedDateRow(List<Event> events, int index) {
    if (events.length <= index + 1) {
      return false;
    }

    if (index < 0) {
      return false;
    }

    if (events[index] == events.last) {
      return true;
    }

    try {
      /// NOTE
      /// Next 가 이전 메시지
      Event curEvent = events[index];
      Event nextEvent = events[index + 1];

      DateTime curDateTime = DateTime(curEvent.originServerTs.year, curEvent.originServerTs.month, curEvent.originServerTs.day);
      DateTime nextDateTime = DateTime(nextEvent.originServerTs.year, nextEvent.originServerTs.month, nextEvent.originServerTs.day);

      if (curDateTime.isAfter(nextDateTime)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool _checkReadMsg(Event curEvent, List<Event> events, int index) {
    String? fullyReadId = readMarkerEventId;
    String? lastReadEventId;
    int fullyReadIdx = -1;
    int lastReadEventIdx = -1;

    if (curEvent.status.isError) {
      return false;
    }

    if (fullyReadId == null) {
      return false;
    }

    fullyReadIdx = events.indexWhere((element) => element.eventId == fullyReadId!);
    if (fullyReadIdx < 0) {
      return false;
    }

    lastReadEventId = _getReadEventId(curEvent.room);
    if (lastReadEventId == null) {
      lastReadEventIdx = fullyReadIdx;
    } else {
      lastReadEventIdx = events.indexWhere((element) => element.eventId == lastReadEventId!);
    }

    if (lastReadEventIdx < fullyReadIdx) {
      fullyReadIdx = lastReadEventIdx;
      readMarkerEventId = lastReadEventId;
      setReadMarker(eventId: lastReadEventId);
    }

    if (index < fullyReadIdx) {
      return false;
    } else {
      return true;
    }
  }

  String? _getReadEventId(Room room) {
    if (room.ephemerals == null || !room.ephemerals!.containsKey('m.receipt')) {
      return null;
    }

    Map<String, Object?> receipts = room.ephemerals['m.receipt']!.content;
    String? readEventId;
    // receipts.forEach((key, value) {
    for (MapEntry e in receipts.entries) {
      Map<String, dynamic> contentMap = e.value as Map<String, dynamic>;
      if (contentMap.containsKey('m.read')) {
        readEventId = e.key;
        break;
      }
    }

    return readEventId;
  }

  List<String> _getReactions(Event event, Timeline timeline) {
    final allReactionEvents = event.aggregatedEvents(timeline, RelationshipTypes.reaction);
    List<String> reactions = [];

    for (final e in allReactionEvents) {
      final key = e.content.tryGetMap<String, dynamic>('m.relates_to')?.tryGet<String>('key');
      if (key == null) {
        continue;
      }
      reactions.add(key);
    }

    return reactions;
  }

  void _onReply(ChatMessageModel chatMessageModel) {
    ref.read(chatReplyProvider.notifier).state = chatMessageModel;
  }

  void _onEdit(ChatMessageModel chatMessageModel) {
    ref.read(chatEditProvider.notifier).state = chatMessageModel;
  }

  void _onDelete(ChatMessageModel chatMessageModel) {
    // if (!chatMessageModel.isMine) {
    //   return;
    // }
    // ref.read(chatDeleteProvider.notifier).state = chatMessageModel;
    _delete(chatMessageModel);
  }

  void _onReaction(ChatMessageModel chatMessageModel, String reactionKey, Timeline timeline) async {
    Event event = timeline.events[chatMessageModel.idx];
    Room room = event.room;

    final allReactionEvents = event.aggregatedEvents(timeline, RelationshipTypes.reaction); //_getReactions(event, timeline);
    final reactionList = _getReactions(event, timeline);

    bool isExist = reactionList.contains(reactionKey);

    for (var reaction in reactionList) {
      final evt = allReactionEvents.firstWhereOrNull(
        (e) => e.senderId == e.room.client.userID && e.content.tryGetMap<String, dynamic>('m.relates_to')?.tryGet<String>('key') == reaction,
      );
      if (evt != null) {
        await evt.redactEvent();
      }
    }

    if (!isExist) {
      event.room.sendReaction(event.eventId, reactionKey);
    }
  }

  Widget _buildDateBlock(Event event) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Bubble(
          radius: const Radius.circular(100.0),
          padding: const BubbleEdges.fromLTRB(16, 10, 16, 10),
          mainAxisAlignment: MainAxisAlignment.center,
          alignment: Alignment.center,
          color: kNeutralColor500,
          child: Text(
            DateFormat("yyyy-MM-dd").format(event.originServerTs),
            style: kBody11SemiBoldStyle.copyWith(color: kNeutralColor100),
          ),
        ),
      ),
    );
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
          _buildReplyOrEdit(),
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
                      color: _inputFocus.hasFocus ? kPrimaryColor : kTextBodyColor,
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

  Widget _buildReplyOrEdit() {
    var replyProvider = ref.watch(chatReplyProvider);
    var editProvider = ref.watch(chatEditProvider);
    bool isReply = replyProvider != null;
    bool isEdit = editProvider != null;

    ref.listen(chatEditProvider, (previous, next) {
      if (next == null) {
        _sendController.clear();
        return;
      }
      _sendController.text = next!.msg;
    });

    if (!isReply && !isEdit) {
      return const SizedBox.shrink();
    }

    return Container(
      color: kNeutralColor300,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 6.0.h, 12.w, 6.0.h),
        child: Row(
          children: [
            Visibility(
              visible: isReply,
              child: Expanded(
                child: Text(
                  '${replyProvider?.nick}${'메시지.님에게 답장'.tr()}\n${replyProvider?.msg}',
                  style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Visibility(
              visible: isEdit,
              child: Text(
                '메시지.메시지 수정'.tr(),
                style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                ref.read(chatReplyProvider.notifier).state = null;
                ref.read(chatEditProvider.notifier).state = null;
              },
              icon: const ImageIcon(
                AssetImage('assets/image/chat/icon_close_small.png'),
                // size: 10.w,
                color: kNeutralColor500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollToEventId(String eventId, Timeline timeline) async {
    final eventIndex = timeline.events.indexWhere((e) => e.eventId == eventId);
    if (eventIndex == -1) {
      setState(() {
        _scrolledUp = false;
        loadTimelineFuture = _getTimeline(
          eventContextId: eventId,
          timeout: const Duration(seconds: 30),
        ).onError((error, stackTrace) => null);
      });
      await loadTimelineFuture;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollToEventId(eventId, _timeline!);
      });
      return;
    }
    await _scrollController
        .scrollToIndex(
          eventIndex,
          preferPosition: AutoScrollPosition.middle,
        )
        .then((value) => ref.read(chatBubbleFocusProvider.notifier).state = eventIndex);
    _updateScrollController();
  }

  void _updateScrollController() {
    if (!mounted) {
      return;
    }
    setReadMarker();
    if (!_scrollController.hasClients) return;
    if (_timeline?.allowNewEvent == false || _scrollController.position.pixels > 0 && _scrolledUp == false) {
      setState(() => _scrolledUp = true);
      // _scrolledUp = true;
    } else if (_scrollController.position.pixels == 0 && _scrolledUp == true) {
      setState(() => _scrolledUp = false);
      // _scrolledUp = false;
    }
  }

  void scrollDown() async {
    if (!_timeline!.allowNewEvent) {
      setState(() {
        _scrolledUp = false;
        loadTimelineFuture = _getTimeline().onError((error, stackTrace) => null);
      });
      await loadTimelineFuture;
      setReadMarker(eventId: _timeline!.events.first.eventId);
    }
    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Theme(
          data: themeData(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: kNeutralColor400,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: kNeutralColor400,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: kNeutralColor400,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: kNeutralColor400,
                ),
              ),
            ),
          ),
          child: FocusDetector(
            onFocusLost: () async {
              ref.read(chatReplyProvider.notifier).state = null;
              ref.read(chatEditProvider.notifier).state = null;
              setReadMarker();
            },
            child: GestureDetector(
              onTap: () {
                ref.read(chatReplyProvider.notifier).state = null;
                ref.read(chatEditProvider.notifier).state = null;
                setReadMarker();
                _inputFocus.unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.room.getDisplayName()),
                  backgroundColor: kNeutralColor100,
                ),
                floatingActionButton: _scrolledUp
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 56.0),
                        child: FloatingActionButton.small(
                            backgroundColor: kNeutralColor100,
                            foregroundColor: kTextBodyColor,
                            onPressed: scrollDown,
                            elevation: 4,
                            child: const ImageIcon(
                              AssetImage('assets/image/chat/icon_down.png'),
                              size: 20,
                            )),
                      )
                    : null,
                body: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                          stream: widget.room.onUpdate.stream,
                          builder: (context, _) {
                            return FutureBuilder(
                              future: loadTimelineFuture,
                              // future: _getTimeline(eventContextId: widget.room.fullyRead),
                              builder: (context, snapshot) {
                                final timeline = _timeline;
                                if (timeline == null) {
                                  return const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                }
                                _count = timeline.events.length;
                                return Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(14.0.w, 4.0.h, 14.0.w, 0.0.h),
                                        child: AnimatedList(
                                          key: _listKey,
                                          controller: _scrollController,
                                          reverse: true,
                                          shrinkWrap: true,
                                          initialItemCount: _count,
                                          itemBuilder: (context, i, animation) {
                                            if (i == 0) {
                                              if (timeline.isRequestingFuture) {
                                                return const Center(
                                                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                                                );
                                              }
                                              if (timeline.canRequestFuture) {
                                                return Builder(
                                                  builder: (context) {
                                                    WidgetsBinding.instance.addPostFrameCallback(
                                                      (_) {
                                                        requestFuture();
                                                      },
                                                    );
                                                    return Center(
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(Icons.refresh_outlined),
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                Event event = timeline.events.first;
                                                if (event.senderId != _client.userID) {
                                                  print('??');
                                                  setReadMarker(eventId: event.eventId);
                                                }
                                              }
                                            } else if (i == timeline!.events.length - 5) {
                                              if (timeline!.isRequestingHistory) {
                                                return const Center(
                                                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                                                );
                                              }
                                              if (timeline!.canRequestHistory) {
                                                return Builder(
                                                  builder: (context) {
                                                    WidgetsBinding.instance.addPostFrameCallback(
                                                      (_) => requestHistory(timeline),
                                                    );
                                                    return Center(
                                                      child: IconButton(
                                                        onPressed: () => requestHistory(timeline),
                                                        icon: const Icon(Icons.refresh_outlined),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            }

                                            Event event = timeline.events[i];
                                            Event displayEvent = event.getDisplayEvent(timeline);

                                            if (!displayEvent.isVisibleInGui) {
                                              if (displayEvent.type == EventTypes.RoomCreate) {
                                                return _buildDateBlock(displayEvent);
                                                // return Center(child: Text(DateTime(displayEvent.originServerTs.year, displayEvent.originServerTs.month, displayEvent.originServerTs.day).toString()));
                                              }
                                              return const SizedBox.shrink();
                                            }

                                            bool isNeedDateTime = _checkNeedDateRow(timeline.events, i);

                                            if (event.relationshipEventId != null) {
                                              if (event.relationshipType == RelationshipTypes.reply) {
                                                return GestureDetector(
                                                  onTap: () => _inputFocus.unfocus(),
                                                  child: FutureBuilder<Event?>(
                                                    future: event.getReplyEvent(timeline),
                                                    builder: (BuildContext context, snapshot) {
                                                      final replyEvent = snapshot.hasData
                                                          ? snapshot.data!
                                                          : Event(
                                                              eventId: event.relationshipEventId!,
                                                              content: {'msgtype': 'm.text', 'body': '...'},
                                                              senderId: event.senderId,
                                                              type: 'm.room.message',
                                                              room: event.room,
                                                              status: EventStatus.sent,
                                                              originServerTs: DateTime.now(),
                                                            );
                                                      ChatMessageModel chatMessageModel = ChatMessageModel(
                                                        idx: i,
                                                        id: displayEvent.eventId,
                                                        // 답글은 보낸이가 달라야 내꺼
                                                        isMine: displayEvent.senderId != _client.userID,
                                                        userID: displayEvent.senderId,
                                                        // nick: displayEvent.senderFromMemoryOrFallback.displayName ?? 'unknown',
                                                        nick: displayEvent.senderFromMemoryOrFallback.room.getDisplayName() ?? 'unknown',
                                                        avatarUrl: displayEvent.senderFromMemoryOrFallback.avatarUrl.toString(),
                                                        // msg: displayEvent.redacted ? '메시지.삭제된 메시지 입니다'.tr() : displayEvent.plaintextBody,
                                                        msg: displayEvent.plaintextBody,
                                                        dateTime: displayEvent.originServerTs.toIso8601String(),
                                                        isEdited: event.hasAggregatedEvents(timeline, RelationshipTypes.edit),
                                                        reaction: 0,
                                                        reactions: displayEvent.hasAggregatedEvents(timeline, RelationshipTypes.reaction) ? _getReactions(event, timeline) : [],
                                                        hasReaction: displayEvent.hasAggregatedEvents(timeline, RelationshipTypes.reaction),
                                                        isReply: true,
                                                        isRead: _checkReadMsg(displayEvent, timeline.events, i),
                                                        isConsecutively: _checkConsecutively(timeline.events, i),
                                                        replyTargetMsg: replyEvent.getDisplayEvent(timeline).plaintextBody,
                                                        replyTargetNick: replyEvent.senderFromMemoryOrFallback.calcDisplayname(),
                                                        isViewTime: _checkNeedViewTime(timeline.events, i),
                                                      );
                                                      return AutoScrollTag(
                                                        key: ValueKey(event.eventId),
                                                        index: i,
                                                        controller: _scrollController,
                                                        child: Column(
                                                          children: [
                                                            isNeedDateTime ? _buildDateBlock(displayEvent) : const SizedBox.shrink(),
                                                            ChatMessageItem(
                                                              key: ValueKey<String>(chatMessageModel.id),
                                                              chatMessageModel: chatMessageModel,
                                                              onReply: _onReply,
                                                              onEdit: _onEdit,
                                                              onDelete: _onDelete,
                                                              onReaction: (chatMessageModel, reactionKey) => _onReaction(chatMessageModel, reactionKey, timeline),
                                                              onError: (chatMessageModel) => _resend(displayEvent, timeline),
                                                              isError: displayEvent.status.isError,
                                                              isSending: displayEvent.status.isSending,
                                                              isRedacted: displayEvent.redacted,
                                                              redactedMsg: '메시지.삭제된 메시지 입니다'.tr(),
                                                              bottomPadding: _getPadding(timeline.events, i),
                                                              onMoveReply: (chatMessageModel) {
                                                                // var replyEvnet = event.getReplyEvent(timeline);

                                                                scrollToEventId(replyEvent.eventId, timeline);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              } else if (displayEvent.relationshipType == RelationshipTypes.edit) {
                                                return const SizedBox.shrink();
                                              }
                                            }

                                            ChatMessageModel chatMessageModel = ChatMessageModel(
                                              idx: i,
                                              id: displayEvent.eventId,
                                              isMine: displayEvent.senderId == _client.userID,
                                              userID: displayEvent.senderId,
                                              // nick: displayEvent.senderFromMemoryOrFallback.displayName ?? 'unknown',
                                              nick: displayEvent.senderFromMemoryOrFallback.room.getDisplayName() ?? 'unknown',
                                              avatarUrl: displayEvent.senderFromMemoryOrFallback.avatarUrl.toString(),
                                              msg: displayEvent.calcUnlocalizedBody(
                                                hideReply: true,
                                                hideEdit: false,
                                                plaintextBody: true,
                                                removeMarkdown: true,
                                              ),
                                              dateTime: displayEvent.originServerTs.toIso8601String(),
                                              isEdited: event.hasAggregatedEvents(timeline, RelationshipTypes.edit),
                                              reaction: 0,
                                              reactions: event.hasAggregatedEvents(timeline, RelationshipTypes.reaction) ? _getReactions(event, timeline) : [],
                                              hasReaction: displayEvent.hasAggregatedEvents(timeline, RelationshipTypes.reaction),
                                              isReply: false,
                                              isRead: _checkReadMsg(displayEvent, timeline.events, i),
                                              isConsecutively: _checkConsecutively(timeline.events, i),
                                              isViewTime: _checkNeedViewTime(timeline.events, i),
                                            );

                                            return AutoScrollTag(
                                              key: ValueKey(event.eventId),
                                              index: i,
                                              controller: _scrollController,
                                              child: Column(
                                                // crossAxisAlignment: CrossAxisAlignment.center,
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  isNeedDateTime ? _buildDateBlock(displayEvent) : const SizedBox.shrink(),
                                                  ChatMessageItem(
                                                    key: ValueKey<String>(chatMessageModel.id),
                                                    chatMessageModel: chatMessageModel,
                                                    onReply: _onReply,
                                                    onEdit: _onEdit,
                                                    onDelete: _onDelete,
                                                    onReaction: (chatMessageModel, reactionKey) => _onReaction(chatMessageModel, reactionKey, timeline),
                                                    onError: (chatMessageModel) => _resend(displayEvent, timeline),
                                                    isError: displayEvent.status.isError,
                                                    isSending: displayEvent.status.isSending,
                                                    isRedacted: displayEvent.redacted,
                                                    redactedMsg: '메시지.삭제된 메시지 입니다'.tr(),
                                                    bottomPadding: _getPadding(timeline.events, i),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                    ),
                    _buildTextField(),
                    // const Positioned(
                    //   left: 0,
                    //   right: 0,
                    //   bottom: 0,
                    //   child: CommentCustomTextField(),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
