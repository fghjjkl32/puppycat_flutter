import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrix/matrix.dart' hide Visibility;
import 'package:pet_mobile_social_flutter/common/util/extensions/filtered_timeline_extension.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/ios_badge_client_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat/chat_msg_item.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _client = (ref.read(chatControllerProvider('matrix')) as MatrixChatClientController).client;
    readMarkerEventId = widget.room.fullyRead;
    print('readMarkerEventId $readMarkerEventId');

    // _scrollController.addListener(() { })
    // readMarkerEventId = widget.room.fullyRead;
    // print('run?222222222 : $readMarkerEventId');

    loadTimelineFuture = _getTimeline(eventContextId: readMarkerEventId);
  }

  Future<void> _getTimeline({
    String? eventContextId,
    Duration timeout = const Duration(seconds: 7),
  }) async {
    print('ryun? $readMarkerEventId');
    await _client.roomsLoading;
    await _client.accountDataLoading; //.then((_) => readMarkerEventId = widget.room.fullyRead);
    if (eventContextId != null && (!eventContextId.isValidMatrixId || eventContextId.sigil != '\$')) {
      print('here?');
      eventContextId = null;
    }

    try {
      _timeline = await widget.room
          .getTimeline(
            onChange: (i) {
              print('on change! $i');
              _listKey.currentState?.setState(() {});
            },
            onInsert: (i) {
              print('on insert! $i');
              _listKey.currentState?.insertItem(i);
              _count++;
            },
            onRemove: (i) {
              print('On remove $i');
              _count--;
              _listKey.currentState?.removeItem(i, (_, __) => const ListTile());
            },
            onUpdate: () {
              print('On update');
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

  void _send(String msg) {
    if(msg.isEmpty) {
      return ;
    }
    
    ChatMessageModel? replyModel = ref.read(chatReplyProvider);
    ChatMessageModel? editModel = ref.read(chatEditProvider);
    Event? replyEvent;
    if (replyModel != null) {
      replyEvent = _timeline?.events[replyModel.idx];
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
    final allEditEvents = event
        .aggregatedEvents(timeline, RelationshipTypes.edit)
        .where((e) => e.status.isError);
    for (final e in allEditEvents) {
      e.sendAgain();
    }
  }

  void _delete(ChatMessageModel chatMessageModel) async {
    Event? event = _timeline?.events[chatMessageModel.idx];
    if (event == null) {
      return;
    }

    if(event.status.isError) {
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
    if (timeline == null) return;
    if (!timeline.canRequestFuture) return;
    try {
      final mostRecentEventId = timeline.events.first.eventId;
      await timeline.requestFuture(historyCount: 100);
      setReadMarker(eventId: mostRecentEventId);
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

      if (curEvent.senderId == nextEvent.senderId) {
        if (curEvent.originServerTs.minute.compareTo(nextEvent.originServerTs.minute) > 0) {
          return false;
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool _checkNeedDateRow(List<Event> events, int index) {
    print('date index : $index');
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

    if(curEvent.status.isError) {
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
    if (!chatMessageModel.isMine) {
      return;
    }
    ref.read(chatDeleteProvider.notifier).state = chatMessageModel;
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
        print('_onReaction 1');
        await evt.redactEvent();
      }
    }

    if (!isExist) {
      print('_onReaction 2');
      event.room.sendReaction(event.eventId, reactionKey);
    }
  }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels >
  //       _scrollController.position.maxScrollExtent -
  //           MediaQuery.of(context).size.height) {
  //     if (userOldLength == ref.read(userContentStateProvider).list.length) {
  //       ref
  //           .read(userContentStateProvider.notifier)
  //           .loadMorePost(ref.read(userModelProvider)!.idx);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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

    ref.listen(chatDeleteProvider, (previous, next) {
      if (next == null) {
        return;
      }
      _delete(next);
    });

    return SafeArea(
      child: Material(
        child: Theme(
          data: themeData(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
            ),
          ),
          child: GestureDetector(
            onTap: () => _inputFocus.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.room.getLocalizedDisplayname()),
                backgroundColor: kNeutralColor100,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: widget.room.onUpdate.stream,
                        builder: (context, _) {
                          return FutureBuilder(
                            future: loadTimelineFuture,
                            builder: (context, snapshot) {
                              final timeline = _timeline;
                              if (timeline == null) {
                                return const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              }
                              _count = timeline.events.length;
                              print('_count $_count');
                              return Column(
                                children: [
                                  // Center(
                                  //   child: TextButton(onPressed: timeline.requestHistory, child: const Text('Load more...')),
                                  // ),
                                  // const Divider(height: 1),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(14.0.w, 4.0.h, 14.0.w, 4.0.h),
                                      child: AnimatedList(
                                        key: _listKey,
                                        reverse: true,
                                        shrinkWrap: true,
                                        initialItemCount: _count,
                                        itemBuilder: (context, i, animation) {
                                          if (i == 0) {
                                            if (timeline!.isRequestingFuture) {
                                              return const Center(
                                                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                                              );
                                            }
                                            if (timeline!.canRequestFuture) {
                                              return Builder(
                                                builder: (context) {
                                                  WidgetsBinding.instance.addPostFrameCallback(
                                                    (_) => requestFuture(),
                                                  );
                                                  return Center(
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(Icons.refresh_outlined),
                                                    ),
                                                  );
                                                },
                                              );
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

                                          // if(displayEvent.status == EventStatus.error) {
                                          //   print('aaaa');
                                          //   // return Center(child: Text('메세지 전송에 실패했습니다.'),);
                                          // }

                                          if (!displayEvent.isVisibleInGui) {
                                            if(displayEvent.type == EventTypes.RoomCreate) {
                                              return Center(child: Text(DateTime(displayEvent.originServerTs.year, displayEvent.originServerTs.month, displayEvent.originServerTs.day).toString()));
                                            }
                                            return const SizedBox.shrink();
                                          }



                                          bool isNeedDateTime = _checkNeedDateRow(timeline.events, i);

                                          if (event.relationshipEventId != null) {
                                            if (event.relationshipType == RelationshipTypes.reply) {
                                              return FutureBuilder<Event?>(
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
                                                    avatarUrl: displayEvent.senderFromMemoryOrFallback.avatarUrl.toString(),
                                                    msg: displayEvent.plaintextBody,
                                                    dateTime: displayEvent.originServerTs.toIso8601String(),
                                                    isEdited: displayEvent.hasAggregatedEvents(timeline, RelationshipTypes.edit),
                                                    reaction: 0,
                                                    reactions: displayEvent.hasAggregatedEvents(timeline, RelationshipTypes.reaction) ? _getReactions(event, timeline) : [],
                                                    hasReaction: displayEvent.hasAggregatedEvents(timeline, RelationshipTypes.reaction),
                                                    isReply: true,
                                                    isRead: _checkReadMsg(displayEvent, timeline.events, i),
                                                    isConsecutively: _checkConsecutively(timeline.events, i),
                                                    replyTargetMsg: replyEvent.getDisplayEvent(timeline).plaintextBody,
                                                    replyTargetNick: replyEvent.senderFromMemoryOrFallback.calcDisplayname(),
                                                  );
                                                  return Column(
                                                    children: [
                                                      isNeedDateTime ? Text(displayEvent.originServerTs.toString()) : const SizedBox.shrink(),
                                                      ChatMessageItem(
                                                        key: ValueKey<String>(chatMessageModel.id),
                                                        chatMessageModel: chatMessageModel,
                                                        onReply: _onReply,
                                                        onEdit: _onEdit,
                                                        onDelete: _onDelete,
                                                        onReaction: (chatMessageModel, reactionKey) => _onReaction(chatMessageModel, reactionKey, timeline),
                                                        onError: (chatMessageModel) => _resend(displayEvent, timeline),
                                                        isError: displayEvent.status.isError,
                                                      ),
                                                    ],
                                                  );
                                                },
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
                                            avatarUrl: displayEvent.senderFromMemoryOrFallback.avatarUrl.toString(),
                                            msg: displayEvent.calcUnlocalizedBody(
                                              hideReply: true,
                                              hideEdit: false,
                                              plaintextBody: true,
                                              removeMarkdown: true,
                                            ),
                                            dateTime: displayEvent.originServerTs.toIso8601String(),
                                            isEdited: displayEvent.hasAggregatedEvents(timeline, RelationshipTypes.edit),
                                            reaction: 0,
                                            reactions: event.hasAggregatedEvents(timeline, RelationshipTypes.reaction) ? _getReactions(event, timeline) : [],
                                            hasReaction: displayEvent.hasAggregatedEvents(timeline, RelationshipTypes.reaction),
                                            isReply: false,
                                            isRead: _checkReadMsg(displayEvent, timeline.events, i),
                                            isConsecutively: _checkConsecutively(timeline.events, i),
                                          );

                                          return Column(
                                            children: [
                                              isNeedDateTime
                                                  ? Text(DateTime(displayEvent.originServerTs.year, displayEvent.originServerTs.month, displayEvent.originServerTs.day).toString())
                                                  : const SizedBox.shrink(),
                                              ChatMessageItem(
                                                key: ValueKey<String>(chatMessageModel.id),
                                                chatMessageModel: chatMessageModel,
                                                onReply: _onReply,
                                                onEdit: _onEdit,
                                                onDelete: _onDelete,
                                                onReaction: (chatMessageModel, reactionKey) => _onReaction(chatMessageModel, reactionKey, timeline),
                                                onError: (chatMessageModel) => _resend(displayEvent, timeline),
                                                isError: displayEvent.status.isError,
                                              ),
                                            ],
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
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.red,
                          blurRadius: 18.0,
                          spreadRadius: 35,
                          offset: Offset(0.0, 20.h),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Visibility(
                          visible: isReply,
                          child: Text(replyProvider?.msg ?? ''),
                        ),
                        Visibility(
                          visible: isEdit,
                          child: Text('메시지.메시지 수정'.tr()),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(12.0.w, 0.0.h, 12.0.w, 24.0.h),
                          child: Stack(
                            children: [
                              TextField(
                                controller: _sendController,
                                focusNode: _inputFocus,
                                decoration: InputDecoration(
                                  hintText: '메시지.메시지를 입력해 주세요'.tr(),
                                  // suffixIcon: Padding(
                                  //   padding: EdgeInsets.only(left: 24.0.w),
                                  //   child: IconButton(
                                  //     onPressed: () {},
                                  //     icon: const Icon(
                                  //       Icons.send_outlined,
                                  //       color: kPrimaryColor,
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  onPressed: () => _send(_sendController.text.trim()),
                                  icon: const Icon(
                                    Icons.send_outlined,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
