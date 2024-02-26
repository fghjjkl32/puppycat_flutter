import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/widget/chat_favorite_widget.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/widget/chat_room_widget.dart';

class ChatHomeScreen extends ConsumerStatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  ChatHomeScreenState createState() => ChatHomeScreenState();
}

class ChatHomeScreenState extends ConsumerState<ChatHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final isFavoriteListEmpty = ref.watch(chatFavoriteListEmptyProvider);
    // final isRoomListEmpty = ref.watch(chatRoomListEmptyProvider);
    // print('isFavoriteListEmpty $isFavoriteListEmpty');

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '메시지.메시지'.tr(),
            style: kTitle18BoldStyle.copyWith(color: kPreviousTextTitleColor, height: 1.4),
          ),
          backgroundColor: kWhiteColor,
          actions: [
            IconButton(
              onPressed: () async {
                context.push('/chatHome/chatSearch');
              },
              icon: Image.asset('assets/image/chat/icon_choice.png'),
              iconSize: 40,
            ),
          ],
        ),
        body: const Column(
          children: [
            ChatFavoriteWidget(),
            Expanded(child: ChatRoomWidget()),
          ],
        ),
      ),
    );
  }
}
