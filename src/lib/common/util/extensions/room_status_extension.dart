///NOTE
///2023.12. 14.
///채팅 교체 예정으로 일단 전체 주석 처리
// import 'package:flutter/widgets.dart';
//
// import 'package:matrix/matrix.dart';
//
// import 'date_time_extension.dart';
//
// extension RoomStatusExtension on Room {
//   CachedPresence? get directChatPresence => client.presences[directChatMatrixID];
//
//   String getLocalizedStatus(BuildContext context) {
//     if (isDirectChat) {
//       final directChatPresence = this.directChatPresence;
//       if (directChatPresence != null && (directChatPresence.lastActiveTimestamp != null || directChatPresence.currentlyActive != null)) {
//         if (directChatPresence.statusMsg?.isNotEmpty ?? false) {
//           return directChatPresence.statusMsg!;
//         }
//         if (directChatPresence.currentlyActive == true) {
//           return "현재 활동 중";
//         }
//         if (directChatPresence.lastActiveTimestamp == null) {
//           return "오래 전 접속";
//         }
//         final time = directChatPresence.lastActiveTimestamp!;
//         return "마지막 활동: ${time.localizedTimeShort(context)}";
//       }
//       return "오래 전 접속";
//     }
//     return "${summary.mJoinedMemberCount.toString()} 참여자";
//   }
//
//   // String getLocalizedTypingText(BuildContext context) {
//   //   var typingText = '';
//   //   final typingUsers = this.typingUsers;
//   //   typingUsers.removeWhere((User u) => u.id == client.userID);
//   //
//   //   if (AppConfig.hideTypingUsernames) {
//   //     typingText = L10n.of(context)!.isTyping;
//   //     if (typingUsers.first.id != directChatMatrixID) {
//   //       typingText =
//   //           L10n.of(context)!.numUsersTyping(typingUsers.length.toString());
//   //     }
//   //   } else if (typingUsers.length == 1) {
//   //     typingText = L10n.of(context)!.isTyping;
//   //     if (typingUsers.first.id != directChatMatrixID) {
//   //       typingText =
//   //           L10n.of(context)!.userIsTyping(typingUsers.first.calcDisplayname());
//   //     }
//   //   } else if (typingUsers.length == 2) {
//   //     typingText = L10n.of(context)!.userAndUserAreTyping(
//   //       typingUsers.first.calcDisplayname(),
//   //       typingUsers[1].calcDisplayname(),
//   //     );
//   //   } else if (typingUsers.length > 2) {
//   //     typingText = L10n.of(context)!.userAndOthersAreTyping(
//   //       typingUsers.first.calcDisplayname(),
//   //       (typingUsers.length - 1).toString(),
//   //     );
//   //   }
//   //   return typingText;
//   // }
//
//   List<User> getSeenByUsers(Timeline timeline, {String? eventId}) {
//     if (timeline.events.isEmpty) return [];
//     eventId ??= timeline.events.first.eventId;
//
//     final lastReceipts = <User>{};
//     // now we iterate the timeline events until we hit the first rendered event
//     for (final event in timeline.events) {
//       lastReceipts.addAll(event.receipts.map((r) => r.user));
//       if (event.eventId == eventId) {
//         break;
//       }
//     }
//     lastReceipts.removeWhere(
//       (user) => user.id == client.userID || user.id == timeline.events.first.senderId,
//     );
//     return lastReceipts.toList();
//   }
//
//   Event? get lastMessageEvent {
//     var lastTime = DateTime.fromMillisecondsSinceEpoch(0);
//     final lastEvents = client.roomPreviewLastEvents.map(getState).whereType<Event>();
//
//     var lastMsgEvents = lastEvents.where((element) {
//       return element.type == EventTypes.Message;
//     });
//
//     var lastEvent = lastMsgEvents.isEmpty
//         ? null
//         : lastMsgEvents.reduce((a, b) {
//             if (a.originServerTs == b.originServerTs) {
//               // if two events have the same sort order we want to give encrypted events a lower priority
//               // This is so that if the same event exists in the state both encrypted *and* unencrypted,
//               // the unencrypted one is picked
//               return a.type == EventTypes.Encrypted ? b : a;
//             }
//             return a.originServerTs.millisecondsSinceEpoch > b.originServerTs.millisecondsSinceEpoch ? a : b;
//           });
//     if (lastEvent == null) {
//       states.forEach((final String key, final entry) {
//         final state = entry[''];
//         if (state == null) return;
//         if (state.originServerTs.millisecondsSinceEpoch > lastTime.millisecondsSinceEpoch) {
//           lastTime = state.originServerTs;
//           lastEvent = state;
//         }
//       });
//     }
//     return lastEvent;
//   }
//
//   String getDisplayName([
//     MatrixLocalizations i18n = const MatrixDefaultLocalizations(),
//   ]) {
//     if (name.isNotEmpty) return name;
//
//     final canonicalAlias = this.canonicalAlias.localpart;
//     if (canonicalAlias != null && canonicalAlias.isNotEmpty) {
//       return canonicalAlias;
//     }
//
//     final directChatMatrixID = this.directChatMatrixID;
//     final heroes = summary.mHeroes ??
//         (directChatMatrixID == null ? [] : [directChatMatrixID]);
//     if (heroes.isNotEmpty) {
//       final result = heroes
//           .where((hero) => hero.isNotEmpty)
//           .map((hero) =>
//           unsafeGetUserFromMemoryOrFallback(hero)
//               .calcDisplayname(i18n: i18n))
//           .join(', ');
//       return result;
//     } else {
//       return i18n.emptyChat;
//     }
//   }
//
//   String getDmID([
//     MatrixLocalizations i18n = const MatrixDefaultLocalizations(),
//   ]) {
//     final directChatMatrixID = this.directChatMatrixID;
//     final heroes = summary.mHeroes ??
//         (directChatMatrixID == null ? [] : [directChatMatrixID]);
//     if (heroes.isNotEmpty) {
//       final result = heroes.first;
//       return result;
//     } else {
//       return '';
//     }
//   }
// }
