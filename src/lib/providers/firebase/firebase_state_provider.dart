import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/config/router/router.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_message_controller.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_cloud_message_payload.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/setting/notice_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_state_provider.g.dart';

@Riverpod(keepAlive: true)
class FirebaseState extends _$FirebaseState {
  @override
  FireBaseMessageController build() {
    GetIt.I.registerSingleton<FireBaseMessageController>(FireBaseMessageController());
    return GetIt.I<FireBaseMessageController>();
  }

  Future initFirebase() async {
    final fireBaseMessageController = GetIt.I<FireBaseMessageController>();
    await fireBaseMessageController.init();

    fireBaseMessageController.setBackgroundMessageOnTapHandler((payload) => navigatorHandler(payload));
    fireBaseMessageController.setForegroundMessageOnTapHandler((payload) => navigatorHandler(payload));

    state = fireBaseMessageController;
  }

  Future checkNotificationAppLaunch() async {
    if (state.initData != null) {
      navigatorHandler(state.initData!);
    }
  }

  void navigatorHandler(FirebaseCloudMessagePayload payload) {
    print("payload ::: ${payload.toJson()}");
    // context.push('/notification');
    final router = ref.read(routerProvider);
    final myInfo = ref.read(myInfoStateProvider);
    // router.go('/notification');

    PushType pushType = PushType.values.firstWhere((element) => payload.type == describeEnum(element), orElse: () => PushType.unknown);

    print("pushType : ${pushType}");

    switch (pushType) {
      case PushType.follow:
        router.push('/notification');
        break;
      case PushType.new_contents:
      case PushType.mention_contents:
      case PushType.like_contents:
      case PushType.img_tag:
        Map<String, dynamic> extraMap = {
          'firstTitle': myInfo.nick ?? 'nickname',
          'secondTitle': '피드',
          'memberUuid': myInfo.uuid,
          'contentIdx': payload.contentsIdx,
          'contentType': 'notificationContent',
        };

        ref.read(feedDetailParameterProvider.notifier).state = extraMap;

        router.push('/feed/detail', extra: extraMap);
        // router.push("/feed/detail/Contents/피드/${myInfo.uuid}/${payload.contentsIdx}/notificationContent");
        break;

      case PushType.new_comment:
      case PushType.new_reply:
      case PushType.mention_comment:
      case PushType.like_comment:
        Map<String, dynamic> extraMap = {
          "isRouteComment": true,
          "focusIdx": payload.commentIdx,
          'firstTitle': myInfo.nick ?? 'nickname',
          'secondTitle': '피드',
          'memberUuid': myInfo.uuid,
          'contentIdx': payload.contentsIdx,
          'contentType': 'notificationContent',
        };

        ref.read(feedDetailParameterProvider.notifier).state = extraMap;

        router.push('/feed/detail', extra: extraMap);
        // router.push("/feed/detail/nickname/피드/${myInfo.uuid}/${payload.contentsIdx}/notificationContent", extra: {
        //   "isRouteComment": true,
        //   "focusIdx": payload.commentIdx,
        // });
        break;

      case PushType.notice:
      case PushType.event:
        ref.read(noticeFocusIdxStateProvider.notifier).state = int.parse(payload.contentsIdx);
        ref.read(noticeExpansionIdxStateProvider.notifier).state = int.parse(payload.contentsIdx);
        router.push("/setting/notice", extra: {
          "contentsIdx": payload.contentsIdx,
        });
        break;
      case PushType.chatting:
        if (payload.chat == null) {
          break;
        }
        final Map<String, dynamic> chatData = jsonDecode(payload.chat!);

        ref.read(chatRoomListStateProvider.notifier).enterChatRoom(
              targetMemberUuid: chatData['targetUuid'] ?? '',
              titleName: payload.title ?? 'unknown',
              targetProfileImgUrl: chatData['senderMemberProfileImg'] ?? '',
            );
        break;
      case PushType.unknown:
        return;
    }
  }
}
