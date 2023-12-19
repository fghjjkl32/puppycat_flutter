import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class ChatEmptyWidget extends ConsumerStatefulWidget {
  final String? nick;

  const ChatEmptyWidget({
    super.key,
    this.nick,
  });

  @override
  ChatEmptyWidgetState createState() => ChatEmptyWidgetState();
}

class ChatEmptyWidgetState extends ConsumerState<ChatEmptyWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/chat/empty_character_01_nopost_88_x2.png',
                width: 88,
                height: 88,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                '${widget.nick}${'메시지.님'.tr()}\n${'메시지.첫 메시지를 보내 보세요'.tr()}',
                style: kBody14RegularStyle.copyWith(color: kNeutralColor500, height: 1.4, letterSpacing: 0.2),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                // final channel = await ref.read(chatBroadCastStateProvider);
                // channel.sendBroadCast('testMsg');
              },
              child: const Text('test'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  // width: 320,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/chatHome/chatSearch');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPreviousPrimaryColor,
                      disabledBackgroundColor: kNeutralColor400,
                      disabledForegroundColor: kPreviousTextBodyColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '메시지.메시지 보내기'.tr(),
                      style: kButton14MediumStyle.copyWith(
                        color: kWhiteColor,
                        height: 1.4,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
