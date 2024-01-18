import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/widget/chat_empty_widget.dart';
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
    final isFavoriteListEmpty = ref.watch(chatFavoriteListEmptyProvider);
    final isRoomListEmpty = ref.watch(chatRoomListEmptyProvider);

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
                // context.push('/chatHome/chatSearch').then((value) async {
                //   print('chat Search value $value');
                // });
              },
              icon: Image.asset('assets/image/chat/icon_choice.png'),
              iconSize: 40,
            ),
          ],
        ),
        body: isRoomListEmpty
            ? ChatEmptyWidget(
                nick: ref.read(myInfoStateProvider).nick,
              )
            : Column(
                children: [
                  SizedBox(
                    height: isFavoriteListEmpty ? 0 : 72,
                    child: const ChatFavoriteWidget(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 18,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[kNeutralColor300, kNeutralColor100],
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: ChatRoomWidget(),
                  ),
                ],
              ),
      ),
    );
  }
}
