import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/chat_home_screen.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/chat_room_screen.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/chat_search_screen.dart';

class ChatHomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatHomeScreen();
  }

  GoRoute createRoute() {
    return GoRoute(
      path: '/chatHome',
      name: 'chatHome',
      builder: (context, state) => build(context, state),
      routes: [
        ChatRoomRoute().createRoute(),
        ChatSearchRoute().createRoute(),
      ],
    );
  }
}

class ChatRoomRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'chatRoom',
      name: 'chatRoom',
      builder: (BuildContext context, GoRouterState state) {
        if (state.extra is Map) {
          Map<String, dynamic> extraMap = state.extra! as Map<String, dynamic>;
          if (extraMap.containsKey('roomId')) {
            print('extraMap roomId ${extraMap['roomId']}');
            String roomId = extraMap['roomId'] ?? '';
            String nick = extraMap['nick'] ?? 'unknown';
            String? profileImgUrl = extraMap['profileImgUrl'];
            String targetMemberUuid = extraMap['targetMemberUuid'];

            return ChatRoomScreen(
              roomId: roomId,
              nick: nick,
              profileImgUrl: profileImgUrl,
              targetMemberUuid: targetMemberUuid,
            );
          } else {
            return const ChatHomeScreen();
          }
          // return ChatRoomScreen(titleNick: 'testNick', msgList: [],);
        } else {
          return const ChatHomeScreen();
        }
      },
    );
  }
}

class ChatSearchRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'chatSearch',
      name: 'chatSearch',
      builder: (BuildContext context, GoRouterState state) {
        return const ChatSearchScreen();
      },
    );
  }
}
