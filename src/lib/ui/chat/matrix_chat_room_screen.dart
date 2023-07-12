// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:matrix/matrix.dart';
// import 'package:pet_mobile_social_flutter/common/util/extensions/ios_badge_client_extension.dart';
// import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
// import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
//
// class ChatRoomScreen extends ConsumerStatefulWidget {
//   final Room room;
//
//   const ChatRoomScreen({required this.room, Key? key}) : super(key: key);
//
//   @override
//   ChatRoomScreenState createState() => ChatRoomScreenState();
// }
//
// class ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
//   late final Future<Timeline> _timelineFuture;
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   int _count = 0;
//   String? readMarkerEventId;
//   Future<void>? loadTimelineFuture;
//   Timeline? _timeline;
//
//   @override
//   void initState() {
//     readMarkerEventId = widget.room.fullyRead;
//     print('readMarkerEventId $readMarkerEventId');
//     super.initState();
//
//     readMarkerEventId = widget.room.fullyRead;
//     loadTimelineFuture = _getTimeline(eventContextId: readMarkerEventId);
//   }
//
//   Future<void> _getTimeline({
//     String? eventContextId,
//     Duration timeout = const Duration(seconds: 7),
//   }) async {
//     print('ryun?');
//     var client = (ref.read(chatControllerProvider('matrix')) as MatrixChatClientController).client;
//     await client.roomsLoading;
//     await client.accountDataLoading;
//     if (eventContextId != null && (!eventContextId.isValidMatrixId || eventContextId.sigil != '\$')) {
//       print('here?');
//       eventContextId = null;
//     }
//     _timeline = await widget.room
//         .getTimeline(
//       onChange: (i) {
//         print('on change! $i');
//         _listKey.currentState?.setState(() {});
//       },
//       onInsert: (i) {
//         print('on insert! $i');
//         _listKey.currentState?.insertItem(i);
//         _count++;
//       },
//       onRemove: (i) {
//         print('On remove $i');
//         _count--;
//         _listKey.currentState?.removeItem(i, (_, __) => const ListTile());
//       },
//       onUpdate: () {
//         print('On update');
//       },
//       eventContextId: eventContextId,
//     )
//         .timeout(timeout);
//
//     _timeline!.requestKeys(onlineKeyBackupOnly: false);
//     if (_timeline!.events.isNotEmpty) {
//       if (widget.room.markedUnread) widget.room.markUnread(false);
//       setReadMarker();
//     }
//   }
//
//   final TextEditingController _sendController = TextEditingController();
//
//   void _send() {
//     widget.room.sendTextEvent(_sendController.text.trim());
//     _sendController.clear();
//   }
//
//   void requestHistory(Timeline timeline) async {
//     if (!timeline!.canRequestHistory) return;
//     try {
//       await timeline!.requestHistory(historyCount: 100);
//     } catch (err) {
//       print('history err $err');
//       rethrow;
//     }
//   }
//
//   void requestFuture() async {
//     final timeline = _timeline;
//     if (timeline == null) return;
//     if (!timeline.canRequestFuture) return;
//     try {
//       final mostRecentEventId = timeline.events.first.eventId;
//       await timeline.requestFuture(historyCount: 100);
//       setReadMarker(eventId: mostRecentEventId);
//     } catch (err) {
//       print('future err : $err');
//       rethrow;
//     }
//   }
//
//   Future<void>? _setReadMarkerFuture;
//
//   void setReadMarker({String? eventId}) {
//     if (_setReadMarkerFuture != null) return;
//     if (eventId == null && !widget.room.hasNewMessages && widget.room.notificationCount == 0) {
//       return;
//     }
//
//     final timeline = _timeline;
//     if (timeline == null || timeline.events.isEmpty) return;
//
//     eventId ??= timeline.events.first.eventId;
//     Logs().v('Set read marker...', eventId);
//     // ignore: unawaited_futures
//     _setReadMarkerFuture = timeline.setReadMarker(eventId: eventId).then((_) {
//       _setReadMarkerFuture = null;
//     });
//     widget.room.client.updateIosBadge();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.room.displayname),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: FutureBuilder<Timeline>(
//                 future: _getTimeline(),
//                 builder: (context, snapshot) {
//                   final timeline = snapshot.data;
//                   if (timeline == null) {
//                     return const Center(
//                       child: CircularProgressIndicator.adaptive(),
//                     );
//                   }
//                   _count = timeline.events.length;
//                   return Column(
//                     children: [
//                       Center(
//                         child: TextButton(onPressed: timeline.requestHistory, child: const Text('Load more...')),
//                       ),
//                       const Divider(height: 1),
//                       Expanded(
//                         child: AnimatedList(
//                           key: _listKey,
//                           reverse: true,
//                           initialItemCount: timeline.events.length,
//                           itemBuilder: (context, i, animation) {
//                             // WidgetsBinding.instance.addPostFrameCallback(
//                             //       (_) => timeline.requestHistory,
//                             // );
//                             // timeline.requestHistory;
//                             print('run?0');
//                             if (i == 0) {
//                               print('run?1');
//                               if (timeline!.isRequestingFuture) {
//                                 return const Center(
//                                   child: CircularProgressIndicator.adaptive(strokeWidth: 2),
//                                 );
//                               }
//                               if (timeline!.canRequestFuture) {
//                                 return Builder(
//                                   builder: (context) {
//                                     // WidgetsBinding.instance.addPostFrameCallback(
//                                     //       (_) => requestFuture(timeline),
//                                     // );
//                                     return Center(
//                                       child: IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(Icons.refresh_outlined),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               }
//                             } else if (i == timeline!.events.length + 1) {
//                               print('run?2');
//                               if (timeline!.isRequestingHistory) {
//                                 return const Center(
//                                   child: CircularProgressIndicator.adaptive(strokeWidth: 2),
//                                 );
//                               }
//                               if (timeline!.canRequestHistory) {
//                                 return Builder(
//                                   builder: (context) {
//                                     WidgetsBinding.instance.addPostFrameCallback(
//                                           (_) => requestHistory(timeline),
//                                     );
//                                     return Center(
//                                       child: IconButton(
//                                         onPressed: () => requestHistory(timeline),
//                                         icon: const Icon(Icons.refresh_outlined),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               }
//                             }
//                             return timeline.events[i].relationshipEventId != null
//                                 ? Container()
//                                 : ScaleTransition(
//                               scale: animation,
//                               child: Opacity(
//                                 opacity: timeline.events[i].status.isSent ? 1 : 0.5,
//                                 child: ListTile(
//                                   leading: CircleAvatar(
//                                     foregroundImage: timeline.events[i].sender.avatarUrl == null
//                                         ? null
//                                         : NetworkImage(timeline.events[i].sender.avatarUrl!
//                                         .getThumbnail(
//                                       widget.room.client,
//                                       width: 56,
//                                       height: 56,
//                                     )
//                                         .toString()),
//                                   ),
//                                   title: Row(
//                                     children: [
//                                       Expanded(
//                                         child: Text(timeline.events[i].sender.calcDisplayname()),
//                                       ),
//                                       Text(
//                                         timeline.events[i].originServerTs.toIso8601String(),
//                                         style: const TextStyle(fontSize: 10),
//                                       ),
//                                     ],
//                                   ),
//                                   subtitle: Text(timeline.events[i].getDisplayEvent(timeline).body),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             const Divider(height: 1),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                       child: TextField(
//                         controller: _sendController,
//                         decoration: const InputDecoration(
//                           hintText: 'Send message',
//                         ),
//                       )),
//                   IconButton(
//                     icon: const Icon(Icons.send_outlined),
//                     onPressed: _send,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
